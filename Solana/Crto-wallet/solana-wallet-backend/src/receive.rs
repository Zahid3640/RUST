use actix_web::{post, web, HttpResponse, Responder};
use serde::{Deserialize, Serialize};

use bip39::{Language, Mnemonic};
use ed25519_dalek::{Keypair, PublicKey, SecretKey};
use slip10_ed25519::derive_ed25519_private_key;
use qrcode::{QrCode, render::svg};
use bs58;

/// Request body: pass EITHER seed_phrase OR public_address
#[derive(Deserialize)]
pub struct ReceiveRequest {
    /// 12/24-word phrase (optional)
    pub seed_phrase: Option<String>,
    /// Base58 Solana address (optional)
    pub public_address: Option<String>,
}

/// Response shape (as you requested)
#[derive(Serialize)]
pub struct ReceiveResponse {
    pub public_address: String,
    pub qr_code_svg_base64: String,
}

fn pubkey_from_seed_phrase(seed_phrase: &str) -> Result<String, String> {
    // 1) Parse mnemonic
    let mnemonic = Mnemonic::parse_in_normalized(Language::English, seed_phrase)
        .map_err(|_| "Invalid seed phrase".to_string())?;

    // 2) 64-byte seed from mnemonic (no passphrase)
    let seed: [u8; 64] = mnemonic.to_seed("");

    // 3) Derive Solana account #0 at m/44'/501'/0'/0'
    //    (indices hardened -> add 0x8000_0000)
    let path = [
        44 + 0x8000_0000,
        501 + 0x8000_0000,
        0 + 0x8000_0000,
        0 + 0x8000_0000,
    ];
    let sk32 = derive_ed25519_private_key(&seed, &path);

    // 4) Build ed25519 keypair and return Base58 public key (Solana address)
    let secret = SecretKey::from_bytes(&sk32)
        .map_err(|_| "Failed to build SecretKey from derived bytes".to_string())?;
    let public = PublicKey::from(&secret);
    let keypair = Keypair { secret, public };

    Ok(bs58::encode(keypair.public.to_bytes()).into_string())
}

fn make_qr_svg_base64(text: &str) -> Result<String, String> {
    let code = QrCode::new(text).map_err(|e| format!("QR encode failed: {e}"))?;
    let svg_str = code
        .render::<svg::Color>()
        .min_dimensions(200, 200)
        .build();
    Ok(base64::encode(svg_str))
}

#[post("/receive")]
pub async fn receive_wallet(req: web::Json<ReceiveRequest>) -> impl Responder {
    // Decide where to get the address from
    let public_address_res: Result<String, String> = if let Some(addr) = &req.public_address {
        // Use provided address directly (basic sanity check: Base58 decode)
        if bs58::decode(addr).into_vec().map(|v| v.len() == 32).unwrap_or(false) {
            Ok(addr.clone())
        } else {
            Err("Invalid public_address (must be base58-encoded 32 bytes)".to_string())
        }
    } else if let Some(phrase) = &req.seed_phrase {
        pubkey_from_seed_phrase(phrase)
    } else {
        Err("Provide either seed_phrase or public_address".to_string())
    };

    match public_address_res {
        Ok(public_address) => match make_qr_svg_base64(&public_address) {
            Ok(qr_code_svg_base64) => {
                HttpResponse::Ok().json(ReceiveResponse { public_address, qr_code_svg_base64 })
            }
            Err(e) => HttpResponse::InternalServerError().json(serde_json::json!({
                "status": "error",
                "message": e
            })),
        },
        Err(e) => HttpResponse::BadRequest().json(serde_json::json!({
            "status": "error",
            "message": e
        })),
    }
}
