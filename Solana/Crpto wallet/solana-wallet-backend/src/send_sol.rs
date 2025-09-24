// // src/send_sol.rs
// use solana_client::rpc_client::RpcClient;
// use solana_sdk::{
//     pubkey::Pubkey,
//     signature::{Keypair, Signer},
//     system_instruction,
//     transaction::Transaction,
// };
// use std::str::FromStr;
// use bs58;

// /// Send SOL (blocking function). Returns tx signature string on success.
// pub fn send_sol_blocking(
//     rpc_url: &str,
//     private_key_base58: &str, // 64-byte base58 serialized keypair
//     to_pubkey_str: &str,
//     amount_sol: f64,
// ) -> Result<String, String> {
//     // Parse amount -> lamports
//     if amount_sol < 0.0 {
//         return Err("Amount must be non-negative".to_string());
//     }
//     let lamports = (amount_sol * 1_000_000_000_f64).round() as u64;

//     // Build RPC client
//     let client = RpcClient::new(rpc_url.to_string());

//     // Decode private key base58 -> bytes
//     let sk_bytes = bs58::decode(private_key_base58)
//         .into_vec()
//         .map_err(|e| format!("Invalid base58 private key: {}", e))?;

//     if sk_bytes.len() != 64 {
//         return Err(format!("Expected 64 bytes private key, found {}", sk_bytes.len()));
//     }

//     // Construct Keypair from bytes (solana_sdk::signature::Keypair)
//     let keypair = Keypair::from_bytes(&sk_bytes)
//         .map_err(|e| format!("Failed to create Keypair from bytes: {}", e))?;

//     let from_pubkey = keypair.pubkey();

//     // Parse recipient pubkey
//     let to_pubkey = Pubkey::from_str(to_pubkey_str)
//         .map_err(|e| format!("Invalid recipient pubkey: {}", e))?;

//     // Build transfer instruction
//     let ix = system_instruction::transfer(&from_pubkey, &to_pubkey, lamports);

//     // Get a recent blockhash
//     let recent_blockhash = client
//         .get_latest_blockhash()
//         .map_err(|e| format!("Failed to get recent blockhash: {}", e))?;

//     // Build and sign transaction
//     let tx = Transaction::new_signed_with_payer(
//         &[ix],
//         Some(&from_pubkey),
//         &[&keypair],
//         recent_blockhash,
//     );

//     // Send and confirm (blocking)
//     let sig = client
//         .send_and_confirm_transaction(&tx)
//         .map_err(|e| format!("RPC send failed: {}", e))?;

//     Ok(sig.to_string())
// }
// src/send_sol.rs
// use actix_web::{post, web, HttpResponse, Responder};
// use serde::Deserialize;
// use solana_client::rpc_client::RpcClient;
// use solana_sdk::{
//     pubkey::Pubkey,
//     signature::{Keypair, Signer},
//     system_instruction,
//     transaction::Transaction,
// };
// use std::str::FromStr;
// use bs58;

// #[derive(Deserialize)]
// pub struct SendSolRequest {
//     pub private_key: String,   // 🗝️ sender ki private key (64-byte base58)
//     pub to_address: String,    // 🎯 receiver ka address
//     pub amount: f64,           // 💰 SOL amount
// }

// #[post("/sol_send")]
// pub async fn sol_send(req: web::Json<SendSolRequest>) -> impl Responder {
//     let rpc_url = "https://api.devnet.solana.com"; // 🌐 FIXED devnet

//     // blocking ko async compatible banane ke liye tokio::task::spawn_blocking
//     let private_key = req.private_key.clone();
//     let to_address = req.to_address.clone();
//     let amount = req.amount;

//     let result = tokio::task::spawn_blocking(move || {
//         send_sol_blocking(rpc_url, &private_key, &to_address, amount)
//     })
//     .await;

//     match result {
//         Ok(Ok(sig)) => HttpResponse::Ok().body(format!("✅ Tx Success: {}", sig)),
//         Ok(Err(e)) => HttpResponse::InternalServerError().body(format!("❌ Error: {}", e)),
//         Err(e) => HttpResponse::InternalServerError().body(format!("❌ Spawn error: {}", e)),
//     }
// }

// /// Send SOL (blocking). Returns tx signature string on success.
// fn send_sol_blocking(
//     rpc_url: &str,
//     private_key_base58: &str,
//     to_pubkey_str: &str,
//     amount_sol: f64,
// ) -> Result<String, String> {
//     if amount_sol <= 0.0 {
//         return Err("Amount must be positive".to_string());
//     }
//     let lamports = (amount_sol * 1_000_000_000_f64).round() as u64;

//     let client = RpcClient::new(rpc_url.to_string());

//     // 🔑 Decode private key
//     let sk_bytes = bs58::decode(private_key_base58)
//         .into_vec()
//         .map_err(|e| format!("Invalid base58 private key: {}", e))?;

//     if sk_bytes.len() != 64 {
//         return Err(format!("Expected 64 bytes private key, found {}", sk_bytes.len()));
//     }

//     let keypair = Keypair::from_bytes(&sk_bytes)
//         .map_err(|e| format!("Failed to create Keypair: {}", e))?;
//     let from_pubkey = keypair.pubkey();

//     // 🎯 Parse recipient
//     let to_pubkey = Pubkey::from_str(to_pubkey_str)
//         .map_err(|e| format!("Invalid recipient pubkey: {}", e))?;

//     // 📝 Transfer instruction
//     let ix = system_instruction::transfer(&from_pubkey, &to_pubkey, lamports);

//     // ⛓️ Blockhash
//     let recent_blockhash = client
//         .get_latest_blockhash()
//         .map_err(|e| format!("Failed to get blockhash: {}", e))?;

//     // ✍️ Transaction build + sign
//     let tx = Transaction::new_signed_with_payer(
//         &[ix],
//         Some(&from_pubkey),
//         &[&keypair],
//         recent_blockhash,
//     );

//     // 🚀 Send + confirm
//     let sig = client
//         .send_and_confirm_transaction(&tx)
//         .map_err(|e| format!("RPC send failed: {}", e))?;

//     Ok(sig.to_string())
// }
use actix_web::{post, web, HttpResponse, Responder};
use serde::{Deserialize, Serialize};
use solana_client::rpc_client::RpcClient; // sync client (inside spawn_blocking)
use solana_sdk::{
    pubkey::Pubkey,
    signature::{Keypair, Signer},
    system_instruction,
    transaction::Transaction,
};
use std::str::FromStr;
use bs58;
use anyhow::Context;
use serde_json::json;
use tokio::time::{sleep, Duration};

#[derive(Deserialize)]
pub struct SendSolRequest {
    pub private_key: String,   // base58 64-byte keypair
    pub to_address: String,    // receiver pubkey
    pub amount: f64,           // SOL amount
}

#[derive(Serialize)]
pub struct SendSolResponse {
    pub signature: String,
    pub fee_lamports: u64,
    pub fee_sol: f64,
    pub network: String,
    pub message: String,
}

#[post("/sol_send")]
pub async fn sol_send(req: web::Json<SendSolRequest>) -> impl Responder {
    // --- config ---
    let rpc_url = std::env::var("SOLANA_RPC")
        .unwrap_or_else(|_| "https://api.devnet.solana.com".to_string());
    let network = if rpc_url.contains("devnet") {
        "Solana Devnet"
    } else if rpc_url.contains("testnet") {
        "Solana Testnet"
    } else {
        "Solana Mainnet"
    }.to_string();

    // copy args for blocking section
    let private_key = req.private_key.clone();
    let to_address = req.to_address.clone();
    let amount = req.amount;

    // 1) send the SOL tx on a blocking thread (sync RpcClient)
    let rpc_url_clone = rpc_url.clone();
    let send_result = tokio::task::spawn_blocking(move || {
        send_sol_blocking(&rpc_url_clone, &private_key, &to_address, amount)
    }).await;

    let sig = match send_result {
        Ok(Ok(sig)) => sig,
        Ok(Err(e)) => return HttpResponse::InternalServerError().json(json!({"error": e})),
        Err(e) => return HttpResponse::InternalServerError().json(json!({"error": e.to_string()})),
    };

    // 2) fetch the ACTUAL fee from confirmed tx meta (matches Explorer), with retries
    let fee_lamports = match fetch_fee_with_retries(&rpc_url, &sig, 10, Duration::from_millis(300)).await {
        Ok(f) => f,
        Err(e) => {
            eprintln!("fee fetch failed after retries: {e:#}");
            0
        }
    };
    let fee_sol = fee_lamports as f64 / 1_000_000_000.0;

    // 3) respond JSON
    let resp = SendSolResponse {
        signature: sig,
        fee_lamports,
        fee_sol,
        network,
        message: "SOL sent successfully.".to_string(),
    };
    HttpResponse::Ok().json(resp)
}

/// Blocking send using the sync RpcClient. Returns signature on success.
fn send_sol_blocking(
    rpc_url: &str,
    private_key_base58: &str,
    to_pubkey_str: &str,
    amount_sol: f64,
) -> Result<String, String> {
    if amount_sol <= 0.0 {
        return Err("Amount must be positive".to_string());
    }
    let lamports = (amount_sol * 1_000_000_000_f64).round() as u64;

    let client = RpcClient::new(rpc_url.to_string());

    // decode keypair
    let sk_bytes = bs58::decode(private_key_base58)
        .into_vec()
        .map_err(|e| format!("Invalid base58 private key: {}", e))?;
    if sk_bytes.len() != 64 {
        return Err(format!("Expected 64 bytes private key, found {}", sk_bytes.len()));
    }
    let keypair = Keypair::from_bytes(&sk_bytes)
        .map_err(|e| format!("Failed to create Keypair: {}", e))?;
    let from_pubkey = keypair.pubkey();

    // parse receiver
    let to_pubkey = Pubkey::from_str(to_pubkey_str)
        .map_err(|e| format!("Invalid recipient pubkey: {}", e))?;

    // build transfer ix
    let ix = system_instruction::transfer(&from_pubkey, &to_pubkey, lamports);

    // blockhash
    let recent_blockhash = client
        .get_latest_blockhash()
        .map_err(|e| format!("Failed to get blockhash: {}", e))?;

    // sign tx
    let tx = Transaction::new_signed_with_payer(
        &[ix],
        Some(&from_pubkey),
        &[&keypair],
        recent_blockhash,
    );

    // send + confirm
    let sig = client
        .send_and_confirm_transaction(&tx)
        .map_err(|e| format!("RPC send failed: {}", e))?;

    Ok(sig.to_string())
}

/// Poll JSON-RPC getTransaction until meta.fee is available.
async fn fetch_fee_with_retries(
    rpc_url: &str,
    signature: &str,
    tries: usize,
    delay: Duration,
) -> anyhow::Result<u64> {
    let http = reqwest::Client::new();

    for attempt in 1..=tries {
        let body = json!({
            "jsonrpc": "2.0",
            "id": 1,
            "method": "getTransaction",
            "params": [
                signature,
                { "encoding": "json", "commitment": "confirmed", "maxSupportedTransactionVersion": 0 }
            ]
        });

        let resp = http
            .post(rpc_url)
            .json(&body)
            .send()
            .await
            .with_context(|| format!("getTransaction request failed (attempt {attempt})"))?;

        let text = resp.text().await?;
        let val: serde_json::Value = match serde_json::from_str(&text) {
            Ok(v) => v,
            Err(_) => { sleep(delay).await; continue; }
        };

        if val.get("error").is_some() {
            // transaction may not be indexed yet; retry
            sleep(delay).await;
            continue;
        }

        if let Some(fee) = val
            .get("result")
            .and_then(|r| r.get("meta"))
            .and_then(|m| m.get("fee"))
            .and_then(|f| f.as_u64())
        {
            return Ok(fee);
        }

        // not ready yet
        sleep(delay).await;
    }

    Err(anyhow::anyhow!("getTransaction never returned a fee"))
}
