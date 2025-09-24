use actix_web::{post, web, HttpResponse, Responder};
use bip39::{Language, Mnemonic};
use slip10_ed25519::derive_ed25519_private_key;
use ed25519_dalek::{Keypair, PublicKey as DalekPublicKey, SecretKey};
use rand::rngs::OsRng;
use rand::RngCore;
use serde::{Deserialize, Serialize};
use serde_json::json;
use std::fs;

use argon2::{Argon2, Params, Algorithm, Version, password_hash::PasswordHasher};
use aes_gcm::{Aes256Gcm, aead::{Aead, KeyInit, OsRng as AeadOsRng}, Nonce};
use base64::{engine::general_purpose, Engine as _};

// Ethereum
use k256::ecdsa::SigningKey;
use k256::elliptic_curve::sec1::ToEncodedPoint;
use tiny_hderive::bip32::ExtendedPrivKey;
use sha3::{Digest, Keccak256};
use hex;

use bitcoin::{bip32, Address, Network};
use bitcoin::secp256k1::{Secp256k1, PublicKey as SecpPublicKey};
use bitcoin::key::{CompressedPublicKey, PrivateKey as BtcPrivateKey};
use std::str::FromStr;

// ---------- Request/Response ----------
#[derive(Debug, Deserialize)]
struct CreateRequest {
    password: String,
    confirm_password: String,
}

#[derive(Debug, Deserialize)]
struct UnlockRequest {
    password: String,
}

// ---------- Chain Accounts ----------
#[derive(Debug, Serialize, Deserialize, Clone)]
enum Chain {
    Solana,
    Ethereum,
    Bitcoin,
    Ton,
}

#[derive(Debug, Serialize, Deserialize, Clone)]
struct WalletAccount {
    chain: Chain,
    public_key: String,
    address: String,
    private_key: String,
}

// ---------- Stored Wallet ----------
#[derive(Debug, Serialize, Deserialize)]
struct StoredWallet {
    version: u8,
    accounts: Vec<WalletAccount>,
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

// ---------- KDF + Encryption ----------
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

// ---------- Derivation Helpers ----------

// Solana (Ed25519)
fn derive_solana(seed: &[u8]) -> WalletAccount {
    let path: [u32; 4] = [
        44 | 0x8000_0000,
        501 | 0x8000_0000,
        0 | 0x8000_0000,
        0 | 0x8000_0000,
    ];
    let sk32 = derive_ed25519_private_key(seed, &path);
    let secret = SecretKey::from_bytes(&sk32).unwrap();
    let public = DalekPublicKey::from(&secret);
    let keypair = Keypair { secret, public };

    let pub_b58 = bs58::encode(keypair.public.to_bytes()).into_string();
    let mut pk64 = [0u8; 64];
    pk64[..32].copy_from_slice(&keypair.secret.to_bytes());
    pk64[32..].copy_from_slice(&keypair.public.to_bytes());
    let priv_b58 = bs58::encode(pk64).into_string();

    WalletAccount {
        chain: Chain::Solana,
        public_key: pub_b58.clone(),
        address: pub_b58.clone(),
        private_key: priv_b58,
    }
}

// Ethereum (secp256k1)
fn derive_ethereum(seed: &[u8]) -> WalletAccount {
    let xprv = ExtendedPrivKey::derive(seed, "m/44'/60'/0'/0/0").unwrap();
    let sk = SigningKey::from_bytes(&xprv.secret()).unwrap();
    let vk = sk.verifying_key();

    // Ethereum address = keccak256(pubkey)[12..]
    let pub_bytes = vk.to_encoded_point(false).as_bytes()[1..].to_vec();
    let mut hasher = Keccak256::default();
    hasher.update(pub_bytes);
    let addr_bytes = hasher.finalize();
    let address = format!("0x{}", hex::encode(&addr_bytes[12..]));

    WalletAccount {
        chain: Chain::Ethereum,
        public_key: hex::encode(vk.to_bytes()),
        address,
        private_key: hex::encode(xprv.secret()),
    }
}

// Bitcoin (secp256k1)
fn derive_bitcoin(seed: &[u8]) -> WalletAccount {
    let secp = Secp256k1::new();

    // master private key
    let xprv = bip32::ExtendedPrivKey::new_master(Network::Bitcoin, seed).unwrap();

    // derivation path m/44'/0'/0'/0/0
    let path = bip32::DerivationPath::from_str("m/44'/0'/0'/0/0").unwrap();
    let child_xprv = xprv.derive_priv(&secp, &path).unwrap();

    // private key (raw secp256k1)
    let pk = child_xprv.private_key;

    // derive compressed pubkey
    let secp_pubkey: SecpPublicKey = pk.public_key(&secp);
    let compressed = CompressedPublicKey::from(bitcoin::CompressedPublicKey(secp_pubkey));

    // generate P2WPKH (bech32) address
    let addr = Address::p2wpkh(&compressed, Network::Bitcoin);

    // private key → WIF
    let wif = BtcPrivateKey::new(pk, Network::Bitcoin).to_wif();

    WalletAccount {
        chain: Chain::Bitcoin,
        public_key: compressed.to_string(), // base58-like compressed pubkey
        address: addr.to_string(),          // bech32 address
        private_key: wif,                   // WIF format
    }
}


// TON (Ed25519)
fn derive_ton(seed: &[u8]) -> WalletAccount {
    let path = [44 | 0x8000_0000, 607 | 0x8000_0000, 0 | 0x8000_0000, 0 | 0x8000_0000];
    let sk32 = derive_ed25519_private_key(seed, &path);
    let secret = SecretKey::from_bytes(&sk32).unwrap();
    let public = DalekPublicKey::from(&secret);
    let keypair = Keypair { secret, public };

    let pub_b58 = bs58::encode(keypair.public.to_bytes()).into_string();
    let priv_b58 = bs58::encode(sk32).into_string();

    WalletAccount {
        chain: Chain::Ton,
        public_key: pub_b58.clone(),
        address: pub_b58.clone(), // TODO: replace with TON bounceable format
        private_key: priv_b58,
    }
}

// ---------- CREATE MULTICHAIN ----------
#[post("/create_wallet_multichain")]
async fn create_wallet_multichain(req: web::Json<CreateRequest>) -> impl Responder {
    if req.password != req.confirm_password {
        return HttpResponse::BadRequest()
            .json(json!({"status":"error","message":"Passwords do not match"}));
    }

    let mut entropy = [0u8; 16];
    OsRng.fill_bytes(&mut entropy);
    let mnemonic = Mnemonic::from_entropy(&entropy).unwrap();
    let seed_phrase = mnemonic.to_string();
    let seed = mnemonic.to_seed("");

    let accounts = vec![
        derive_solana(&seed),
        derive_ethereum(&seed),
        derive_bitcoin(&seed),
        derive_ton(&seed),
    ];

    let secret_payload = json!({
        "seed_phrase": seed_phrase,
        "accounts": accounts,
    });

    let kdf = new_kdf_meta();
    let key = derive_key(&req.password, &kdf).unwrap();
    let crypto = encrypt_payload(&key, &secret_payload).unwrap();

    let stored = StoredWallet { version: 1, accounts: accounts.clone(), kdf, crypto };
    save_wallet(&stored).unwrap();

    HttpResponse::Ok().json(json!({
        "status":"success",
        "seed_phrase": seed_phrase,
        "accounts": accounts
    }))
}

// ---------- UNLOCK ----------
#[post("/unlock_wallet")]
async fn unlock_wallet(req: web::Json<UnlockRequest>) -> impl Responder {
    let stored = match load_wallet() {
        Ok(w) => w,
        Err(e) => return HttpResponse::InternalServerError().json(json!({"status":"error","message": e})),
    };

    let key = match derive_key(&req.password, &stored.kdf) {
        Ok(k) => k,
        Err(e) => return HttpResponse::InternalServerError().json(json!({"status":"error","message": e})),
    };

    let cipher = Aes256Gcm::new_from_slice(&key).unwrap();
    let nonce_bytes = base64::decode(&stored.crypto.nonce_b64).unwrap();
    let ct = base64::decode(&stored.crypto.ciphertext_b64).unwrap();
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
