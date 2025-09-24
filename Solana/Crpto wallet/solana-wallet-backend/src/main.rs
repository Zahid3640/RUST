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
mod send_nfts;
use actix_cors::Cors;
use env_logger::Env;
use dotenvy;
mod routes; 
mod multichain_wallet;


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
        dotenvy::dotenv().ok();                      // ← loads .env from CWD
    env_logger::init();

    // sanity: DO NOT print the token; just “yes/no”
    log::info!("PINATA_JWT present: {}", if std::env::var("PINATA_JWT").is_ok() { "yes" } else { "no" });
    let port = 8082;

    println!("🚀 Server at http://0.0.0.0:{port}");

    let app_state = web::Data::new(AppState {
        wallets: Mutex::new(HashMap::new()),
    });

    HttpServer::new(move || {
        App::new()
         .wrap(
                Cors::default()
                    .allow_any_origin()
                    .allow_any_header()
                    .allow_any_method()
            )
            // increase multipart/body size (25 MB)
            .app_data(web::PayloadConfig::new(25 * 1024 * 1024))
            .service(routes::create_nft) 
            .app_data(app_state.clone())
            .service(wallet::create_wallet)
            //.service(multichain_wallet::create_wallet_multichain)
            //.service(multichain_wallet::unlock_wallet)
            .service(routes::get_nfts)
            .service(send_nfts::send_nft)
            .service(wallet::import_wallet)
            .service(wallet::unlock_wallet)
            .service(balance::sol_balance)
            .service(receive::receive_wallet)
            .service(history::sol_history)
            .service(send_sol::sol_send)
            .service(wallet::export_wallet)
            .route("/add-account", web::post().to(add_account))
    })
    .bind(("0.0.0.0", port))?      // <- important
    .run()
    .await
}
// use actix_cors::Cors;
// use actix_web::{web, App, HttpServer};
// use env_logger::Env;

// mod routes; // your create_nft route lives here

// #[actix_web::main]
// async fn main() -> std::io::Result<()> {
//     env_logger::Builder::from_env(Env::default().default_filter_or("info")).init();

//     HttpServer::new(|| {
//         App::new()
//             // allow your phone ↔ local server
//             .wrap(
//                 Cors::default()
//                     .allow_any_origin()
//                     .allow_any_header()
//                     .allow_any_method()
//             )
//             // increase multipart/body size (25 MB)
//             .app_data(web::PayloadConfig::new(25 * 1024 * 1024))
//             .service(routes::create_nft) // #[post("/create_nft")]
//     })
//     .bind(("0.0.0.0", 8082))?
//     .run()
//     .await
// }
