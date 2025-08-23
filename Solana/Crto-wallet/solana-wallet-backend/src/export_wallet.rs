use bip39::{Mnemonic, Language};
use ed25519_dalek::{Keypair, PublicKey, SecretKey};
use bs58;

pub fn export_wallet(seed_phrase: &str) -> Result<String, String> {
    // Parse mnemonic
    let mnemonic = Mnemonic::parse_in_normalized(Language::English, seed_phrase)
        .map_err(|_| "Invalid seed phrase".to_string())?;

    // Generate keypair from mnemonic seed
    let seed = mnemonic.to_seed("");
    let secret = SecretKey::from_bytes(&seed[0..32])
        .map_err(|_| "Failed to create secret key".to_string())?;
    let public = PublicKey::from(&secret);
    let keypair = Keypair { secret, public };

    // Export keys as base58
    let public_key_base58 = bs58::encode(keypair.public.to_bytes()).into_string();

    let mut private_key_64 = [0u8; 64];
    private_key_64[..32].copy_from_slice(&keypair.secret.to_bytes());
    private_key_64[32..].copy_from_slice(&keypair.public.to_bytes());
    let private_key_base58 = bs58::encode(private_key_64).into_string();

    // Create JSON string response
    let json_response = serde_json::json!({
        "seed_phrase": mnemonic.to_string(),
        "public_key": public_key_base58,
        "private_key": private_key_base58,
    });

    Ok(json_response.to_string())
}




