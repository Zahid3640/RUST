use actix_web::{post, web, HttpResponse, Responder};
use serde::{Deserialize, Serialize};
use solana_client::rpc_client::RpcClient;
use solana_sdk::pubkey::Pubkey;
use std::str::FromStr;

#[derive(Deserialize)]
pub struct HistoryRequest {
    pub address: String,   // jis account ki tx history chahiye
}

#[derive(Serialize)]
pub struct TxInfo {
    pub signature: String,
    pub slot: u64,
    pub block_time: Option<i64>,
    pub err: Option<String>,
}

#[post("/sol_history")]
pub async fn sol_history(req: web::Json<HistoryRequest>) -> impl Responder {
    let rpc_url = "https://api.devnet.solana.com";
    let address_str = req.address.clone();

    let result = tokio::task::spawn_blocking(move || -> Result<Vec<TxInfo>, String> {
        let client = RpcClient::new(rpc_url.to_string());

        let pubkey = Pubkey::from_str(&address_str)
            .map_err(|e| format!("Invalid pubkey: {}", e))?;

        // ✅ last 10 signatures nikal lo
        let sig_infos = client
            .get_signatures_for_address(&pubkey)
            .map_err(|e| format!("RPC error: {}", e))?;

        // sirf 10 latest lo
        let mut history: Vec<TxInfo> = Vec::new();
        for sig in sig_infos.into_iter().take(10) {
            history.push(TxInfo {
                signature: sig.signature,
                slot: sig.slot,
                block_time: sig.block_time,
                err: sig.err.map(|e| format!("{:?}", e)),
            });
        }

        Ok(history)
    })
    .await;
    match result {
        Ok(Ok(history)) => HttpResponse::Ok().json(history),
        Ok(Err(e)) => HttpResponse::InternalServerError().body(format!("❌ Error: {}", e)),
        Err(e) => HttpResponse::InternalServerError().body(format!("❌ Spawn error: {}", e)),
    }
}
