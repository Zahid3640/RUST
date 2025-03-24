use serde::Deserialize;
use reqwest::{Error, header::USER_AGENT};

#[derive(Deserialize, Debug)]
struct User {
    login: String,
    id: u32,  // Changed to u32 to handle larger IDs
}

#[tokio::main]
async fn main() -> Result<(), Error> {
    let owner = "rust-lang-nursery";
    let repo = "rust-cookbook";

    let request_url = format!("https://api.github.com/repos/{}/{}/stargazers", owner, repo);
    println!("Requesting: {}", request_url);

    let client = reqwest::Client::new();
    let response = client
        .get(&request_url)
        .header(USER_AGENT, "Rust Demo API")
        .send()
        .await?;

    if response.status().is_success() {
        let users: Vec<User> = response.json().await?;
        if users.is_empty() {
            println!("No stargazers found.");
        } else {
            println!("Stargazers: {:?}", users);
        }
    } else {
        println!("Failed to fetch data. HTTP Status: {}", response.status());
    }

    Ok(())
}
