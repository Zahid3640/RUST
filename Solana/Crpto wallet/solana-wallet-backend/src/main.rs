use std::net::SocketAddr;

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
mod send_sol;
mod receive;
mod wallet;
mod balance;
mod history;

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
    let port = 8082;

    println!("🚀 Server at http://0.0.0.0:{port}");

    let app_state = web::Data::new(AppState {
        wallets: Mutex::new(HashMap::new()),
    });

    HttpServer::new(move || {
        App::new()
            .app_data(app_state.clone())
            .service(wallet::create_wallet)
            .service(wallet::import_wallet)
            .service(wallet::unlock_wallet)
            .service(balance::sol_balance)
            .service(receive::receive_wallet)
            .service(history::sol_history)
            .service(send_sol::sol_send)
            .route("/export-wallet", web::post().to(export_wallet_handler))
            .route("/add-account", web::post().to(add_account))
    })
    .bind(("0.0.0.0", port))?      // <- important
    .run()
    .await
}
