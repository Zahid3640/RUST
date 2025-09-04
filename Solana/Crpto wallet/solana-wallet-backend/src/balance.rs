// use actix_web::{web, App, HttpResponse, HttpServer, Responder, post};
// use serde::{Deserialize, Serialize};
// use solana_client::rpc_client::RpcClient;
// use solana_client::rpc_request::TokenAccountsFilter;
// use solana_account_decoder::UiAccountData;
// use solana_program::program_pack::Pack;
// use solana_sdk::pubkey::Pubkey;
// use spl_token::state::Account as TokenAccount;
// use std::str::FromStr;

// const RPC_URL: &str = "https://api.devnet.solana.com";

// /// Request body for SOL balance
// #[derive(Debug, Deserialize)]
// struct SolBalanceRequest {
//     address: String,
// }

// /// Response body
// #[derive(Debug, Serialize)]
// struct BalanceResponse {
//     balance: u64,
// }

// /// Request body for Token balance
// #[derive(Debug, Deserialize)]
// struct TokenBalanceRequest {
//     owner: String,
//     mint: String,
// }

// /// Check native SOL balance
// fn check_sol_balance(public_address: &str) -> Result<u64, String> {
//     let client = RpcClient::new(RPC_URL.to_string());
//     let pubkey = Pubkey::from_str(public_address)
//         .map_err(|_| "Invalid public key".to_string())?;
//     client.get_balance(&pubkey)
//         .map_err(|e| format!("Error fetching balance: {}", e))
// }

// /// Check specific SPL token balance
// fn check_token_balance(owner_address: &str, token_mint: &str) -> Result<u64, String> {
//     let client = RpcClient::new(RPC_URL.to_string());

//     let owner_pubkey = Pubkey::from_str(owner_address)
//         .map_err(|_| "Invalid owner public key".to_string())?;
//     let mint_pubkey = Pubkey::from_str(token_mint)
//         .map_err(|_| "Invalid token mint key".to_string())?;

//     let accounts = client
//         .get_token_accounts_by_owner(&owner_pubkey, TokenAccountsFilter::Mint(mint_pubkey))
//         .map_err(|e| format!("Error fetching token accounts: {}", e))?;

//     if accounts.is_empty() {
//         return Err("No token accounts found for this wallet & mint.".to_string());
//     }

//     for keyed_account in accounts {
//         if let UiAccountData::Binary(encoded_data, _) = keyed_account.account.data {
//             let data = base64::decode(encoded_data)
//                 .map_err(|_| "Failed to decode account data".to_string())?;
//             let token_account = TokenAccount::unpack(&data)
//                 .map_err(|_| "Failed to unpack token account".to_string())?;
//             return Ok(token_account.amount);
//         }
//     }

//     Err("No valid token account data found.".to_string())
// }

// #[post("/sol_balance")]
// async fn sol_balance(req: web::Json<SolBalanceRequest>) -> impl Responder {
//     match check_sol_balance(&req.address) {
//         Ok(balance) => HttpResponse::Ok().json(BalanceResponse { balance }),
//         Err(e) => HttpResponse::BadRequest().body(e),
//     }
// }

// #[post("/token_balance")]
// async fn token_balance(req: web::Json<TokenBalanceRequest>) -> impl Responder {
//     match check_token_balance(&req.owner, &req.mint) {
//         Ok(balance) => HttpResponse::Ok().json(BalanceResponse { balance }),
//         Err(e) => HttpResponse::BadRequest().body(e),
//     }
// }

use actix_web::{post, web, App, HttpResponse, HttpServer, Responder};
use serde::Deserialize;
use solana_client::rpc_client::RpcClient;
use solana_sdk::pubkey::Pubkey;
use std::sync::Arc;
use std::time::Duration;
use tokio::task;

#[derive(Deserialize)]
pub struct BalanceRequest {
    pub address: String,
}

#[post("/sol_balance")]
async fn sol_balance(req: web::Json<BalanceRequest>) -> impl Responder {
    let address = req.address.clone();

    // ✅ RpcClient with timeout (20s)
    let client = Arc::new(RpcClient::new_with_timeout(
        "https://api.devnet.solana.com".to_string(),
        Duration::from_secs(20),
    ));

    let client_clone = client.clone();
    let result = task::spawn_blocking(move || {
        let pubkey = address
            .parse::<Pubkey>()
            .map_err(|_| "❌ Invalid Solana address".to_string())?;
        client_clone
            .get_balance(&pubkey)
            .map_err(|e| format!("❌ RPC Error: {}", e))
    })
    .await;

    match result {
        Ok(Ok(lamports)) => {
            let sol = lamports as f64 / 1_000_000_000.0;
            HttpResponse::Ok().body(format!("Balance: {} SOL", sol))
        }
        Ok(Err(err)) => HttpResponse::InternalServerError().body(err),
        Err(err) => HttpResponse::InternalServerError().body(format!("❌ Task Join Error: {}", err)),
    }
}

// #[get("/token_balance")]
// async fn token_balance(query: web::Query<BalanceRequest>) -> impl Responder {
//     let client = RpcClient::new("https://api.mainnet-beta.solana.com".to_string());

//     let pubkey = match query.address.parse::<Pubkey>() {
//         Ok(pk) => pk,
//         Err(_) => return HttpResponse::BadRequest().body("Invalid address"),
//     };

//     match client.get_token_accounts_by_owner(
//         &pubkey,
//         solana_client::rpc_client::TokenAccountsFilter::ProgramId(
//             spl_token::id()
//         ),
//     ) {
//         Ok(accounts) => HttpResponse::Ok().json(accounts),
//         Err(err) => HttpResponse::InternalServerError().body(err.to_string()),
//     }
// }


// #[actix_web::main]
// async fn main() -> std::io::Result<()> {
//     println!("🚀 Server running on http://127.0.0.1:3000");

//     HttpServer::new(|| {
//         App::new()
//             .service(sol_balance)
//             .service(token_balance)
//     })
//     .bind(("127.0.0.1", 3000))?
//     .run()
//     .await
// }


// use solana_client::rpc_client::RpcClient;
// use solana_client::rpc_request::TokenAccountsFilter;
// use solana_account_decoder::UiAccountData;
// use solana_program::program_pack::Pack;
// use solana_sdk::pubkey::Pubkey;
// use spl_token::state::Account as TokenAccount;
// use std::str::FromStr;

// /// Check native SOL balance
// pub fn check_sol_balance(rpc_url: &str, public_address: &str) -> Result<u64, String> {
//     let client = RpcClient::new(rpc_url.to_string());
//     let pubkey = Pubkey::from_str(public_address)
//         .map_err(|_| "Invalid public key".to_string())?;
//     client.get_balance(&pubkey)
//         .map_err(|e| format!("Error fetching balance: {}", e))
// }

// /// Check specific SPL token balance
// pub fn check_token_balance(
//     rpc_url: &str,
//     owner_address: &str,
//     token_mint: &str,
// ) -> Result<u64, String> {
//     let client = RpcClient::new(rpc_url.to_string());

//     let owner_pubkey = Pubkey::from_str(owner_address)
//         .map_err(|_| "Invalid owner public key".to_string())?;
//     let mint_pubkey = Pubkey::from_str(token_mint)
//         .map_err(|_| "Invalid token mint key".to_string())?;

//     let accounts = client
//         .get_token_accounts_by_owner(&owner_pubkey, TokenAccountsFilter::Mint(mint_pubkey))
//         .map_err(|e| format!("Error fetching token accounts: {}", e))?;

//     if accounts.is_empty() {
//         return Err("No token accounts found for this wallet & mint.".to_string());
//     }

//     for keyed_account in accounts {
//         if let UiAccountData::Binary(encoded_data, _) = keyed_account.account.data {
//             let data = base64::decode(encoded_data)
//                 .map_err(|_| "Failed to decode account data".to_string())?;
//             let token_account = TokenAccount::unpack(&data)
//                 .map_err(|_| "Failed to unpack token account".to_string())?;
//             return Ok(token_account.amount);
//         }
//     }

//     Err("No valid token account data found.".to_string())
// }



// use solana_client::rpc_client::RpcClient;
// use solana_sdk::pubkey::Pubkey;
// use std::str::FromStr;

// pub async fn check_sol_balance(rpc_url: &str, public_address: &str) -> Result<u64, Box<dyn std::error::Error>> {
//     // 1. RPC client create karo
//     let client = RpcClient::new(rpc_url.to_string());

//     // 2. Pubkey parse karo
//     let pubkey = Pubkey::from_str(public_address)?;

//     // 3. Balance fetch karo (lamports)
//     let balance = client.get_balance(&pubkey)?;

//     Ok(balance)
// }
