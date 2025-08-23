// use actix_web::{App, HttpServer};
// mod token;

// #[actix_web::main]
// async fn main() -> std::io::Result<()> {
//     HttpServer::new(|| {
//         App::new()
//             .service(token::add_token)   // ➕ Add Token
//             .service(token::get_tokens)  // 📥 Get Tokens
//     })
//     .bind("127.0.0.1:8080")?
//     .run()
//     .await
// }


// use actix_web::{App, HttpServer};
// mod stake;

// #[actix_web::main]
// async fn main() -> std::io::Result<()> {
//     HttpServer::new(|| {
//         App::new()
//             .service(stake::stake_tokens) // stake endpoint add
//     })
//     .bind(("127.0.0.1", 8080))?
//     .run()
//     .await
// }


use std::collections::HashMap;
use std::sync::Mutex;
use actix_web::{web, App, HttpResponse, HttpServer, Responder};
use bip39::{Language, Mnemonic};
mod create_wallet;
mod import_wallet; 
mod export_wallet;
mod multi_account;
mod balance_check;
mod send_sol;
mod receive;
mod wallet;

#[derive(serde::Deserialize)]
struct BalanceRequest {
    rpc_url: String,
    public_address: String,
    token_mint: Option<String>,
}
#[derive(serde::Deserialize)]
struct ExportRequest {
    seed_phrase: String,
}
#[derive(serde::Deserialize)]
struct AddAccountRequest {
    seed_phrase: String,
}
 struct AppState {
    wallets: Mutex<HashMap<String, multi_account::WalletAccounts>>,
 }
 use std::time::Duration;

#[derive(serde::Deserialize)]
struct SendSolRequest {
    rpc_url: String,
    private_key: String, // base58 64 bytes
    to_address: String,
    amount: f64, // in SOL
}

async fn send_sol_handler(req: web::Json<SendSolRequest>) -> impl Responder {
    let req = req.into_inner();

    // Move data into blocking closure
    let rpc_url = req.rpc_url;
    let private_key = req.private_key;
    let to_address = req.to_address;
    let amount = req.amount;

    // Run blocking solana rpc call inside threadpool
    let result = web::block(move || {
        send_sol::send_sol_blocking(&rpc_url, &private_key, &to_address, amount)
    })
    .await;

    match result {
        // web::block returns Result<ReturnType, BlockingError>
        Ok(Ok(sig)) => HttpResponse::Ok().json(serde_json::json!({
            "status": "ok",
            "signature": sig
        })),
        Ok(Err(err_msg)) => HttpResponse::BadRequest().json(serde_json::json!({
            "status": "error",
            "message": err_msg
        })),
        Err(e) => {
            // blocking thread failed or was cancelled
            HttpResponse::InternalServerError().json(serde_json::json!({
                "status": "error",
                "message": format!("Internal execution error: {}", e)
            }))
        }
    }
}
 async fn check_balance_handler(req: web::Json<BalanceRequest>) -> impl Responder {
    let req_data = req.into_inner();

    // Run blocking code in a thread pool
    let result = web::block(move || {
        if let Some(token_mint) = req_data.token_mint {
            balance_check::check_token_balance(
                &req_data.rpc_url,
                &req_data.public_address,
                &token_mint,
            )
            .map(|amount| serde_json::json!({ "type": "token", "balance": amount }))
        } else {
            balance_check::check_sol_balance(&req_data.rpc_url, &req_data.public_address)
                .map(|lamports| {
                    serde_json::json!({
                        "type": "SOL",
                        "balance": lamports as f64 / 1_000_000_000f64
                    })
                })
        }
    })
    .await;

    match result {
        Ok(Ok(json)) => HttpResponse::Ok().json(json),
        Ok(Err(err_msg)) => HttpResponse::BadRequest().body(err_msg),
        Err(e) => HttpResponse::InternalServerError().body(format!("Thread error: {}", e)),
    }
}
async fn add_account(
    data: web::Data<AppState>,
    req: web::Json<AddAccountRequest>,
) -> impl Responder {
    let seed_phrase = &req.seed_phrase;

    let mnemonic = match Mnemonic::parse_in_normalized(Language::English, seed_phrase) {
        Ok(m) => m,
        Err(_) => return HttpResponse::BadRequest().body("Invalid seed phrase"),
    };

    let mut wallets = data.wallets.lock().unwrap();

    let wallet_accounts = wallets.entry(seed_phrase.clone()).or_insert_with(|| {
        multi_account::WalletAccounts::new(mnemonic)
    });

    wallet_accounts.add_next_account();

    let accounts_info = wallet_accounts.get_accounts_info();

    HttpResponse::Ok().json(accounts_info)
}
// existing create_wallet handler (if you already have it, leave as is)
// async fn create_wallet_handler() -> impl Responder {
//     let wallet_json = create_wallet::create_wallet( &req.password,
//         &req.confirm_password,); // your existing create_wallet returns JSON string
//     HttpResponse::Ok()
//         .content_type("application/json")
//         .body(wallet_json)
// }

// New: POST /import-wallet (JSON body)
//#[derive(serde::Deserialize)]
// struct ImportRequest {
//     /// Provide either mnemonic OR private_key (base58). If both provided, mnemonic will be used.
//     mnemonic: Option<String>,
//     private_key: Option<String>,
// }

// async fn import_wallet_handler(req: web::Json<ImportRequest>) -> impl Responder {
//     let body = req.into_inner();

//     if let Some(mnemonic) = body.mnemonic {
//         match import_wallet::import_from_mnemonic_json(&mnemonic) {
//             Ok(json_val) => HttpResponse::Ok()
//                 .content_type("application/json")
//                 .body(json_val.to_string()),
//             Err(e) => HttpResponse::BadRequest()
//                 .content_type("application/json")
//                 .body(
//                     serde_json::json!({"status":"error","message": format!("{}", e)}).to_string()
//                 ),
//         }
//     } else if let Some(pk) = body.private_key {
//         match import_wallet::import_from_private_key_json(&pk) {
//             Ok(json_val) => HttpResponse::Ok()
//                 .content_type("application/json")
//                 .body(json_val.to_string()),
//             Err(e) => HttpResponse::BadRequest()
//                 .content_type("application/json")
//                 .body(
//                     serde_json::json!({"status":"error","message": format!("{}", e)}).to_string()
//                 ),
//         }
//     } else {
//         HttpResponse::BadRequest()
//             .content_type("application/json")
//             .body(serde_json::json!({"status":"error","message":"Provide mnemonic or private_key"}).to_string())
//     }
// }

async fn export_wallet_handler(payload: web::Json<ExportRequest>) -> impl Responder {

    match export_wallet::export_wallet(&payload.seed_phrase) {
        Ok(json_str) => HttpResponse::Ok()
                            .content_type("application/json")
                            .body(json_str),
        Err(e) => HttpResponse::BadRequest().body(e),
    }
}
#[actix_web::main]
async fn main() -> std::io::Result<()> {
        let local_ip = "127.0.0.1";
    let port = 3000;

    println!("🚀 Server at http://{}:{}", local_ip, port);

    // println!("🚀 Server running at http://127.0.0.1:8082");
    let app_state = web::Data::new(AppState {
         wallets: Mutex::new(HashMap::new()),
     });
    HttpServer::new(move || {
        App::new()
            .service(wallet::create_wallet)
            .service(wallet::import_wallet)
            .service(wallet::unlock_wallet)
            .route("/export-wallet", web::post().to(export_wallet_handler))
            .app_data(app_state.clone())
            .route("/add-account", web::post().to(add_account))
            .route("/check-balance", web::post().to(check_balance_handler))
            .route("/send-sol", web::post().to(send_sol_handler))
            .service(receive::receive_wallet)
    })
    .bind(("127.0.0.1", port))?
    .run()
    .await
}