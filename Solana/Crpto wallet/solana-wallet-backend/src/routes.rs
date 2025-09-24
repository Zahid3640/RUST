// use actix_multipart::Multipart;
// use actix_web::{post, HttpResponse, Responder};
// use log;
// use anyhow::{anyhow, Context, Result};
// use futures_util::StreamExt as _;
// use mpl_token_metadata::types::{Creator, DataV2};
// use mpl_token_metadata::ID as METADATA_PROGRAM_ID;
// use reqwest::Client;
// use serde::Serialize;
// use serde_json::json;
// use solana_client::nonblocking::rpc_client::RpcClient; // 🔹 async RPC client
// use solana_sdk::program_pack::Pack;
// use solana_sdk::{
//     commitment_config::CommitmentConfig, instruction::Instruction, message::Message, pubkey::Pubkey,
//     signature::{Keypair, Signer}, system_instruction,
// };
// use spl_associated_token_account::{create_associated_token_account, get_associated_token_address};
// use spl_token::instruction as token_instruction;
// use std::io::Write;
// use tempfile::NamedTempFile;

// #[derive(Serialize)]
// pub struct CreateNftResponse {
//     pub mint_address: String,
//     pub metadata_pda: String,
//     pub owner_ata: String,
//     pub tx_signature: String,
//     pub metadata_uri: String,
//     pub image_url: String,
// }

// #[post("/create_nft")]
// pub async fn create_nft(mut payload: Multipart) -> impl Responder {
//     match try_create_nft(&mut payload).await {
//         Ok(resp) => HttpResponse::Ok().json(resp),
//         Err(e) => {
//             log::error!("create_nft error: {e:?}");
//             HttpResponse::BadRequest().body(format!("create_nft failed: {e}"))
//         }
//     }
// }

// async fn try_create_nft(payload: &mut Multipart) -> Result<CreateNftResponse> {
//     // 1) Read multipart safely
//     let mut file = NamedTempFile::new().context("unable to create temp file")?;
//     let mut private_key = String::new();
//     let mut name = String::new();
//     let mut symbol = String::new();
//     let mut description = String::new();
//     let mut external_url = String::new();

//     while let Some(item) = payload.next().await {
//         let mut field = item.map_err(|e| anyhow!("multipart field error: {e}"))?;
//         let cd = field
//             .content_disposition()
//             .ok_or_else(|| anyhow!("missing content disposition"))?;
//         let field_name = cd
//             .get_name()
//             .ok_or_else(|| anyhow!("multipart field missing name"))?
//             .to_owned();

//         if field_name == "file" {
//             while let Some(chunk) = field.next().await {
//                 let data = chunk.map_err(|e| anyhow!("reading file chunk failed: {e}"))?;
//                 file.write_all(&data).context("writing temp file failed")?;
//             }
//         } else {
//             let mut bytes = Vec::new();
//             while let Some(chunk) = field.next().await {
//                 bytes.extend_from_slice(&chunk.map_err(|e| anyhow!("reading text field failed: {e}"))?);
//             }
//             let value = String::from_utf8(bytes).context("field is not valid UTF-8")?;
//             match field_name.as_str() {
//                 "private_key" => private_key = value,
//                 "name" => name = value,
//                 "symbol" => symbol = value,
//                 "description" => description = value,
//                 "external_url" => external_url = value,
//                 _ => {}
//             }
//         }
//     }

//     if private_key.is_empty() || name.is_empty() || symbol.is_empty() || description.is_empty() {
//         return Err(anyhow!("missing required fields"));
//     }

//     // 2) Upload image → Pinata
//     let jwt = match std::env::var("PINATA_JWT") {
//         Ok(v) => v,
//         Err(_) => return Err(anyhow!("PINATA_JWT missing")),
//     };
//     let image_url = upload_file_to_pinata(
//         file.path().to_str().ok_or_else(|| anyhow!("bad temp path"))?,
//         &jwt,
//     )
//     .await
//     .context("pinata file upload failed")?;

//     // 3) metadata.json → Pinata
//     let metadata_json = json!({
//         "name": name,
//         "symbol": symbol,
//         "description": description,
//         "image": image_url,
//         "external_url": external_url,
//         "properties": { "files": [{ "uri": image_url, "type": "image/*" }] }
//     });

//     let metadata_uri =
//         upload_json_to_pinata(&metadata_json, &jwt).await.context("pinata json upload failed")?;

//     // 4) Solana client (async)
//     let rpc_url = std::env::var("SOLANA_RPC").unwrap_or_else(|_| "https://api.devnet.solana.com".to_string());
//     let client = RpcClient::new_with_commitment(rpc_url, CommitmentConfig::confirmed());

//     // 5) Decode signer
//     let sk_bytes = bs58::decode(&private_key)
//         .into_vec()
//         .context("private_key is not base58")?;
//     if sk_bytes.len() != 64 {
//         return Err(anyhow!("private_key must decode to 64 bytes (ed25519 keypair)"));
//     }
//     let payer = Keypair::from_bytes(&sk_bytes).context("invalid keypair bytes")?;
//     let payer_pub = payer.pubkey();

//     // 6) Create mint + ATA + mint 1
//     let mint = Keypair::new();
//     let mint_pub = mint.pubkey();
//     let mint_rent = client
//         .get_minimum_balance_for_rent_exemption(spl_token::state::Mint::LEN)
//         .await
//         .context("rent")?;

//     let mut instructions: Vec<Instruction> = vec![
//         system_instruction::create_account(
//             &payer_pub,
//             &mint_pub,
//             mint_rent,
//             spl_token::state::Mint::LEN as u64,
//             &spl_token::id(),
//         ),
//         token_instruction::initialize_mint(&spl_token::id(), &mint_pub, &payer_pub, Some(&payer_pub), 0)
//             .context("init mint ix")?,
//     ];

//     let owner_ata = get_associated_token_address(&payer_pub, &mint_pub);
//     instructions.push(create_associated_token_account(&payer_pub, &payer_pub, &mint_pub));
//     instructions.push(
//         token_instruction::mint_to(&spl_token::id(), &mint_pub, &owner_ata, &payer_pub, &[], 1)
//             .context("mint_to ix")?,
//     );

//     // 7) Metadata
//     let (metadata_pda, _) = Pubkey::find_program_address(
//         &[b"metadata", METADATA_PROGRAM_ID.as_ref(), mint_pub.as_ref()],
//         &METADATA_PROGRAM_ID,
//     );

//     let creators = Some(vec![Creator {
//         address: payer_pub,
//         verified: true,
//         share: 100,
//     }]);

//     let data = DataV2 {
//         name: name.clone(),
//         symbol: symbol.clone(),
//         uri: metadata_uri.clone(),
//         seller_fee_basis_points: 0,
//         creators,
//         collection: None,
//         uses: None,
//     };

//     let create_md_ix = mpl_token_metadata::instructions::CreateMetadataAccountV3Builder::new()
//         .metadata(metadata_pda)
//         .mint(mint_pub)
//         .mint_authority(payer_pub)
//         .payer(payer_pub)
//         .update_authority(payer_pub, true)
//         .data(data)
//         .is_mutable(true)
//         .instruction();
//     instructions.push(create_md_ix);

//     // 8) Master edition
//     let (master_edition_pda, _) = Pubkey::find_program_address(
//         &[
//             b"metadata",
//             METADATA_PROGRAM_ID.as_ref(),
//             mint_pub.as_ref(),
//             b"edition",
//         ],
//         &METADATA_PROGRAM_ID,
//     );

//     let create_me_ix = mpl_token_metadata::instructions::CreateMasterEditionV3Builder::new()
//         .metadata(metadata_pda)
//         .edition(master_edition_pda)
//         .mint(mint_pub)
//         .mint_authority(payer_pub)
//         .payer(payer_pub)
//         .update_authority(payer_pub)
//         .max_supply(0)
//         .instruction();
//     instructions.push(create_me_ix);

//     // 9) Send tx (async)
//     let recent = client.get_latest_blockhash().await.context("blockhash")?;
//     let message = Message::new(&instructions, Some(&payer_pub));
//     let mut tx = solana_sdk::transaction::Transaction::new_unsigned(message);
//     tx.try_partial_sign(&[&payer, &mint], recent).context("sign")?;
//     let sig = client
//         .send_and_confirm_transaction(&tx)
//         .await
//         .context("send tx")?;

//     Ok(CreateNftResponse {
//         mint_address: mint_pub.to_string(),
//         metadata_pda: metadata_pda.to_string(),
//         owner_ata: owner_ata.to_string(),
//         tx_signature: sig.to_string(),
//         metadata_uri,
//         image_url,
//     })
// }

// /// Pinata file upload
// async fn upload_file_to_pinata(file_path: &str, jwt: &str) -> Result<String> {
//     let client = Client::new();
//     use reqwest::multipart::{Form, Part};
//     use std::fs::File;
//     use std::io::Read;

//     let mut buf = Vec::new();
//     File::open(file_path)
//         .with_context(|| format!("open file {file_path}"))?
//         .read_to_end(&mut buf)?;
//     let part = Part::bytes(buf).file_name("nft").mime_str("application/octet-stream")?;
//     let form = Form::new().part("file", part);

//     let resp = client
//         .post("https://api.pinata.cloud/pinning/pinFileToIPFS")
//         .header("Authorization", format!("Bearer {jwt}"))
//         .multipart(form)
//         .send()
//         .await
//         .context("pinFileToIPFS request failed")?;

//     let j: serde_json::Value = resp.json().await.context("pinFileToIPFS json")?;
//     j.get("IpfsHash")
//         .and_then(|v| v.as_str())
//         .map(|cid| format!("https://gateway.pinata.cloud/ipfs/{cid}"))
//         .ok_or_else(|| anyhow!("pinFileToIPFS missing IpfsHash: {j}"))
// }

// /// Pinata JSON upload
// async fn upload_json_to_pinata(json_val: &serde_json::Value, jwt: &str) -> Result<String> {
//     let client = Client::new();
//     let resp = client
//         .post("https://api.pinata.cloud/pinning/pinJSONToIPFS")
//         .header("Authorization", format!("Bearer {jwt}"))
//         .json(json_val)
//         .send()
//         .await
//         .context("pinJSONToIPFS request failed")?;

//     let j: serde_json::Value = resp.json().await.context("pinJSONToIPFS json")?;
//     j.get("IpfsHash")
//         .and_then(|v| v.as_str())
//         .map(|cid| format!("https://gateway.pinata.cloud/ipfs/{cid}"))
//         .ok_or_else(|| anyhow!("pinJSONToIPFS missing IpfsHash: {j}"))
// }
// src/main.rs

use actix_multipart::Multipart;
use actix_web::{post, web, App, HttpResponse, HttpServer, Responder};
use anyhow::{anyhow, Context, Result};
use borsh::BorshDeserialize;
use futures_util::StreamExt as _;
use log;
use mpl_token_metadata::accounts::Metadata as MdAccount;
use mpl_token_metadata::types::{Creator, DataV2};
use mpl_token_metadata::ID as METADATA_PROGRAM_ID;
use reqwest::Client;
use serde::{Deserialize, Serialize};
use serde_json::json;
use solana_account_decoder::{UiAccountData};
use solana_client::nonblocking::rpc_client::RpcClient;
//use solana_client::rpc_config::RpcAccountInfoConfig;
use solana_client::rpc_request::TokenAccountsFilter;
use solana_sdk::program_pack::Pack;
use solana_sdk::{
    commitment_config::CommitmentConfig, instruction::Instruction, message::Message, pubkey::Pubkey,
    signature::{Keypair, Signer}, system_instruction,
};
use spl_associated_token_account::{create_associated_token_account, get_associated_token_address};
use spl_token::instruction as token_instruction;
use spl_token::state::{Account as SplTokenAccount, Mint as SplMint};
use std::io::Write;
use tempfile::NamedTempFile;
 use std::str::FromStr;
// use serde_json::Value as Json;
// ------------------------- Types -------------------------

#[derive(Serialize)]
pub struct CreateNftResponse {
    pub mint_address: String,
    pub metadata_pda: String,
    pub owner_ata: String,
    pub tx_signature: String,
    pub metadata_uri: String,
    pub image_url: String,
}

#[derive(Deserialize)]
pub struct GetNftsRequest {
    pub public_key: String, // base58 pubkey
}

#[derive(Serialize)]
pub struct OwnedNft {
    pub mint: String,
    pub owner_ata: String,
    pub metadata_uri: String,
    pub name: String,
    pub symbol: String,
    pub image: String,
}

// ------------------------- Routes -------------------------

#[post("/create_nft")]
pub async fn create_nft(mut payload: Multipart) -> impl Responder {
    match try_create_nft(&mut payload).await {
        Ok(resp) => HttpResponse::Ok().json(resp),
        Err(e) => {
            log::error!("create_nft error: {e:?}");
            HttpResponse::BadRequest().body(format!("create_nft failed: {e}"))
        }
    }
}

#[post("/get_nfts")]
pub async fn get_nfts(req: web::Json<GetNftsRequest>) -> impl Responder {
    match try_get_nfts(req.into_inner()).await {
        Ok(list) => HttpResponse::Ok().json(list),
        Err(e) => {
            log::error!("get_nfts error: {e:?}");
            HttpResponse::BadRequest().body(format!("get_nfts failed: {e}"))
        }
    }
}

// ------------------------- Handlers -------------------------

async fn try_create_nft(payload: &mut Multipart) -> Result<CreateNftResponse> {
    // 1) Read multipart
    let mut file = NamedTempFile::new().context("unable to create temp file")?;
    let mut private_key = String::new();
    let mut name = String::new();
    let mut symbol = String::new();
    let mut description = String::new();
    let mut external_url = String::new();

    while let Some(item) = payload.next().await {
        let mut field = item.map_err(|e| anyhow!("multipart field error: {e}"))?;
        let cd = field
            .content_disposition()
            .ok_or_else(|| anyhow!("missing content disposition"))?;
        let field_name = cd
            .get_name()
            .ok_or_else(|| anyhow!("multipart field missing name"))?
            .to_owned();

        if field_name == "file" {
            while let Some(chunk) = field.next().await {
                let data = chunk.map_err(|e| anyhow!("reading file chunk failed: {e}"))?;
                file.write_all(&data).context("writing temp file failed")?;
            }
        } else {
            let mut bytes = Vec::new();
            while let Some(chunk) = field.next().await {
                bytes.extend_from_slice(
                    &chunk.map_err(|e| anyhow!("reading text field failed: {e}"))?,
                );
            }
            let value = String::from_utf8(bytes).context("field is not valid UTF-8")?;
            match field_name.as_str() {
                "private_key" => private_key = value,
                "name" => name = value,
                "symbol" => symbol = value,
                "description" => description = value,
                "external_url" => external_url = value,
                _ => {}
            }
        }
    }

    if private_key.is_empty() || name.is_empty() || symbol.is_empty() || description.is_empty() {
        return Err(anyhow!("missing required fields"));
    }

    // 2) Pin image to Pinata
    let jwt = std::env::var("PINATA_JWT").context("PINATA_JWT missing")?;
    let image_url = upload_file_to_pinata(
        file.path().to_str().ok_or_else(|| anyhow!("bad temp path"))?,
        &jwt,
    )
    .await
    .context("pinata file upload failed")?;

    // 3) Pin metadata.json to Pinata
    let metadata_json = json!({
        "name": name,
        "symbol": symbol,
        "description": description,
        "image": image_url,
        "external_url": external_url,
        "properties": { "files": [{ "uri": image_url, "type": "image/*" }] }
    });
    let metadata_uri =
        upload_json_to_pinata(&metadata_json, &jwt).await.context("pinata json upload failed")?;

    // 4) Solana client
    let rpc_url = std::env::var("SOLANA_RPC")
        .unwrap_or_else(|_| "https://api.devnet.solana.com".to_string());
    let client = RpcClient::new_with_commitment(rpc_url, CommitmentConfig::confirmed());

    // 5) Decode signer
    let sk_bytes = bs58::decode(&private_key)
        .into_vec()
        .context("private_key is not base58")?;
    if sk_bytes.len() != 64 {
        return Err(anyhow!("private_key must decode to 64 bytes (ed25519 keypair)"));
    }
    let payer = Keypair::from_bytes(&sk_bytes).context("invalid keypair bytes")?;
    let payer_pub = payer.pubkey();

    // 6) Create mint + ATA + mint 1
    let mint = Keypair::new();
    let mint_pub = mint.pubkey();
    let mint_rent = client
        .get_minimum_balance_for_rent_exemption(spl_token::state::Mint::LEN)
        .await
        .context("rent")?;

    let mut instructions: Vec<Instruction> = vec![
        system_instruction::create_account(
            &payer_pub,
            &mint_pub,
            mint_rent,
            spl_token::state::Mint::LEN as u64,
            &spl_token::id(),
        ),
        token_instruction::initialize_mint(
            &spl_token::id(),
            &mint_pub,
            &payer_pub,
            Some(&payer_pub),
            0,
        )
        .context("init mint ix")?,
    ];

    let owner_ata = get_associated_token_address(&payer_pub, &mint_pub);
    instructions.push(create_associated_token_account(
        &payer_pub,
        &payer_pub,
        &mint_pub,
    ));
    instructions.push(
        token_instruction::mint_to(
            &spl_token::id(),
            &mint_pub,
            &owner_ata,
            &payer_pub,
            &[],
            1,
        )
        .context("mint_to ix")?,
    );

    // 7) Metadata PDA
    let (metadata_pda, _) = Pubkey::find_program_address(
        &[b"metadata", METADATA_PROGRAM_ID.as_ref(), mint_pub.as_ref()],
        &METADATA_PROGRAM_ID,
    );

    let creators = Some(vec![Creator {
        address: payer_pub,
        verified: true,
        share: 100,
    }]);

    let data = DataV2 {
        name: name.clone(),
        symbol: symbol.clone(),
        uri: metadata_uri.clone(),
        seller_fee_basis_points: 0,
        creators,
        collection: None,
        uses: None,
    };

    let create_md_ix = mpl_token_metadata::instructions::CreateMetadataAccountV3Builder::new()
        .metadata(metadata_pda)
        .mint(mint_pub)
        .mint_authority(payer_pub)
        .payer(payer_pub)
        .update_authority(payer_pub, true)
        .data(data)
        .is_mutable(true)
        .instruction();
    instructions.push(create_md_ix);

    // 8) Master edition
    let (master_edition_pda, _) = Pubkey::find_program_address(
        &[
            b"metadata",
            METADATA_PROGRAM_ID.as_ref(),
            mint_pub.as_ref(),
            b"edition",
        ],
        &METADATA_PROGRAM_ID,
    );
    let create_me_ix = mpl_token_metadata::instructions::CreateMasterEditionV3Builder::new()
        .metadata(metadata_pda)
        .edition(master_edition_pda)
        .mint(mint_pub)
        .mint_authority(payer_pub)
        .payer(payer_pub)
        .update_authority(payer_pub)
        .max_supply(0)
        .instruction();
    instructions.push(create_me_ix);

    // 9) Send tx
    let recent = client.get_latest_blockhash().await.context("blockhash")?;
    let message = Message::new(&instructions, Some(&payer_pub));
    let mut tx = solana_sdk::transaction::Transaction::new_unsigned(message);
    tx.try_partial_sign(&[&payer, &mint], recent).context("sign")?;
    let sig = client
        .send_and_confirm_transaction(&tx)
        .await
        .context("send tx")?;

    Ok(CreateNftResponse {
        mint_address: mint_pub.to_string(),
        metadata_pda: metadata_pda.to_string(),
        owner_ata: owner_ata.to_string(),
        tx_signature: sig.to_string(),
        metadata_uri,
        image_url,
    })
}



async fn try_get_nfts(req: GetNftsRequest) -> anyhow::Result<Vec<OwnedNft>> {
    let owner_pub: Pubkey = req.public_key.parse()
        .map_err(|_| anyhow::anyhow!("invalid public_key"))?;

    let rpc_url = std::env::var("SOLANA_RPC")
        .unwrap_or_else(|_| "https://api.devnet.solana.com".to_string());
    let client = RpcClient::new_with_commitment(rpc_url, CommitmentConfig::confirmed());

    let tas = client
        .get_token_accounts_by_owner(&owner_pub, TokenAccountsFilter::ProgramId(spl_token::id()))
        .await?;

    let http = reqwest::Client::new();
    let mut out: Vec<OwnedNft> = Vec::new();

    for ka in tas {
        let ata_pub_str = ka.pubkey.clone();
        let ata_pub = match Pubkey::from_str(&ata_pub_str) {
            Ok(p) => p,
            Err(_) => continue,
        };

        let ata_acc = match client.get_account(&ata_pub).await {
            Ok(a) => a,
            Err(_) => continue,
        };
        let ta = match SplTokenAccount::unpack_from_slice(&ata_acc.data) {
            Ok(x) => x,
            Err(_) => continue,
        };

        if ta.amount != 1 { continue; }

        let mint_acc = match client.get_account(&ta.mint).await { Ok(a) => a, Err(_) => continue };
        let mint_state = match SplMint::unpack_from_slice(&mint_acc.data) { Ok(m) => m, Err(_) => continue };
        if mint_state.decimals != 0 || mint_state.supply != 1 { continue; }

        let (metadata_pda, _) = Pubkey::find_program_address(
            &[b"metadata", METADATA_PROGRAM_ID.as_ref(), ta.mint.as_ref()],
            &METADATA_PROGRAM_ID,
        );

        let (mut uri, mut name, mut symbol) = (String::new(), String::new(), String::new());
        if let Ok(md_acc) = client.get_account(&metadata_pda).await {
            if let Ok(md) = MdAccount::safe_deserialize(&mut md_acc.data.as_slice()) {
                uri = md.uri.trim_matches(char::from(0)).to_string();
                name = md.name.trim_matches(char::from(0)).to_string();
                symbol = md.symbol.trim_matches(char::from(0)).to_string();
            }
        }

        let mut image = String::new();
        if !uri.is_empty() {
            if let Ok(resp) = http.get(&uri).send().await {
                if let Ok(j) = resp.json::<serde_json::Value>().await {
                    if let Some(img) = j.get("image").and_then(|v| v.as_str()) {
                        image = img.to_string();
                    }
                }
            }
        }

        out.push(OwnedNft {
            mint: ta.mint.to_string(),
            owner_ata: ata_pub_str,
            metadata_uri: uri,
            name,
            symbol,
            image,
        });
    }

    Ok(out)
}



// ------------------------- Pinata helpers -------------------------

async fn upload_file_to_pinata(file_path: &str, jwt: &str) -> Result<String> {
    let client = Client::new();
    use reqwest::multipart::{Form, Part};
    use std::fs::File;
    use std::io::Read;

    let mut buf = Vec::new();
    File::open(file_path)
        .with_context(|| format!("open file {file_path}"))?
        .read_to_end(&mut buf)?;
    let part = Part::bytes(buf)
        .file_name("nft")
        .mime_str("application/octet-stream")?;
    let form = Form::new().part("file", part);

    let resp = client
        .post("https://api.pinata.cloud/pinning/pinFileToIPFS")
        .header("Authorization", format!("Bearer {jwt}"))
        .multipart(form)
        .send()
        .await
        .context("pinFileToIPFS request failed")?;

    let j: serde_json::Value = resp.json().await.context("pinFileToIPFS json")?;
    j.get("IpfsHash")
        .and_then(|v| v.as_str())
        .map(|cid| format!("https://gateway.pinata.cloud/ipfs/{cid}"))
        .ok_or_else(|| anyhow!("pinFileToIPFS missing IpfsHash: {j}"))
}

async fn upload_json_to_pinata(json_val: &serde_json::Value, jwt: &str) -> Result<String> {
    let client = Client::new();
    let resp = client
        .post("https://api.pinata.cloud/pinning/pinJSONToIPFS")
        .header("Authorization", format!("Bearer {jwt}"))
        .json(json_val)
        .send()
        .await
        .context("pinJSONToIPFS request failed")?;

    let j: serde_json::Value = resp.json().await.context("pinJSONToIPFS json")?;
    j.get("IpfsHash")
        .and_then(|v| v.as_str())
        .map(|cid| format!("https://gateway.pinata.cloud/ipfs/{cid}"))
        .ok_or_else(|| anyhow!("pinJSONToIPFS missing IpfsHash: {j}"))
}


