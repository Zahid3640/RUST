// src/send_sol.rs
use solana_client::rpc_client::RpcClient;
use solana_sdk::{
    pubkey::Pubkey,
    signature::{Keypair, Signer},
    system_instruction,
    transaction::Transaction,
};
use std::str::FromStr;
use bs58;

/// Send SOL (blocking function). Returns tx signature string on success.
pub fn send_sol_blocking(
    rpc_url: &str,
    private_key_base58: &str, // 64-byte base58 serialized keypair
    to_pubkey_str: &str,
    amount_sol: f64,
) -> Result<String, String> {
    // Parse amount -> lamports
    if amount_sol < 0.0 {
        return Err("Amount must be non-negative".to_string());
    }
    let lamports = (amount_sol * 1_000_000_000_f64).round() as u64;

    // Build RPC client
    let client = RpcClient::new(rpc_url.to_string());

    // Decode private key base58 -> bytes
    let sk_bytes = bs58::decode(private_key_base58)
        .into_vec()
        .map_err(|e| format!("Invalid base58 private key: {}", e))?;

    if sk_bytes.len() != 64 {
        return Err(format!("Expected 64 bytes private key, found {}", sk_bytes.len()));
    }

    // Construct Keypair from bytes (solana_sdk::signature::Keypair)
    let keypair = Keypair::from_bytes(&sk_bytes)
        .map_err(|e| format!("Failed to create Keypair from bytes: {}", e))?;

    let from_pubkey = keypair.pubkey();

    // Parse recipient pubkey
    let to_pubkey = Pubkey::from_str(to_pubkey_str)
        .map_err(|e| format!("Invalid recipient pubkey: {}", e))?;

    // Build transfer instruction
    let ix = system_instruction::transfer(&from_pubkey, &to_pubkey, lamports);

    // Get a recent blockhash
    let recent_blockhash = client
        .get_latest_blockhash()
        .map_err(|e| format!("Failed to get recent blockhash: {}", e))?;

    // Build and sign transaction
    let tx = Transaction::new_signed_with_payer(
        &[ix],
        Some(&from_pubkey),
        &[&keypair],
        recent_blockhash,
    );

    // Send and confirm (blocking)
    let sig = client
        .send_and_confirm_transaction(&tx)
        .map_err(|e| format!("RPC send failed: {}", e))?;

    Ok(sig.to_string())
}
