// src/wallet.rs
use actix_web::{post, web, HttpResponse, Responder};
use bip39::{Language, Mnemonic};
use slip10_ed25519::derive_ed25519_private_key;
use ed25519_dalek::{Keypair, PublicKey, SecretKey};
use rand::rngs::OsRng;
use rand::RngCore;
use serde::{Deserialize, Serialize};
use serde_json::json;
use std::fs;

use argon2::{Argon2, Params, Algorithm, Version, password_hash::PasswordHasher};
use aes_gcm::{Aes256Gcm, aead::{Aead, KeyInit, OsRng as AeadOsRng}, Nonce};
use base64::{engine::general_purpose, Engine as _};

// ---------- Request/Response structs ----------
#[derive(Debug, Deserialize)]
struct CreateRequest {
    password: String,
    confirm_password: String,
}

#[derive(Debug, Deserialize)]
struct ImportRequest {
    mnemonic: Option<String>,
    private_key: Option<String>,
    password: String,
    confirm_password: String,
}

#[derive(Debug, Deserialize)]
struct UnlockRequest {
    password: String,
}

// ---------- Stored wallet structure ----------
#[derive(Debug, Serialize, Deserialize)]
struct StoredWallet {
    version: u8,
    public_key: String,
    kdf: KdfMeta,
    crypto: CryptoMeta,
}

#[derive(Debug, Serialize, Deserialize)]
struct KdfMeta {
    algo: String,
    salt_b64: String,
    m_cost: u32,
    t_cost: u32,
    p_cost: u32,
}

#[derive(Debug, Serialize, Deserialize)]
struct CryptoMeta {
    cipher: String,
    nonce_b64: String,
    ciphertext_b64: String,
}

// ---------- File helpers ----------
fn save_wallet(wallet: &StoredWallet) -> Result<(), String> {
    fs::write("wallet.json", serde_json::to_string_pretty(wallet).map_err(|e| e.to_string())?)
        .map_err(|e| e.to_string())
}

fn load_wallet() -> Result<StoredWallet, String> {
    let data = fs::read_to_string("wallet.json").map_err(|e| e.to_string())?;
    serde_json::from_str(&data).map_err(|e| e.to_string())
}

// ---------- KDF + Encryption helpers ----------
fn derive_key(password: &str, kdf: &KdfMeta) -> Result<[u8; 32], String> {
    let salt_bytes = general_purpose::STANDARD.decode(&kdf.salt_b64).map_err(|e| e.to_string())?;
    let params = Params::new(kdf.m_cost, kdf.t_cost, kdf.p_cost, Some(32)).map_err(|e| e.to_string())?;
    let argon = Argon2::new(Algorithm::Argon2id, Version::V0x13, params);

    let mut key = [0u8; 32];
    argon.hash_password_into(password.as_bytes(), &salt_bytes, &mut key).map_err(|e| e.to_string())?;
    Ok(key)
}

fn encrypt_payload(key: &[u8; 32], plaintext_json: &serde_json::Value) -> Result<CryptoMeta, String> {
    let cipher = Aes256Gcm::new_from_slice(key).map_err(|e| e.to_string())?;
    let mut nonce_bytes = [0u8; 12];
    AeadOsRng.fill_bytes(&mut nonce_bytes);
    let nonce = Nonce::from_slice(&nonce_bytes);

    let pt = serde_json::to_vec(plaintext_json).map_err(|e| e.to_string())?;
    let ct = cipher.encrypt(nonce, pt.as_ref()).map_err(|e| e.to_string())?;

    Ok(CryptoMeta {
        cipher: "aes-256-gcm".to_string(),
        nonce_b64: general_purpose::STANDARD.encode(nonce_bytes),
        ciphertext_b64: general_purpose::STANDARD.encode(ct),
    })
}

fn decrypt_payload(key: &[u8; 32], crypto: &CryptoMeta) -> Result<(), String> {
    let cipher = Aes256Gcm::new_from_slice(key).map_err(|e| e.to_string())?;
    let nonce_bytes = general_purpose::STANDARD.decode(&crypto.nonce_b64).map_err(|e| e.to_string())?;
    let ct = general_purpose::STANDARD.decode(&crypto.ciphertext_b64).map_err(|e| e.to_string())?;
    let nonce = Nonce::from_slice(&nonce_bytes);

    cipher.decrypt(nonce, ct.as_ref()).map_err(|_| "Invalid password".to_string())?;
    Ok(())
}

fn new_kdf_meta() -> KdfMeta {
    let mut salt = [0u8; 16];
    OsRng.fill_bytes(&mut salt);
    KdfMeta {
        algo: "argon2id".to_string(),
        salt_b64: general_purpose::STANDARD.encode(salt),
        m_cost: 19456,
        t_cost: 2,
        p_cost: 1,
    }
}

// ---------- Derive Ed25519 ----------
fn derive_from_seed(seed: &[u8]) -> (String, String, String) {
    let path: [u32; 4] = [
        44 | 0x8000_0000,
        501 | 0x8000_0000,
        0 | 0x8000_0000,
        0 | 0x8000_0000,
    ];
    let sk32 = derive_ed25519_private_key(seed, &path);
    let secret = SecretKey::from_bytes(&sk32).unwrap();
    let public = PublicKey::from(&secret);
    let keypair = Keypair { secret, public };

    let public_key_b58 = bs58::encode(keypair.public.to_bytes()).into_string();
    let mut pk64 = [0u8; 64];
    pk64[..32].copy_from_slice(&keypair.secret.to_bytes());
    pk64[32..].copy_from_slice(&keypair.public.to_bytes());
    let private_key_b58 = bs58::encode(pk64).into_string();

    (public_key_b58, private_key_b58, bs58::encode(sk32).into_string())
}

// ---------- CREATE ----------
#[post("/create_wallet")]
async fn create_wallet(req: web::Json<CreateRequest>) -> impl Responder {
    if req.password != req.confirm_password {
        return HttpResponse::BadRequest().json(json!({"status":"error","message":"Passwords do not match"}));
    }

    let mut entropy = [0u8; 16];
    OsRng.fill_bytes(&mut entropy);
    let mnemonic = Mnemonic::from_entropy(&entropy).unwrap();
    let seed_phrase = mnemonic.to_string();
    let seed = mnemonic.to_seed("");
    println!("Seed phrase: {}", seed_phrase);

    let (public_key_b58, private_key_b58, _) = derive_from_seed(&seed);
    println!("Public key: {}", public_key_b58);
    println!("Private key: {}", private_key_b58);

    let secret_payload = json!({
        "seed_phrase": seed_phrase,
        "private_key": private_key_b58
    });

    let kdf = new_kdf_meta();
    let key = derive_key(&req.password, &kdf).unwrap();
    let crypto = encrypt_payload(&key, &secret_payload).unwrap();

    let stored = StoredWallet { version: 1, public_key: public_key_b58.clone(), kdf, crypto };
    save_wallet(&stored).unwrap();

    HttpResponse::Ok().json(json!({"status":"success",
    "public_key": public_key_b58,
    "seed_phrase": seed_phrase,
    "private_key": private_key_b58}))
}

// ---------- IMPORT ----------
#[post("/import_wallet")]
async fn import_wallet(req: web::Json<ImportRequest>) -> impl Responder {
    let b = req.into_inner();
    if b.password != b.confirm_password {
        return HttpResponse::BadRequest().json(json!({"status":"error","message":"Passwords do not match"}));
    }

    let (public_key_b58, private_key_b58, seed_phrase_opt) = if let Some(mn) = b.mnemonic {
        // 🪄 mnemonic import
        let m = Mnemonic::parse_in_normalized(Language::English, &mn).unwrap();
        let seed = m.to_seed("");
        let (pub_b58, prv_b58, _) = derive_from_seed(&seed);
        (pub_b58, prv_b58, Some(m.to_string()))
    } else if let Some(pk_b58_64) = b.private_key {
        // 🔑 private key import
        let raw = bs58::decode(&pk_b58_64).into_vec().unwrap();
        let secret = SecretKey::from_bytes(&raw[0..32]).unwrap();
        let public = PublicKey::from(&secret);
        let keypair = Keypair { secret, public };
        let public_key_b58 = bs58::encode(keypair.public.to_bytes()).into_string();
        (public_key_b58, pk_b58_64, None)
    } else {
        return HttpResponse::BadRequest()
            .json(json!({"status":"error","message":"Provide mnemonic or private_key"}));
    };

    // 📦 payload to encrypt & save
    let payload = if let Some(seed_phrase) = &seed_phrase_opt {
        json!({ "seed_phrase": seed_phrase, "private_key": private_key_b58 })
    } else {
        json!({  "private_key": private_key_b58 })
    };

    let kdf = new_kdf_meta();
    let key = derive_key(&b.password, &kdf).unwrap();
    let crypto = encrypt_payload(&key, &payload).unwrap();

    let stored = StoredWallet { version: 1, public_key: public_key_b58.clone(), kdf, crypto };
    save_wallet(&stored).unwrap();

    // ✅ Response me seed_phrase + private_key dono show hoga
    HttpResponse::Ok().json(json!({
        "status": "success",
        "public_key": public_key_b58,
        "private_key": private_key_b58,
        "seed_phrase": seed_phrase_opt.unwrap_or("".to_string())
    }))
}
#[post("/unlock_wallet")]
async fn unlock_wallet(req: web::Json<UnlockRequest>) -> impl Responder {
    let stored = match load_wallet() {
        Ok(w) => w,
        Err(e) => return HttpResponse::InternalServerError().json(json!({"status":"error","message": e})),
    };

    // 🔑 derive key from password
    let key = match derive_key(&req.password, &stored.kdf) {
        Ok(k) => k,
        Err(e) => return HttpResponse::InternalServerError().json(json!({"status":"error","message": e})),
    };

    // 🔓 decrypt payload
    let cipher = Aes256Gcm::new_from_slice(&key).unwrap();
    let nonce_bytes = base64::decode(&stored.crypto.nonce_b64).unwrap();
    let ct = base64::decode(&stored.crypto.ciphertext_b64).unwrap();
    let nonce = Nonce::from_slice(&nonce_bytes);

    let pt = match cipher.decrypt(nonce, ct.as_ref()) {
        Ok(v) => v,
        Err(_) => return HttpResponse::Unauthorized().json(json!({"status":"error","message":"Invalid password"})),
    };

    // 📦 decrypted JSON (contains seed + private key)
    let secret_payload: serde_json::Value = serde_json::from_slice(&pt).unwrap();

    let seed_phrase = secret_payload.get("seed_phrase").and_then(|v| v.as_str()).unwrap_or("").to_string();
    let private_key = secret_payload.get("private_key").and_then(|v| v.as_str()).unwrap_or("").to_string();

    HttpResponse::Ok().json(json!({
        "status": "success",
        "public_key": stored.public_key,
        "seed_phrase": seed_phrase,
        "private_key": private_key
    }))
}

