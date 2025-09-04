// src/import_wallet.rs
use actix_web::{post, web, HttpResponse, Responder};
use serde::Deserialize;
use ed25519_dalek::{Keypair, PublicKey, SecretKey};
use serde_json::json;
use std::error::Error;
use bip39::{Language, Mnemonic};
use slip10_ed25519::derive_ed25519_private_key;
use argon2::{Argon2, PasswordHasher, PasswordVerifier};
use argon2::password_hash::{SaltString, PasswordHash, rand_core::OsRng};
use std::sync::Mutex;

lazy_static::lazy_static! {
    static ref PASSWORD_DB: Mutex<Option<String>> = Mutex::new(None);
}

#[derive(Deserialize)]
pub struct ImportRequest {
    pub mnemonic: Option<String>,
    pub private_key: Option<String>,
    pub password: Option<String>,
    pub confirm_password: Option<String>,
}

/// ✅ Import from mnemonic
pub fn import_from_mnemonic_json(seed_phrase: &str) -> Result<serde_json::Value, Box<dyn Error>> {
    let mnemonic = Mnemonic::parse_in_normalized(Language::English, seed_phrase)
        .map_err(|e| format!("Invalid seed phrase: {}", e))?;
    let seed = mnemonic.to_seed("");

    let path: [u32; 4] = [
        44 | 0x8000_0000,
        501 | 0x8000_0000,
        0 | 0x8000_0000,
        0 | 0x8000_0000,
    ];

    let derived = derive_ed25519_private_key(&seed, &path);

    let secret = SecretKey::from_bytes(&derived)?;
    let public = PublicKey::from(&secret);
    let keypair = Keypair { secret, public };

    let public_key_base58 = bs58::encode(keypair.public.to_bytes()).into_string();

    let mut private_key_64 = [0u8; 64];
    private_key_64[..32].copy_from_slice(&keypair.secret.to_bytes());
    private_key_64[32..].copy_from_slice(&keypair.public.to_bytes());
    let private_key_base58 = bs58::encode(private_key_64).into_string();

    Ok(json!({
        "status": "ok",
        "source": "mnemonic",
        "public_key": public_key_base58,
        "private_key": private_key_base58
    }))
}

/// ✅ Import from private key
pub fn import_from_private_key_json(private_key_base58: &str) -> Result<serde_json::Value, Box<dyn Error>> {
    let private_key_bytes = bs58::decode(private_key_base58)
        .into_vec()
        .map_err(|e| format!("Invalid base58 private key: {}", e))?;

    if private_key_bytes.len() != 64 {
        return Err(format!(
            "Invalid private key length: expected 64 bytes, got {}",
            private_key_bytes.len()
        ).into());
    }

    let secret = SecretKey::from_bytes(&private_key_bytes[0..32])?;
    let public = PublicKey::from(&secret);
    let keypair = Keypair { secret, public };

    let public_key_base58 = bs58::encode(keypair.public.to_bytes()).into_string();

    Ok(json!({
        "status": "ok",
        "source": "private_key",
        "public_key": public_key_base58,
    }))
}

/// ✅ Import Wallet API
#[post("/import_wallet")]
pub async fn import_wallet_handler(req: web::Json<ImportRequest>) -> impl Responder {
    let body = req.into_inner();

    if body.password.is_none() || body.confirm_password.is_none() {
        return HttpResponse::BadRequest().json(json!({
            "status":"error",
            "message":"Password and Confirm Password are required"
        }));
    }

    let password = body.password.unwrap();
    let confirm_password = body.confirm_password.unwrap();

    if password != confirm_password {
        return HttpResponse::BadRequest().json(json!({
            "status":"error",
            "message":"Password and Confirm Password do not match"
        }));
    }

    // ✅ Hash password with Argon2
    let salt = SaltString::generate(&mut OsRng);
    let argon2 = Argon2::default();
    let password_hash = argon2.hash_password(password.as_bytes(), &salt)
        .unwrap()
        .to_string();

    {
        let mut db = PASSWORD_DB.lock().unwrap();
        *db = Some(password_hash.clone());
    }

    // ✅ Import via Mnemonic
    if let Some(mnemonic) = body.mnemonic {
        match import_from_mnemonic_json(&mnemonic) {
            Ok(mut json_val) => {
                if let Some(obj) = json_val.as_object_mut() {
                    obj.insert("password_set".to_string(), json!(true));
                }
                HttpResponse::Ok().json(json_val)
            }
            Err(e) => HttpResponse::BadRequest().json(json!({"status":"error","message": e.to_string()})),
        }

    // ✅ Import via Private Key
    } else if let Some(pk) = body.private_key {
        match import_from_private_key_json(&pk) {
            Ok(mut json_val) => {
                if let Some(obj) = json_val.as_object_mut() {
                    obj.insert("password_set".to_string(), json!(true));
                }
                HttpResponse::Ok().json(json_val)
            }
            Err(e) => HttpResponse::BadRequest().json(json!({"status":"error","message": e.to_string()})),
        }

    } else {
        HttpResponse::BadRequest().json(json!({"status":"error","message":"Provide mnemonic or private_key"}))
    }
}

/// ✅ Unlock Wallet API
#[derive(Deserialize)]
pub struct UnlockRequest {
    pub password: String,
}

#[post("/U/unlock_wallet")]
pub async fn unlock_wallet_handler(req: web::Json<UnlockRequest>) -> impl Responder {
    let body = req.into_inner();

    let db = PASSWORD_DB.lock().unwrap();
    if let Some(stored_hash) = db.clone() {
        let parsed_hash = PasswordHash::new(&stored_hash).unwrap();
        let argon2 = Argon2::default();

        if argon2.verify_password(body.password.as_bytes(), &parsed_hash).is_ok() {
            HttpResponse::Ok().json(json!({"status":"success","message":"Wallet unlocked"}))
        } else {
            HttpResponse::Unauthorized().json(json!({"status":"error","message":"Invalid password"}))
        }
    } else {
        HttpResponse::BadRequest().json(json!({"status":"error","message":"No wallet found"}))
    }
}



// // src/import_wallet.rs
// use actix_web::{post, web, HttpResponse, Responder};
// use serde::Deserialize;
// use ed25519_dalek::{Keypair, PublicKey, SecretKey};
// use serde_json::json;
// use std::error::Error;
// use bip39::{Language, Mnemonic};
// use slip10_ed25519::derive_ed25519_private_key;

// #[derive(Deserialize)]
// pub struct ImportRequest {
//     pub mnemonic: Option<String>,
//     pub private_key: Option<String>,
//     pub password: Option<String>,
//     pub confirm_password: Option<String>,
// }

// /// ✅ Import from mnemonic (Solana derivation m/44'/501'/0'/0')
// pub fn import_from_mnemonic_json(seed_phrase: &str) -> Result<serde_json::Value, Box<dyn Error>> {
//     let mnemonic = Mnemonic::parse_in_normalized(Language::English, seed_phrase)
//         .map_err(|e| format!("Invalid seed phrase: {}", e))?;
//    let seed = mnemonic.to_seed("");

//     // Solana BIP44 derivation path
//      let path: [u32; 4] = [
//         44 | 0x8000_0000,
//         501 | 0x8000_0000,
//         0 | 0x8000_0000,
//         0 | 0x8000_0000,
//     ];

//     let derived = derive_ed25519_private_key(&seed, &path);

//     let secret = SecretKey::from_bytes(&derived)?; 
//     let public = PublicKey::from(&secret);
//     let keypair = Keypair { secret, public };

//     let public_key_base58 = bs58::encode(keypair.public.to_bytes()).into_string();

//     let mut private_key_64 = [0u8; 64];
//     private_key_64[..32].copy_from_slice(&keypair.secret.to_bytes());
//     private_key_64[32..].copy_from_slice(&keypair.public.to_bytes());
//     let private_key_base58 = bs58::encode(private_key_64).into_string();

//     Ok(json!({
//         "status": "ok",
//         "source": "mnemonic",
//         "public_key": public_key_base58,
//         "private_key": private_key_base58
//     }))
// }

// /// ✅ Import from base58 private key
// pub fn import_from_private_key_json(private_key_base58: &str) -> Result<serde_json::Value, Box<dyn Error>> {
//     let private_key_bytes = bs58::decode(private_key_base58)
//         .into_vec()
//         .map_err(|e| format!("Invalid base58 private key: {}", e))?;

//     if private_key_bytes.len() != 64 {
//         return Err(format!(
//             "Invalid private key length: expected 64 bytes, got {}",
//             private_key_bytes.len()
//         )
//         .into());
//     }

//     let secret = SecretKey::from_bytes(&private_key_bytes[0..32])?;
//     let public = PublicKey::from(&secret);
//     let keypair = Keypair { secret, public };

//     let public_key_base58 = bs58::encode(keypair.public.to_bytes()).into_string();

//     Ok(json!({
//         "status": "ok",
//         "source": "private_key",
//         "public_key": public_key_base58,
//     }))
// }

// /// ✅ Actix handler (API endpoint)
// #[post("/import_wallet")]
// pub async fn import_wallet_handler(req: web::Json<ImportRequest>) -> impl Responder {
//     let body = req.into_inner();

//     // ✅ Check password
//     if body.password.is_none() || body.confirm_password.is_none() {
//         return HttpResponse::BadRequest()
//             .content_type("application/json")
//             .body(
//                 json!({"status":"error","message":"Password and Confirm Password are required"}).to_string()
//             );
//     }

//     let password = body.password.unwrap();
//     let confirm_password = body.confirm_password.unwrap();

//     if password != confirm_password {
//         return HttpResponse::BadRequest()
//             .content_type("application/json")
//             .body(
//                 json!({"status":"error","message":"Password and Confirm Password do not match"}).to_string()
//             );
//     }

//     // ✅ Import via Mnemonic
//     if let Some(mnemonic) = body.mnemonic {
//         match import_from_mnemonic_json(&mnemonic) {
//             Ok(mut json_val) => {
//                 if let Some(obj) = json_val.as_object_mut() {
//                     obj.insert("password_set".to_string(), json!(true));
//                 }
//                 HttpResponse::Ok()
//                     .content_type("application/json")
//                     .body(json_val.to_string())
//             }
//             Err(e) => HttpResponse::BadRequest()
//                 .content_type("application/json")
//                 .body(json!({"status":"error","message": format!("{}", e)}).to_string()),
//         }

//     // ✅ Import via Private Key
//     } else if let Some(pk) = body.private_key {
//         match import_from_private_key_json(&pk) {
//             Ok(mut json_val) => {
//                 if let Some(obj) = json_val.as_object_mut() {
//                     obj.insert("password_set".to_string(), json!(true));
//                 }
//                 HttpResponse::Ok()
//                     .content_type("application/json")
//                     .body(json_val.to_string())
//             }
//             Err(e) => HttpResponse::BadRequest()
//                 .content_type("application/json")
//                 .body(json!({"status":"error","message": format!("{}", e)}).to_string()),
//         }

//     // ❌ Neither mnemonic nor private key provided
//     } else {
//         HttpResponse::BadRequest()
//             .content_type("application/json")
//             .body(json!({"status":"error","message":"Provide mnemonic or private_key"}).to_string())
//     }
// }
