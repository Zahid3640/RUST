// use actix_web::{post, web, HttpResponse, Responder};
// use serde::{Deserialize, Serialize};
// use solana_client::nonblocking::rpc_client::RpcClient;
// use solana_transaction_status::UiTransactionEncoding;
// use solana_sdk::{
//     pubkey::Pubkey,
//     signature::{Keypair, Signer},
//     transaction::Transaction,
//     commitment_config::CommitmentConfig,
// };
// use spl_associated_token_account::instruction::create_associated_token_account;
// use spl_token::instruction as token_instruction;
// use std::str::FromStr;
// use bs58;

// /// Request body
// #[derive(Deserialize)]
// pub struct SendNftRequest {
//     pub sender_private_key: String, // base58 64-byte keypair
//     pub receiver_address: String,   // base58 pubkey
//     pub mint_address: String,       // NFT mint pubkey
// }

// /// Response body
// #[derive(Serialize)]
// pub struct SendNftResponse {
//     pub signature: String,
//     pub fee_lamports: u64,
//     pub fee_sol: f64,
//     pub network: String,
//     pub message: String,
// }

// #[post("/send_nft")]
// pub async fn send_nft(req: web::Json<SendNftRequest>) -> impl Responder {
//     // 1) RPC selection (env SOLANA_RPC or default to devnet)
//     let rpc_url = std::env::var("SOLANA_RPC")
//         .unwrap_or_else(|_| "https://api.devnet.solana.com".to_string());

//     let network = if rpc_url.contains("devnet") {
//         "Solana Devnet"
//     } else if rpc_url.contains("testnet") {
//         "Solana Testnet"
//     } else {
//         "Solana Mainnet"
//     }
//     .to_string();

//     let client = RpcClient::new_with_commitment(rpc_url.clone(), CommitmentConfig::confirmed());

//     // 2) Parse sender keypair (base58 bytes)
//     let sender_bytes = match bs58::decode(&req.sender_private_key).into_vec() {
//         Ok(b) => b,
//         Err(_) => return HttpResponse::BadRequest().body("Invalid sender private key (not base58)"),
//     };
//     if sender_bytes.len() != 64 {
//         return HttpResponse::BadRequest()
//             .body("sender_private_key must decode to 64 bytes (full ed25519 keypair)");
//     }
//     let sender = match Keypair::from_bytes(&sender_bytes) {
//         Ok(kp) => kp,
//         Err(_) => return HttpResponse::BadRequest().body("Failed to parse sender keypair bytes"),
//     };

//     // 3) Parse receiver and mint pubkeys
//     let receiver = match Pubkey::from_str(&req.receiver_address) {
//         Ok(pk) => pk,
//         Err(_) => return HttpResponse::BadRequest().body("Invalid receiver_address"),
//     };
//     let mint = match Pubkey::from_str(&req.mint_address) {
//         Ok(pk) => pk,
//         Err(_) => return HttpResponse::BadRequest().body("Invalid mint_address"),
//     };

//     // 4) Derive associated token accounts (ATAs)
//     let sender_ata = spl_associated_token_account::get_associated_token_address(&sender.pubkey(), &mint);
//     let receiver_ata = spl_associated_token_account::get_associated_token_address(&receiver, &mint);

//     // 5) Build instructions:
//     // - Create receiver ATA (only if missing)
//     // - Transfer 1 token from sender ATA -> receiver ATA
//     let mut instructions = Vec::new();

//     // If receiver ATA doesn't exist, create it (payer = sender)
//     match client.get_account(&receiver_ata).await {
//         Ok(_) => {
//             // receiver ATA exists -> nothing to do
//         }
//         Err(_) => {
//             // create associated token account instruction
//           instructions.push(create_associated_token_account(
//     &sender.pubkey(),
//     &receiver,
//     &mint,
//     &spl_token::id(), // <-- missing argument added
// ));
//         }
//     }

//     // Transfer instruction (amount = 1 for NFT)
//     let transfer_ix = match token_instruction::transfer(
//         &spl_token::id(),
//         &sender_ata,
//         &receiver_ata,
//         &sender.pubkey(),
//         &[],
//         1,
//     ) {
//         Ok(ix) => ix,
//         Err(e) => {
//             return HttpResponse::InternalServerError()
//                 .body(format!("Failed to build transfer instruction: {}", e))
//         }
//     };
//     instructions.push(transfer_ix);

//     // 6) Get recent blockhash
//     let recent = match client.get_latest_blockhash().await {
//         Ok(b) => b,
//         Err(e) => {
//             return HttpResponse::InternalServerError()
//                 .body(format!("Failed to fetch recent blockhash: {}", e))
//         }
//     };

//     // 7) Sign transaction
//     let mut tx = Transaction::new_with_payer(&instructions, Some(&sender.pubkey()));
//     tx.sign(&[&sender], recent);

//     // 8) Send & confirm
//     let sig = match client.send_and_confirm_transaction(&tx).await {
//         Ok(s) => s,
//         Err(e) => {
//             return HttpResponse::InternalServerError()
//                 .body(format!("Transaction failed: {}", e))
//         }
//     };

//     // 9) Fetch actual transaction info (to read meta.fee)
//     //    use UiTransactionEncoding::JsonParsed for richer view
//     let fee_lamports: u64 = match client
//         .get_transaction(&sig, UiTransactionEncoding::JsonParsed)
//         .await
//     {
//         Ok(tx_info) => {
//             // many EncodedConfirmedTransactionWithStatusMeta versions have `meta` field
//             // meta is Option<TransactionStatusMeta>
//             tx_info
//                 .transaction.meta
//                 .map(|m| m.fee)
//                 .unwrap_or(0_u64) // fallback to 0 if meta missing
//         }
//         Err(e) => {
//             // If we cannot fetch tx info, still return success but with fee = 0 and note
//             log::error!("Failed to fetch transaction info for {}: {}", sig, e);
//             0_u64
//         }
//     };

//     let fee_sol = fee_lamports as f64 / 1_000_000_000.0;

//     // 10) Return result
//     let resp = SendNftResponse {
//         signature: sig.to_string(),
//         fee_lamports,
//         fee_sol,
//         network,
//         message: "NFT sent (transfer + optional ATA creation).".to_string(),
//     };

//     HttpResponse::Ok().json(resp)
// }


// use actix_web::{post, web, HttpResponse, Responder};
// use serde::{Deserialize, Serialize};
// use solana_client::nonblocking::rpc_client::RpcClient;
// use solana_sdk::{
//     commitment_config::CommitmentConfig,
//     message::Message,
//     pubkey::Pubkey,
//     signature::{Keypair, Signer},
//     transaction::Transaction,
// };
// use spl_associated_token_account::instruction::create_associated_token_account;
// use spl_token::instruction as token_instruction;
// use std::str::FromStr;
// use bs58;

// #[derive(Deserialize)]
// pub struct SendNftRequest {
//     pub sender_private_key: String, // base58 64-byte keypair
//     pub receiver_address: String,   // base58 pubkey
//     pub mint_address: String,       // NFT mint pubkey
// }

// #[derive(Serialize)]
// pub struct SendNftResponse {
//     pub signature: String,
//     pub fee_lamports: u64,
//     pub fee_sol: f64,
//     pub network: String,
//     pub message: String,
// }

// #[post("/send_nft")]
// pub async fn send_nft(req: web::Json<SendNftRequest>) -> impl Responder {
//     // 1) RPC setup
//     let rpc_url = std::env::var("SOLANA_RPC")
//         .unwrap_or_else(|_| "https://api.devnet.solana.com".to_string());

//     let network = if rpc_url.contains("devnet") {
//         "Solana Devnet"
//     } else if rpc_url.contains("testnet") {
//         "Solana Testnet"
//     } else {
//         "Solana Mainnet"
//     }
//     .to_string();

//     let client = RpcClient::new_with_commitment(rpc_url.clone(), CommitmentConfig::confirmed());

//     // 2) Parse sender keypair
//     let sender_bytes = match bs58::decode(&req.sender_private_key).into_vec() {
//         Ok(b) => b,
//         Err(_) => return HttpResponse::BadRequest().body("Invalid sender private key (not base58)"),
//     };
//     if sender_bytes.len() != 64 {
//         return HttpResponse::BadRequest()
//             .body("sender_private_key must decode to 64 bytes (full ed25519 keypair)");
//     }
//     let sender = match Keypair::from_bytes(&sender_bytes) {
//         Ok(kp) => kp,
//         Err(_) => return HttpResponse::BadRequest().body("Failed to parse sender keypair bytes"),
//     };

//     // 3) Parse receiver + mint
//     let receiver = match Pubkey::from_str(&req.receiver_address) {
//         Ok(pk) => pk,
//         Err(_) => return HttpResponse::BadRequest().body("Invalid receiver_address"),
//     };
//     let mint = match Pubkey::from_str(&req.mint_address) {
//         Ok(pk) => pk,
//         Err(_) => return HttpResponse::BadRequest().body("Invalid mint_address"),
//     };

//     // 4) Derive ATAs
//     let sender_ata =
//         spl_associated_token_account::get_associated_token_address(&sender.pubkey(), &mint);
//     let receiver_ata =
//         spl_associated_token_account::get_associated_token_address(&receiver, &mint);

//     // 5) Instructions
//     let mut instructions = Vec::new();

//     // If receiver ATA doesn’t exist → create
//     if client.get_account(&receiver_ata).await.is_err() {
//         instructions.push(create_associated_token_account(
//             &sender.pubkey(),
//             &receiver,
//             &mint,
//             &spl_token::id(),
//         ));
//     }

//     // Transfer instruction
//     let transfer_ix = match token_instruction::transfer(
//         &spl_token::id(),
//         &sender_ata,
//         &receiver_ata,
//         &sender.pubkey(),
//         &[],
//         1,
//     ) {
//         Ok(ix) => ix,
//         Err(e) => {
//             return HttpResponse::InternalServerError()
//                 .body(format!("Failed to build transfer instruction: {}", e))
//         }
//     };
//     instructions.push(transfer_ix);

//     // 6) Fetch blockhash
//     let recent_blockhash = match client.get_latest_blockhash().await {
//         Ok(b) => b,
//         Err(e) => {
//             return HttpResponse::InternalServerError()
//                 .body(format!("Failed to fetch blockhash: {}", e))
//         }
//     };

//     // 7) Calculate fee (using blockhash + message)
//     let message = Message::new(&instructions, Some(&sender.pubkey()));
//     let fee_lamports = match client.get_fee_calculator_for_blockhash(&recent_blockhash).await {
//         Ok(Some(calc)) => calc.lamports_per_signature, // per signature cost
//         Ok(None) => 0,
//         Err(e) => {
//             eprintln!("Fee fetch error: {}", e);
//             0
//         }
//     };
//     let fee_sol = fee_lamports as f64 / 1_000_000_000.0;

//     // 8) Build + sign transaction
//     let mut tx = Transaction::new_with_payer(&instructions, Some(&sender.pubkey()));
//     tx.sign(&[&sender], recent_blockhash);

//     // 9) Send transaction
//     let sig = match client.send_and_confirm_transaction(&tx).await {
//         Ok(s) => s,
//         Err(e) => {
//             return HttpResponse::InternalServerError()
//                 .body(format!("Transaction failed: {}", e))
//         }
//     };

//     // 10) Response
//     let resp = SendNftResponse {
//         signature: sig.to_string(),
//         fee_lamports,
//         fee_sol,
//         network,
//         message: "NFT sent successfully (transfer + ATA if needed).".to_string(),
//     };

//     HttpResponse::Ok().json(resp)
// }
use actix_web::{post, web, HttpResponse, Responder};
use anyhow::{Context, Result};
use bs58;
use serde::{Deserialize, Serialize};
use serde_json::json;
use solana_client::nonblocking::rpc_client::RpcClient;
use solana_sdk::{
    commitment_config::CommitmentConfig,
    message::Message,
    pubkey::Pubkey,
    signature::{Keypair, Signer},
    transaction::Transaction,
};
use spl_associated_token_account::instruction::create_associated_token_account;
use spl_token::instruction as token_instruction;
use std::str::FromStr;

// for retries
use tokio::time::{sleep, Duration};

#[derive(Deserialize)]
pub struct SendNftRequest {
    pub sender_private_key: String, // base58 64-byte keypair
    pub receiver_address: String,   // base58 pubkey
    pub mint_address: String,       // NFT mint pubkey
}

#[derive(Serialize)]
pub struct SendNftResponse {
    pub signature: String,
    pub fee_lamports: u64,
    pub fee_sol: f64,
    pub network: String,
    pub message: String,
}

#[post("/send_nft")]
pub async fn send_nft(req: web::Json<SendNftRequest>) -> impl Responder {
    if req.sender_private_key.trim().is_empty()
        || req.receiver_address.trim().is_empty()
        || req.mint_address.trim().is_empty()
    {
        return HttpResponse::BadRequest().body("sender_private_key, receiver_address, mint_address are required");
    }

    // 1) RPC setup
    let rpc_url = std::env::var("SOLANA_RPC")
        .unwrap_or_else(|_| "https://api.devnet.solana.com".to_string());

    let network = if rpc_url.contains("devnet") {
        "Solana Devnet"
    } else if rpc_url.contains("testnet") {
        "Solana Testnet"
    } else {
        "Solana Mainnet"
    }
    .to_string();

    let client = RpcClient::new_with_commitment(rpc_url.clone(), CommitmentConfig::confirmed());

    // 2) Parse sender keypair
    let sender_bytes = match bs58::decode(&req.sender_private_key).into_vec() {
        Ok(b) => b,
        Err(_) => return HttpResponse::BadRequest().body("Invalid sender_private_key (not base58)"),
    };
    if sender_bytes.len() != 64 {
        return HttpResponse::BadRequest()
            .body("sender_private_key must decode to 64 bytes (ed25519 keypair)");
    }
    let sender = match Keypair::from_bytes(&sender_bytes) {
        Ok(kp) => kp,
        Err(_) => return HttpResponse::BadRequest().body("Failed to parse sender keypair bytes"),
    };

    // 3) Parse receiver + mint
    let receiver = match Pubkey::from_str(&req.receiver_address) {
        Ok(pk) => pk,
        Err(_) => return HttpResponse::BadRequest().body("Invalid receiver_address"),
    };
    let mint = match Pubkey::from_str(&req.mint_address) {
        Ok(pk) => pk,
        Err(_) => return HttpResponse::BadRequest().body("Invalid mint_address"),
    };

    // 4) ATAs
    let sender_ata =
        spl_associated_token_account::get_associated_token_address(&sender.pubkey(), &mint);
    let receiver_ata =
        spl_associated_token_account::get_associated_token_address(&receiver, &mint);

    // 5) Build instructions (create receiver ATA if missing, then transfer 1)
    let mut instructions = Vec::new();

    if client.get_account(&receiver_ata).await.is_err() {
        instructions.push(create_associated_token_account(
            &sender.pubkey(),
            &receiver,
            &mint,
            &spl_token::id(),
        ));
    }

    let transfer_ix = match token_instruction::transfer(
        &spl_token::id(),
        &sender_ata,
        &receiver_ata,
        &sender.pubkey(),
        &[],
        1,
    ) {
        Ok(ix) => ix,
        Err(e) => {
            return HttpResponse::InternalServerError()
                .body(format!("Failed to build transfer instruction: {e}"))
        }
    };
    instructions.push(transfer_ix);

    // 6) Blockhash
    let recent_blockhash = match client.get_latest_blockhash().await {
        Ok(b) => b,
        Err(e) => {
            return HttpResponse::InternalServerError()
                .body(format!("Failed to fetch blockhash: {e}"))
        }
    };

    // 7) Build + sign
    let mut tx = Transaction::new_with_payer(&instructions, Some(&sender.pubkey()));
    tx.sign(&[&sender], recent_blockhash);

    // 8) Send + confirm
    let sig = match client.send_and_confirm_transaction(&tx).await {
        Ok(s) => s,
        Err(e) => {
            return HttpResponse::InternalServerError()
                .body(format!("Transaction failed: {e}"))
        }
    };
    let sig_str = sig.to_string();
 
    // 9) Fetch the **actual fee** via JSON-RPC getTransaction with retries
    let fee_lamports = match fetch_fee_with_retries(&rpc_url, &sig_str, 10, Duration::from_millis(300)).await {
        Ok(fee) => fee,
        Err(e) => {
            eprintln!("fee fetch failed after retries: {e:#}");
            0
        }
    };
    let fee_sol = fee_lamports as f64 / 1_000_000_000.0;

    // 10) Response
    let resp = SendNftResponse {
        signature: sig_str,
        fee_lamports,
        fee_sol,
        network,
        message: "NFT sent successfully (transfer + ATA if needed).".to_string(),
    };
    HttpResponse::Ok().json(resp)
}

/// Poll getTransaction until result.meta.fee is available.
/// Works across crate versions because we parse raw JSON.
async fn fetch_fee_with_retries(
    rpc_url: &str,
    signature: &str,
    tries: usize,
    delay: Duration,
) -> Result<u64> {
    let http = reqwest::Client::new();

    for attempt in 1..=tries {
        let body = json!({
            "jsonrpc": "2.0",
            "id": 1,
            "method": "getTransaction",
            "params": [
                signature,
                {
                    "encoding": "json",
                    "commitment": "confirmed",
                    "maxSupportedTransactionVersion": 0
                }
            ]
        });

        let resp = http
            .post(rpc_url)
            .json(&body)
            .send()
            .await
            .with_context(|| format!("getTransaction request failed (attempt {attempt})"))?;

        // If provider rate limits, this can be 429 with HTML. Try to parse JSON but be resilient.
        let text = resp.text().await?;
        let val: serde_json::Value = match serde_json::from_str(&text) {
            Ok(v) => v,
            Err(_) => {
                // Not JSON (maybe 429 HTML). Retry.
                sleep(delay).await;
                continue;
            }
        };

        // JSON-RPC error?
        if let Some(err) = val.get("error") {
            // If it's "Transaction not found" or similar, retry a few times
            sleep(delay).await;
            continue;
        }

        // Extract result.meta.fee
        if let Some(fee) = val
            .get("result")
            .and_then(|r| r.get("meta"))
            .and_then(|m| m.get("fee"))
            .and_then(|f| f.as_u64())
        {
            return Ok(fee);
        }

        // If result is null or meta missing, wait and retry
        sleep(delay).await;
    }

    Err(anyhow::anyhow!("getTransaction never returned a fee"))
}
