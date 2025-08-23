use solana_client::rpc_client::RpcClient;
use solana_client::rpc_request::TokenAccountsFilter;
use solana_account_decoder::UiAccountData;
use solana_program::program_pack::Pack;
use solana_sdk::pubkey::Pubkey;
use spl_token::state::Account as TokenAccount;
use std::str::FromStr;

/// Check native SOL balance
pub fn check_sol_balance(rpc_url: &str, public_address: &str) -> Result<u64, String> {
    let client = RpcClient::new(rpc_url.to_string());
    let pubkey = Pubkey::from_str(public_address)
        .map_err(|_| "Invalid public key".to_string())?;
    client.get_balance(&pubkey)
        .map_err(|e| format!("Error fetching balance: {}", e))
}

/// Check specific SPL token balance
pub fn check_token_balance(
    rpc_url: &str,
    owner_address: &str,
    token_mint: &str,
) -> Result<u64, String> {
    let client = RpcClient::new(rpc_url.to_string());

    let owner_pubkey = Pubkey::from_str(owner_address)
        .map_err(|_| "Invalid owner public key".to_string())?;
    let mint_pubkey = Pubkey::from_str(token_mint)
        .map_err(|_| "Invalid token mint key".to_string())?;

    let accounts = client
        .get_token_accounts_by_owner(&owner_pubkey, TokenAccountsFilter::Mint(mint_pubkey))
        .map_err(|e| format!("Error fetching token accounts: {}", e))?;

    if accounts.is_empty() {
        return Err("No token accounts found for this wallet & mint.".to_string());
    }

    for keyed_account in accounts {
        if let UiAccountData::Binary(encoded_data, _) = keyed_account.account.data {
            let data = base64::decode(encoded_data)
                .map_err(|_| "Failed to decode account data".to_string())?;
            let token_account = TokenAccount::unpack(&data)
                .map_err(|_| "Failed to unpack token account".to_string())?;
            return Ok(token_account.amount);
        }
    }

    Err("No valid token account data found.".to_string())
}



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
