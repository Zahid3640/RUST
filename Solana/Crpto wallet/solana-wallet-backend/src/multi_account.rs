use bip39::Mnemonic;
use solana_sdk::{
    derivation_path::DerivationPath,
    signature::{keypair_from_seed_and_derivation_path, Keypair}, signer::Signer,
};
use bs58;
use std::collections::HashMap;
use std::sync::Mutex;

#[derive(Debug)]
pub struct WalletAccounts {
    mnemonic: Mnemonic,
    accounts: Vec<Keypair>,
}

impl WalletAccounts {
    pub fn new(mnemonic: Mnemonic) -> Self {
        Self {
            mnemonic,
            accounts: Vec::new(),
        }
    }

    // Derive next account and add to list
    pub fn add_next_account(&mut self) {
        let index = self.accounts.len() as u32;
        let seed = self.mnemonic.to_seed("");
        let derivation_path_str = format!("m/44'/501'/{}'/0'", index);
        let derivation_path = DerivationPath::from_absolute_path_str(&derivation_path_str)
            .expect("Invalid derivation path");
        let keypair = keypair_from_seed_and_derivation_path(&seed, Some(derivation_path))
            .expect("Failed to derive keypair");
        self.accounts.push(keypair);
    }

    pub fn get_accounts_info(&self) -> Vec<serde_json::Value> {
        self.accounts
            .iter()
            .enumerate()
            .map(|(i, keypair)| {
                let public_key = bs58::encode(keypair.pubkey().to_bytes()).into_string();
                let private_key = bs58::encode(keypair.to_bytes()).into_string();
                serde_json::json!({
                    "account_index": i,
                    "public_key": public_key,
                    "private_key": private_key
                })
            })
            .collect()
    }
}


// We won't use print_derived_account in API, but you can keep it for CLI



// use bip39::{Language, Mnemonic};
// use solana_sdk::{
//     derivation_path::DerivationPath,
//     signature::{keypair_from_seed_and_derivation_path, Keypair, Signer},
// };
// use bs58;
// use std::str::FromStr;

// pub fn derive_account(mnemonic: &Mnemonic, account_index: u32) -> Keypair {
//     // Seed from mnemonic (64 bytes)
//     let seed = mnemonic.to_seed("");

//     // BIP44 path: m/44'/501'/N'/0'
//     // Use DerivationPath::new_bip44(account_index) for Solana default

//     // But new_bip44 only sets purpose and coin type,
//     // so build full path manually:
//     let derivation_path_str = format!("m/44'/501'/{}'/0'", account_index);

//     // DerivationPath ka constructor jo sahi hai wo "from_absolute_path_str"
//     let derivation_path = DerivationPath::from_absolute_path_str(&derivation_path_str)
//         .expect("Invalid derivation path");

//     // Derive keypair from seed and path
//     keypair_from_seed_and_derivation_path(&seed, Some(derivation_path))

//         .expect("Failed to derive keypair")
// }

// pub fn print_derived_account(mnemonic: &Mnemonic, account_index: u32) {
//     let keypair = derive_account(mnemonic, account_index);

//     println!("🔸 Account #{}", account_index);
//     // pubkey() requires Signer trait imported
//     println!("Public Key: {}", bs58::encode(keypair.pubkey().to_bytes()).into_string());

//     let private_bytes = keypair.to_bytes();
//     println!("Private Key: {}", bs58::encode(private_bytes).into_string());
// }
