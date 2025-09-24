use actix_web::{post, web, HttpResponse, Responder};
use bip39::{Language, Mnemonic};
use slip10_ed25519::derive_ed25519_private_key;
use ed25519_dalek::{Keypair, PublicKey, SecretKey};
use rand::rngs::OsRng;
use rand::RngCore;
use serde::{Deserialize, Serialize};
use serde_json::json;

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
    wallet: StoredWallet,   // 🔑 client sends back encrypted blob
}

#[derive(Debug, Deserialize)]
struct ExportRequest {
    password: String,
    wallet: StoredWallet,   // 🔑 client sends back encrypted blob
}

// ---------- Stored wallet structure ----------
#[derive(Debug, Serialize, Deserialize, Clone)]
struct StoredWallet {
    version: u8,
    public_key: String,
    kdf: KdfMeta,
    crypto: CryptoMeta,
    
}

#[derive(Debug, Serialize, Deserialize, Clone)]
struct KdfMeta {
    algo: String,
    salt_b64: String,
    m_cost: u32,
    t_cost: u32,
    p_cost: u32,
}

#[derive(Debug, Serialize, Deserialize, Clone)]
struct CryptoMeta {
    cipher: String,
    nonce_b64: String,
    ciphertext_b64: String,
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
        return HttpResponse::BadRequest().json(json!({
            "status":"error",
            "message":"Passwords do not match"
        }));
    }

    // generate mnemonic
    let mut entropy = [0u8; 16];
    OsRng.fill_bytes(&mut entropy);
    let mnemonic = Mnemonic::from_entropy(&entropy).unwrap();
    let seed_phrase = mnemonic.to_string();
    let seed = mnemonic.to_seed("");

    // derive keys from seed
    let (public_key_b58, private_key_b58, _sk32_b58) = derive_from_seed(&seed);

    // secret payload (what we encrypt)
    let secret_payload = json!({
        "seed_phrase": seed_phrase,
        "private_key": private_key_b58
    });

    // make KDF and encrypt
    let kdf = new_kdf_meta();
    let key = derive_key(&req.password, &kdf).expect("derive_key");
    let crypto = encrypt_payload(&key, &secret_payload).expect("encrypt");

    let stored = StoredWallet {
        version: 1,
        public_key: public_key_b58.clone(),
        kdf,
        crypto,
    };

    // Server does NOT persist anything. Return:
    // 1) the encrypted wallet blob (client stores it)
    // 2) the seed_phrase (show once to user)
    // 3) the private_key (if you want to show it — optional)
    HttpResponse::Ok().json(json!({
        "status": "success",
        "wallet": stored,
        "seed_phrase": seed_phrase,
        "private_key": private_key_b58
    }))
}

#[post("/import_wallet")]
async fn import_wallet(req: web::Json<ImportRequest>) -> impl Responder {
    let b = req.into_inner();
    if b.password != b.confirm_password {
        return HttpResponse::BadRequest().json(json!({
            "status":"error",
            "message":"Passwords do not match"
        }));
    }

    // either mnemonic OR private key path
    let (public_key_b58, private_key_b58, seed_phrase_opt) = if let Some(mn) = b.mnemonic {
        // ✅ no `?`, use match instead
        let m = match Mnemonic::parse_in_normalized(Language::English, &mn) {
            Ok(m) => m,
            Err(_) => {
                return HttpResponse::BadRequest().json(json!({
                    "status":"error",
                    "message":"Invalid mnemonic"
                }));
            }
        };

        let seed = m.to_seed("");
        let (pub_b58, prv_b58, _) = derive_from_seed(&seed);
        (pub_b58, prv_b58, Some(m.to_string()))
    } else if let Some(pk_b58_64) = b.private_key {
        let raw = match bs58::decode(&pk_b58_64).into_vec() {
            Ok(r) => r,
            Err(_) => {
                return HttpResponse::BadRequest().json(json!({
                    "status":"error",
                    "message":"Invalid private_key base58"
                }));
            }
        };

        if raw.len() < 32 {
            return HttpResponse::BadRequest().json(json!({
                "status":"error",
                "message":"private_key too short"
            }));
        }

        let secret = match ed25519_dalek::SecretKey::from_bytes(&raw[0..32]) {
            Ok(s) => s,
            Err(_) => {
                return HttpResponse::BadRequest().json(json!({
                    "status":"error",
                    "message":"Invalid private_key bytes"
                }));
            }
        };

        let public = ed25519_dalek::PublicKey::from(&secret);
        let public_key_b58 = bs58::encode(public.to_bytes()).into_string();
        (public_key_b58, pk_b58_64, None)
    } else {
        return HttpResponse::BadRequest().json(json!({
            "status":"error",
            "message":"Provide mnemonic or private_key"
        }));
    };

    // build payload to encrypt
    let payload = if let Some(seed_phrase) = &seed_phrase_opt {
        json!({
            "seed_phrase": seed_phrase,
            "private_key": private_key_b58
        })
    } else {
        json!({
            "private_key": private_key_b58
        })
    };

    // new KDF + encrypt with user-provided password (the "new" password)
    let kdf = new_kdf_meta();
    let key = derive_key(&b.password, &kdf).unwrap();   // safe unwrap because we control params
    let crypto = encrypt_payload(&key, &payload).unwrap();

    let stored = StoredWallet {
        version: 1,
        public_key: public_key_b58.clone(),
        kdf,
        crypto,
    };

    // Server returns NEW encrypted blob
    HttpResponse::Ok().json(json!({
        "status": "success",
        "wallet": stored,
        "seed_phrase": seed_phrase_opt,   // only if imported via mnemonic
        "private_key": private_key_b58
    }))
}

// ---------- UNLOCK ----------
#[post("/export_wallet")]
async fn export_wallet(req: web::Json<ExportRequest>) -> impl Responder {
    let b = req.into_inner();
    let key = match derive_key(&b.password, &b.wallet.kdf) {
        Ok(k) => k,
        Err(e) => return HttpResponse::InternalServerError().json(json!({"status":"error","message": e})),
    };
    let cipher = Aes256Gcm::new_from_slice(&key).unwrap();
    let nonce_bytes = base64::decode(&b.wallet.crypto.nonce_b64).unwrap();
    let ct = base64::decode(&b.wallet.crypto.ciphertext_b64).unwrap();
    let nonce = Nonce::from_slice(&nonce_bytes);

    let pt = match cipher.decrypt(nonce, ct.as_ref()) {
        Ok(v) => v,
        Err(_) => return HttpResponse::Unauthorized().json(json!({"status":"error","message":"Invalid password"})),
    };

    let secret_payload: serde_json::Value = serde_json::from_slice(&pt).unwrap();

    HttpResponse::Ok().json(json!({
        "status": "success",
        "payload": secret_payload
    }))
}
#[post("/unlock_wallet")]
async fn unlock_wallet(req: web::Json<UnlockRequest>) -> impl Responder {
    let b = req.into_inner();

    // derive encryption key
    let key = match derive_key(&b.password, &b.wallet.kdf) {
        Ok(k) => k,
        Err(e) => {
            return HttpResponse::InternalServerError().json(json!({
                "status":"error",
                "message": e
            }))
        }
    };

    let cipher = Aes256Gcm::new_from_slice(&key).unwrap();
    let nonce_bytes = base64::decode(&b.wallet.crypto.nonce_b64).unwrap();
    let ct = base64::decode(&b.wallet.crypto.ciphertext_b64).unwrap();
    let nonce = Nonce::from_slice(&nonce_bytes);

    // decrypt secret payload
    let pt = match cipher.decrypt(nonce, ct.as_ref()) {
        Ok(v) => v,
        Err(_) => {
            return HttpResponse::Unauthorized().json(json!({
                "status":"error",
                "message":"Invalid password"
            }))
        }
    };

    let secret_payload: serde_json::Value = serde_json::from_slice(&pt).unwrap();

    // ✅ merge stored wallet + decrypted secrets
    HttpResponse::Ok().json(json!({
        "status": "success",
        "wallet": {
            "version": b.wallet.version,
            "public_key": b.wallet.public_key,
            "kdf": b.wallet.kdf,
            "crypto": b.wallet.crypto,
            "secrets": secret_payload   // <- decrypted seed phrase + private key
        }
    }))
}


// use actix_web::{post, web, HttpResponse, Responder};
// use bip39::{Language, Mnemonic};
// use slip10_ed25519::derive_ed25519_private_key;
// use ed25519_dalek::{Keypair, PublicKey, SecretKey};
// use rand::rngs::OsRng;
// use rand::RngCore;
// use serde::{Deserialize, Serialize};
// use serde_json::json;

// use argon2::{Argon2, Params, Algorithm, Version, password_hash::PasswordHasher};
// use aes_gcm::{Aes256Gcm, aead::{Aead, KeyInit, OsRng as AeadOsRng}, Nonce};
// use base64::{engine::general_purpose, Engine as _};

// // ---------- Request/Response structs ----------
// #[derive(Debug, Deserialize)]
// struct CreateRequest {
//     password: String,
//     confirm_password: String,
// }

// #[derive(Debug, Deserialize)]
// struct ImportRequest {
//     mnemonic: Option<String>,
//     private_key: Option<String>,
//     password: String,
//     confirm_password: String,
// }

// #[derive(Debug, Deserialize)]
// struct UnlockRequest {
//     password: String,
//     wallet: StoredWallet,   // 🔑 client sends back encrypted blob
// }

// #[derive(Debug, Deserialize)]
// struct ExportRequest {
//     password: String,
//     wallet: StoredWallet,   // 🔑 client sends back encrypted blob
// }

// // ---------- Stored wallet structure ----------
// #[derive(Debug, Serialize, Deserialize, Clone)]
// struct StoredWallet {
//     version: u8,
//     public_key: String,
//     kdf: KdfMeta,
//     crypto: CryptoMeta,
// }

// #[derive(Debug, Serialize, Deserialize, Clone)]
// struct KdfMeta {
//     algo: String,
//     salt_b64: String,
//     m_cost: u32,
//     t_cost: u32,
//     p_cost: u32,
// }

// #[derive(Debug, Serialize, Deserialize, Clone)]
// struct CryptoMeta {
//     cipher: String,
//     nonce_b64: String,
//     ciphertext_b64: String,
// }

// // ---------- KDF + Encryption helpers ----------
// fn derive_key(password: &str, kdf: &KdfMeta) -> Result<[u8; 32], String> {
//     let salt_bytes = general_purpose::STANDARD.decode(&kdf.salt_b64).map_err(|e| e.to_string())?;
//     let params = Params::new(kdf.m_cost, kdf.t_cost, kdf.p_cost, Some(32)).map_err(|e| e.to_string())?;
//     let argon = Argon2::new(Algorithm::Argon2id, Version::V0x13, params);

//     let mut key = [0u8; 32];
//     argon.hash_password_into(password.as_bytes(), &salt_bytes, &mut key).map_err(|e| e.to_string())?;
//     Ok(key)
// }

// fn encrypt_payload(key: &[u8; 32], plaintext_json: &serde_json::Value) -> Result<CryptoMeta, String> {
//     let cipher = Aes256Gcm::new_from_slice(key).map_err(|e| e.to_string())?;
//     let mut nonce_bytes = [0u8; 12];
//     AeadOsRng.fill_bytes(&mut nonce_bytes);
//     let nonce = Nonce::from_slice(&nonce_bytes);

//     let pt = serde_json::to_vec(plaintext_json).map_err(|e| e.to_string())?;
//     let ct = cipher.encrypt(nonce, pt.as_ref()).map_err(|e| e.to_string())?;

//     Ok(CryptoMeta {
//         cipher: "aes-256-gcm".to_string(),
//         nonce_b64: general_purpose::STANDARD.encode(nonce_bytes),
//         ciphertext_b64: general_purpose::STANDARD.encode(ct),
//     })
// }

// fn new_kdf_meta() -> KdfMeta {
//     let mut salt = [0u8; 16];
//     OsRng.fill_bytes(&mut salt);
//     KdfMeta {
//         algo: "argon2id".to_string(),
//         salt_b64: general_purpose::STANDARD.encode(salt),
//         m_cost: 19456,
//         t_cost: 2,
//         p_cost: 1,
//     }
// }

// // ---------- Derive Ed25519 ----------
// fn derive_from_seed(seed: &[u8]) -> (String, String, String) {
//     let path: [u32; 4] = [
//         44 | 0x8000_0000,
//         501 | 0x8000_0000,
//         0 | 0x8000_0000,
//         0 | 0x8000_0000,
//     ];
//     let sk32 = derive_ed25519_private_key(seed, &path);
//     let secret = SecretKey::from_bytes(&sk32).unwrap();
//     let public = PublicKey::from(&secret);
//     let keypair = Keypair { secret, public };

//     let public_key_b58 = bs58::encode(keypair.public.to_bytes()).into_string();
//     let mut pk64 = [0u8; 64];
//     pk64[..32].copy_from_slice(&keypair.secret.to_bytes());
//     pk64[32..].copy_from_slice(&keypair.public.to_bytes());
//     let private_key_b58 = bs58::encode(pk64).into_string();
//     (public_key_b58, private_key_b58, bs58::encode(sk32).into_string())
// }

// // ---------- CREATE ----------
// #[post("/create_wallet")]
// async fn create_wallet(req: web::Json<CreateRequest>) -> impl Responder {
//     if req.password != req.confirm_password {
//         return HttpResponse::BadRequest().json(json!({
//             "status":"error",
//             "message":"Passwords do not match"
//         }));
//     }

//     // generate mnemonic
//     let mut entropy = [0u8; 16];
//     OsRng.fill_bytes(&mut entropy);
//     let mnemonic = Mnemonic::from_entropy(&entropy).unwrap();
//     let seed_phrase = mnemonic.to_string();
//     let seed = mnemonic.to_seed("");

//     // derive keys
//     let (public_key_b58, private_key_b58, _) = derive_from_seed(&seed);

//     // encrypt secrets
//     let secret_payload = json!({
//         "seed_phrase": seed_phrase,
//         "private_key": private_key_b58
//     });

//     let kdf = new_kdf_meta();
//     let key = derive_key(&req.password, &kdf).unwrap();
//     let crypto = encrypt_payload(&key, &secret_payload).unwrap();

//     let stored = StoredWallet {
//         version: 1,
//         public_key: public_key_b58.clone(),
//         kdf,
//         crypto,
//     };

//     // ✅ return both the encrypted wallet + raw seed phrase once
//     HttpResponse::Ok().json(json!({
//         "status": "success",
//         "wallet": stored,
//         "seed_phrase": seed_phrase,
//         "private_key": private_key_b58
//     }))
// }


// // ---------- IMPORT ----------
// #[post("/import_wallet")]
// async fn import_wallet(req: web::Json<ImportRequest>) -> impl Responder {
//     let b = req.into_inner();
//     if b.password != b.confirm_password {
//         return HttpResponse::BadRequest().json(json!({"status":"error","message":"Passwords do not match"}));
//     }

//     let (public_key_b58, private_key_b58, seed_phrase_opt) = if let Some(mn) = b.mnemonic {
//         let m = Mnemonic::parse_in_normalized(Language::English, &mn).unwrap();
//         let seed = m.to_seed("");
//         let (pub_b58, prv_b58, _) = derive_from_seed(&seed);
//         (pub_b58, prv_b58, Some(m.to_string()))
//     } else if let Some(pk_b58_64) = b.private_key {
//         let raw = bs58::decode(&pk_b58_64).into_vec().unwrap();
//         let secret = SecretKey::from_bytes(&raw[0..32]).unwrap();
//         let public = PublicKey::from(&secret);
//         let keypair = Keypair { secret, public };
//         let public_key_b58 = bs58::encode(keypair.public.to_bytes()).into_string();
//         (public_key_b58, pk_b58_64, None)
//     } else {
//         return HttpResponse::BadRequest().json(json!({"status":"error","message":"Provide mnemonic or private_key"}));
//     };

//     let payload = if let Some(seed_phrase) = &seed_phrase_opt {
//         json!({ "seed_phrase": seed_phrase, "private_key": private_key_b58 })
//     } else {
//         json!({ "private_key": private_key_b58 })
//     };

//     let kdf = new_kdf_meta();
//     let key = derive_key(&b.password, &kdf).unwrap();
//     let crypto = encrypt_payload(&key, &payload).unwrap();

//     let stored = StoredWallet { version: 1, public_key: public_key_b58.clone(), kdf, crypto };

//     HttpResponse::Ok().json(json!({
//         "status": "success",
//         "wallet": stored
//     }))
// }

// // ---------- UNLOCK ----------
// #[post("/export_wallet")]
// async fn export_wallet(req: web::Json<ExportRequest>) -> impl Responder {
//     let b = req.into_inner();
//     let key = match derive_key(&b.password, &b.wallet.kdf) {
//         Ok(k) => k,
//         Err(e) => return HttpResponse::InternalServerError().json(json!({"status":"error","message": e})),
//     };
//     let cipher = Aes256Gcm::new_from_slice(&key).unwrap();
//     let nonce_bytes = base64::decode(&b.wallet.crypto.nonce_b64).unwrap();
//     let ct = base64::decode(&b.wallet.crypto.ciphertext_b64).unwrap();
//     let nonce = Nonce::from_slice(&nonce_bytes);

//     let pt = match cipher.decrypt(nonce, ct.as_ref()) {
//         Ok(v) => v,
//         Err(_) => return HttpResponse::Unauthorized().json(json!({"status":"error","message":"Invalid password"})),
//     };

//     let secret_payload: serde_json::Value = serde_json::from_slice(&pt).unwrap();

//     HttpResponse::Ok().json(json!({
//         "status": "success",
//         "payload": secret_payload
//     }))
// }
// #[post("/unlock_wallet")]
// async fn unlock_wallet(req: web::Json<UnlockRequest>) -> impl Responder {
//     let b = req.into_inner();

//     // derive encryption key
//     let key = match derive_key(&b.password, &b.wallet.kdf) {
//         Ok(k) => k,
//         Err(e) => {
//             return HttpResponse::InternalServerError().json(json!({
//                 "status":"error",
//                 "message": e
//             }))
//         }
//     };

//     let cipher = Aes256Gcm::new_from_slice(&key).unwrap();
//     let nonce_bytes = base64::decode(&b.wallet.crypto.nonce_b64).unwrap();
//     let ct = base64::decode(&b.wallet.crypto.ciphertext_b64).unwrap();
//     let nonce = Nonce::from_slice(&nonce_bytes);

//     // decrypt secret payload
//     let pt = match cipher.decrypt(nonce, ct.as_ref()) {
//         Ok(v) => v,
//         Err(_) => {
//             return HttpResponse::Unauthorized().json(json!({
//                 "status":"error",
//                 "message":"Invalid password"
//             }))
//         }
//     };

//     let secret_payload: serde_json::Value = serde_json::from_slice(&pt).unwrap();

//     // ✅ merge stored wallet + decrypted secrets
//     HttpResponse::Ok().json(json!({
//         "status": "success",
//         "wallet": {
//             "version": b.wallet.version,
//             "public_key": b.wallet.public_key,
//             "kdf": b.wallet.kdf,
//             "crypto": b.wallet.crypto,
//             "secrets": secret_payload   // <- decrypted seed phrase + private key
//         }
//     }))
// }
 