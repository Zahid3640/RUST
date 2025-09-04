use serde::{Deserialize, Serialize};
use actix_web::{post, web, HttpResponse, Responder};

#[derive(Debug, Deserialize)]
pub struct StakeRequest {
    pub seed_phrase: String,   // user wallet seed phrase
    pub validator_address: String, // jis validator k sath stake karna h
    pub amount: f64,           // stake amount
}

#[derive(Debug, Serialize)]
pub struct StakeResponse {
    pub success: bool,
    pub message: String,
    pub staked_amount: f64,
    pub validator: String,
}

#[post("/stake")]
async fn stake_tokens(req: web::Json<StakeRequest>) -> impl Responder {
    // ⚡ Normally yaha wallet se keypair generate hota, 
    // RPC call hoti aur stake transaction submit hota.
    // Abhi hum dummy response return kar rahy hain.

    let response = StakeResponse {
        success: true,
        message: "Staking successful".to_string(),
        staked_amount: req.amount,
        validator: req.validator_address.clone(),
    };

    HttpResponse::Ok().json(response)
}
