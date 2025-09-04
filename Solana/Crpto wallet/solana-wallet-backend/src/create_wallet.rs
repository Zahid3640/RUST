// use actix_web::{post, web, App, HttpResponse, HttpServer, Responder};
// use bip39::Mnemonic;
// use slip10_ed25519::derive_ed25519_private_key;
// use ed25519_dalek::{Keypair, SecretKey, PublicKey};
// use rand::rngs::OsRng;
// use rand::RngCore;
// use serde::{Deserialize, Serialize};
// use serde_json::json;
// use argon2::password_hash::{SaltString, PasswordHash};
// //use argon2::password_hash::{SaltString, PasswordHash};
// use std::fs;

// #[derive(Debug, Deserialize)]
// struct CreateRequest {
//     password: String,
//     confirm_password: String,
// }

// #[derive(Debug, Deserialize)]
// struct UnlockRequest {
//     password: String,
// }

// #[derive(Debug, Serialize, Deserialize)]
// struct StoredWallet {
//     seed_phrase: String,
//     public_key: String,
//     private_key: String,
//     password_hash: String,
// }

// // -------------------- CREATE WALLET --------------------
// #[post("/create_wallet")]
// async fn create_wallet(req: web::Json<CreateRequest>) -> impl Responder {
//     let password = &req.password;
//     let confirm_password = &req.confirm_password;

//     if password.is_empty() || confirm_password.is_empty() {
//         return HttpResponse::BadRequest().json(json!({
//             "status": "error",
//             "message": "Password and Confirm Password are required"
//         }));
//     }

//     if password != confirm_password {
//         return HttpResponse::BadRequest().json(json!({
//             "status": "error",
//             "message": "Passwords do not match"
//         }));
//     }

//     // entropy → mnemonic
//     let mut entropy = [0u8; 16];
//     OsRng.fill_bytes(&mut entropy);
//     let mnemonic = Mnemonic::from_entropy(&entropy).unwrap();
//     let seed_phrase = mnemonic.to_string();
//     let seed = mnemonic.to_seed("");

//     // path m/44'/501'/0'/0'
//     let path: [u32; 4] = [
//         44 | 0x8000_0000,
//         501 | 0x8000_0000,
//         0 | 0x8000_0000,
//         0 | 0x8000_0000,
//     ];

//     let private_key_bytes = derive_ed25519_private_key(&seed, &path);
//     let secret = SecretKey::from_bytes(&private_key_bytes).unwrap();
//     let public = PublicKey::from(&secret);
//     let keypair = Keypair { secret, public };

//     let public_key_base58 = bs58::encode(keypair.public.to_bytes()).into_string();

//     let mut private_key_64 = [0u8; 64];
//     private_key_64[..32].copy_from_slice(&keypair.secret.to_bytes());
//     private_key_64[32..].copy_from_slice(&keypair.public.to_bytes());
//     let private_key_base58 = bs58::encode(private_key_64).into_string();

//     // hash password
//     let salt = SaltString::generate(&mut rand::thread_rng());
//     let argon2 = Argon2::default();
//     let password_hash = argon2.hash_password(password.as_bytes(), &salt).unwrap().to_string();

//     // save wallet info in file/db
//     let stored_wallet = StoredWallet {
//         seed_phrase: seed_phrase.clone(),
//         public_key: public_key_base58.clone(),
//         private_key: private_key_base58.clone(),
//         password_hash,
//     };

//     fs::write("wallet.json", serde_json::to_string_pretty(&stored_wallet).unwrap()).unwrap();

//     HttpResponse::Ok().json(json!({
//         "status": "success",
//         "message": "Wallet created & stored successfully",
//         "seed_phrase": seed_phrase,
//         "private_key": private_key_base58,
//         "public_key": public_key_base58
        
//     }))
// }

// // -------------------- UNLOCK WALLET --------------------
// #[post("/unlock_wallet")]
// async fn unlock_wallet(req: web::Json<UnlockRequest>) -> impl Responder {
//     let password = &req.password;

//     let data = fs::read_to_string("wallet.json");
//     if data.is_err() {
//         return HttpResponse::NotFound().json(json!({
//             "status": "error",
//             "message": "No wallet found, create one first"
//         }));
//     }

//     let stored: StoredWallet = serde_json::from_str(&data.unwrap()).unwrap();
//     let parsed_hash = PasswordHash::new(&stored.password_hash).unwrap();

//     if Argon2::default().verify_password(password.as_bytes(), &parsed_hash).is_ok() {
//         HttpResponse::Ok().json(json!({
//             "status": "success",
//             "message": "Wallet unlocked",
//             "public_key": stored.public_key,
//             "seed_phrase": stored.seed_phrase,
//             "private_key": stored.private_key
//         }))
//     } else {
//         HttpResponse::Unauthorized().json(json!({
//             "status": "error",
//             "message": "Invalid password"
//         }))
//     }
// }

// use bip39::{Language, Mnemonic};
// use slip10_ed25519::derive_ed25519_private_key;
// use ed25519_dalek::{Keypair, SecretKey, PublicKey};
// use rand::rngs::OsRng;
// use rand::RngCore;
// use serde_json::json;

// pub fn create_wallet(password: &str, confirm_password: &str) -> String {
//     // 0) Check password validation
//     if password.is_empty() || confirm_password.is_empty() {
//         return json!({
//             "status": "error",
//             "message": "Password and Confirm Password are required"
//         })
//         .to_string();
//     }

//     if password != confirm_password {
//         return json!({
//             "status": "error",
//             "message": "Password and Confirm Password do not match"
//         })
//         .to_string();
//     }

//     // 1) 128-bit entropy
//     let mut entropy = [0u8; 16];
//     OsRng.fill_bytes(&mut entropy);

//     // 2) Mnemonic & seed (64 bytes)
//     let mnemonic = Mnemonic::from_entropy(&entropy).unwrap();
//     let seed_phrase = mnemonic.to_string();
//     let seed = mnemonic.to_seed(""); // [u8; 64]

//     // 3) Solana BIP44 path: m/44'/501'/0'/0'
//     let path: [u32; 4] = [
//         44 | 0x8000_0000,
//         501 | 0x8000_0000,
//         0 | 0x8000_0000,
//         0 | 0x8000_0000,
//     ];

//     // 4) Derive 32-byte private key
//     let private_key_bytes = derive_ed25519_private_key(&seed, &path);

//     // 5) Dalek keypair
//     let secret = SecretKey::from_bytes(&private_key_bytes).unwrap();
//     let public = PublicKey::from(&secret);
//     let keypair = Keypair { secret, public };

//     // 6) Base58 outputs
//     let public_key_base58 = bs58::encode(keypair.public.to_bytes()).into_string();

//     let mut private_key_64 = [0u8; 64];
//     private_key_64[..32].copy_from_slice(&keypair.secret.to_bytes());
//     private_key_64[32..].copy_from_slice(&keypair.public.to_bytes());
//     let private_key_base58 = bs58::encode(private_key_64).into_string();

//     // 7) JSON response
//     json!({
//         "status": "success",
//         "message": "Wallet created successfully",
//         "seed_phrase": seed_phrase,
//         "public_key": public_key_base58,
//         "private_key": private_key_base58,
//         "password_set": true
//     })
//     .to_string()
// }

