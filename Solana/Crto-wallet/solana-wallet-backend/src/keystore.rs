// src/keystore.rs
use aes::Aes128;
use ctr::Ctr128BE;
use cipher::{NewCipher, StreamCipher};
use hmac::{Hmac, Mac};
use rand::RngCore;
use scrypt::{scrypt, Params as ScryptParams};
use serde::{Deserialize, Serialize};
use sha2::Sha256;
use uuid::Uuid;
use hex;

type HmacSha256 = Hmac<Sha256>;

#[derive(Serialize, Deserialize, Debug)]
pub struct KdfParams {
    pub dklen: u32,
    pub n: u32,
    pub r: u32,
    pub p: u32,
    pub salt: String, // hex
}

#[derive(Serialize, Deserialize, Debug)]
pub struct CipherParams {
    pub iv: String, // hex
}

#[derive(Serialize, Deserialize, Debug)]
pub struct Crypto {
    pub cipher: String,
    pub ciphertext: String, // hex
    pub cipherparams: CipherParams,
    pub kdf: String,
    pub kdfparams: KdfParams,
    pub mac: String, // hex
}

#[derive(Serialize, Deserialize, Debug)]
pub struct Keystore {
    pub crypto: Crypto,
    pub id: String,
    pub version: u8,
    pub address: Option<String>, // optional (not used for Solana)
}

/// Encrypt a 64-byte private key (private + pub) with password and return Keystore struct.
/// private_key_bytes should be the raw 64 bytes of private key (first 32 secret, next 32 public) or similar.
pub fn encrypt_private_key(private_key_bytes: &[u8], password: &str) -> Keystore {
    assert!(private_key_bytes.len() > 0, "private_key required");

    // --- KDF params (scrypt) ---
    let dklen = 32u32;
    // Recommended scrypt params for production; you can tune down for dev/testing.
    // N=262144, r=8, p=1 is strong but CPU expensive.
    let n = 262144u32;
    let r = 8u32;
    let p = 1u32;

    // generate salt
    let mut salt = [0u8; 16];
    rand::thread_rng().fill_bytes(&mut salt);

    // run scrypt
    let params = ScryptParams::new(log2(n).expect("n must be power of two") as u8, r, p)
        .expect("invalid scrypt params");
    let mut derived = vec![0u8; dklen as usize];
    scrypt(password.as_bytes(), &salt, &params, &mut derived).expect("scrypt failed");

    // --- AES-128-CTR encrypt using first 16 bytes of derived key ---
    let key = &derived[0..16]; // AES-128 key
    // generate random IV (16 bytes)
    let mut iv = [0u8; 16];
    rand::thread_rng().fill_bytes(&mut iv);

    // create cipher and encrypt
    let mut cipher = Ctr128BE::<Aes128>::new_from_slices(key, &iv).expect("cipher init");
    let mut ciphertext = private_key_bytes.to_vec();
    cipher.apply_keystream(&mut ciphertext);

    // --- MAC using HMAC-SHA256 over (derived[16..32] || ciphertext) ---
    let mut mac_key = derived[16..32].to_vec(); // second half
    let mut mac = HmacSha256::new_from_slice(&mac_key).expect("HMAC can take key of any size");
    mac.update(&ciphertext);
    let mac_bytes = mac.finalize().into_bytes();

    // build keystore
    let ks = Keystore {
        crypto: Crypto {
            cipher: "aes-128-ctr".to_string(),
            ciphertext: hex::encode(&ciphertext),
            cipherparams: CipherParams {
                iv: hex::encode(&iv),
            },
            kdf: "scrypt".to_string(),
            kdfparams: KdfParams {
                dklen,
                n,
                r,
                p,
                salt: hex::encode(&salt),
            },
            mac: hex::encode(mac_bytes),
        },
        id: Uuid::new_v4().to_string(),
        version: 3,
        address: None,
    };

    ks
}

/// Decrypt keystore (JSON string or Keystore struct) with password, returning plaintext private key bytes.
pub fn decrypt_keystore(ks: &Keystore, password: &str) -> Result<Vec<u8>, String> {
    // parse kdf params
    let salt = hex::decode(&ks.crypto.kdfparams.salt)
        .map_err(|e| format!("invalid salt hex: {}", e))?;
    let dklen = ks.crypto.kdfparams.dklen as usize;
    let n = ks.crypto.kdfparams.n;
    let r = ks.crypto.kdfparams.r;
    let p = ks.crypto.kdfparams.p;

    // rebuild scrypt params
    let params = ScryptParams::new(log2(n).ok_or("n must be power of two")? as u8, r, p)
        .map_err(|e| format!("bad scrypt params: {}", e))?;
    let mut derived = vec![0u8; dklen];
    scrypt(password.as_bytes(), &salt, &params, &mut derived)
        .map_err(|e| format!("scrypt failed: {}", e))?;

    // decode ciphertext and iv
    let ciphertext = hex::decode(&ks.crypto.ciphertext)
        .map_err(|e| format!("invalid ciphertext hex: {}", e))?;
    let iv = hex::decode(&ks.crypto.cipherparams.iv)
        .map_err(|e| format!("invalid iv hex: {}", e))?;

    // verify MAC
    let mut mac = HmacSha256::new_from_slice(&derived[16..32]).map_err(|e| format!("{:?}", e))?;
    mac.update(&ciphertext);
    mac.verify_slice(&hex::decode(&ks.crypto.mac).map_err(|e| format!("bad mac hex: {}", e))?)
        .map_err(|_| "MAC mismatch - wrong password or corrupted file".to_string())?;

    // decrypt
    let key = &derived[0..16];
    let mut cipher = Ctr128BE::<Aes128>::new_from_slices(key, &iv).map_err(|e| format!("{:?}", e))?;
    let mut plaintext = ciphertext.clone();
    cipher.apply_keystream(&mut plaintext);

    Ok(plaintext)
}

// helper: compute log2 for scrypt param check
fn log2(x: u32) -> Option<u32> {
    if x == 0 { return None; }
    let lg = 31 - x.leading_zeros();
    if 1u32 << lg == x { Some(lg) } else { None }
}
