use actix_web::{post, web, HttpResponse, Responder};
use serde::{Deserialize, Serialize};
use std::collections::HashMap;
use std::sync::Mutex;
use lazy_static::lazy_static;

#[derive(Debug, Serialize, Deserialize, Clone)]
pub struct Token {
    pub mint_address: String,   // Token ka unique address
    pub symbol: String,         // e.g. SOL, USDC
    pub balance: f64,           // Default 0
}

// Har wallet ka address → uske tokens ka list
lazy_static! {
    static ref WALLETS: Mutex<HashMap<String, Vec<Token>>> = Mutex::new(HashMap::new());
}

#[derive(Debug, Deserialize)]
pub struct AddTokenRequest {
    pub wallet_address: String, // Kis wallet ke andar token add karna hai
    pub mint_address: String,
    pub symbol: String,
}

/// ➕ Add Token API
#[post("/wallet/add_token")]
async fn add_token(req: web::Json<AddTokenRequest>) -> impl Responder {
    let mut wallets = WALLETS.lock().unwrap();

    // Wallet ka tokens list nikaal lo (agar nahi hai to naya banado)
    let tokens = wallets.entry(req.wallet_address.clone()).or_insert_with(Vec::new);

    // Duplicate token check
    if tokens.iter().any(|t| t.mint_address == req.mint_address) {
        return HttpResponse::BadRequest().json(serde_json::json!({
            "status": "error",
            "message": "Token already exists in this wallet"
        }));
    }

    // Naya token add karo
    tokens.push(Token {
        mint_address: req.mint_address.clone(),
        symbol: req.symbol.clone(),
        balance: 0.0,
    });

    HttpResponse::Ok().json(serde_json::json!({
        "status": "success",
        "message": format!("Token {} added to wallet {}", req.symbol, req.wallet_address)
    }))
}

#[derive(Debug, Deserialize)]
pub struct GetTokensRequest {
    pub wallet_address: String,
}

/// 📥 Get Tokens API
#[post("/wallet/get_tokens")]
async fn get_tokens(req: web::Json<GetTokensRequest>) -> impl Responder {
    let wallets = WALLETS.lock().unwrap();

    if let Some(tokens) = wallets.get(&req.wallet_address) {
        HttpResponse::Ok().json(serde_json::json!({
            "status": "success",
            "wallet_address": req.wallet_address,
            "tokens": tokens
        }))
    } else {
        HttpResponse::NotFound().json(serde_json::json!({
            "status": "error",
            "message": "No tokens found for this wallet"
        }))
    }
}
