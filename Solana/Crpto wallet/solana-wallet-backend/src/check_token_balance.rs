use solana_client::rpc_client::RpcClient;
use solana_client::rpc_request::TokenAccountsFilter;
use solana_account_decoder::UiAccountData;
use solana_program::program_pack::Pack;
use solana_sdk::pubkey::Pubkey;
use spl_token::state::Account as TokenAccount;
use std::str::FromStr;

fn main() {
    let rpc_url = "https://api.mainnet-beta.solana.com";
    let client = RpcClient::new(rpc_url.to_string());

    let owner_pubkey = Pubkey::from_str("DEVxWnrLX4ZGWTHSuHRd5jRJHUo4TNKwxNGEDvbesZjz").unwrap();

    let token_mint = Pubkey::from_str("EPjFWdd5AufqSSqeM2qN1xzybapC8G4wEGGkZwyTDt1v").unwrap();

    let accounts = client
        .get_token_accounts_by_owner(&owner_pubkey, TokenAccountsFilter::Mint(token_mint))
        .unwrap();

    if accounts.is_empty() {
        println!("No token accounts found for this wallet & mint.");
        return;
    }

    for keyed_account in accounts {
        if let UiAccountData::Json(parsed_data) = keyed_account.account.data {
            println!("Account data is JSON — cannot unpack directly.");
        } else if let UiAccountData::Binary(encoded_data, _) = keyed_account.account.data {
            // Base64 decode
            let data = base64::decode(encoded_data).unwrap();

            let token_account = TokenAccount::unpack(&data).unwrap();
            println!("Token balance: {}", token_account.amount);
        }
    }
}
