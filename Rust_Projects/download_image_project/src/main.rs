use error_chain::error_chain;
use std::fs::File;
use std::io::Write;
use tempfile::Builder;

error_chain! {
    foreign_links {
        Io(std::io::Error);
        HttpRequest(reqwest::Error);
    }
}

#[tokio::main]
async fn main() -> Result<()> {
    let tmp_dir = Builder::new().prefix("example").tempdir()?;  
    let target = "https://www.rust-lang.org/logos/rust-logo-512x512.png";
    
    let response = reqwest::get(target).await?;
    
    // Extract file name from URL
    let fname = response
        .url()
        .path_segments()
        .and_then(|segments| segments.last())
        .and_then(|name| if name.is_empty() { None } else { Some(name) })
        .unwrap_or("tmp.bin");

    let file_path = tmp_dir.path().join(fname);
    println!("Downloading file: '{}'", fname);
    println!("Saving to: {:?}", file_path);

    // Create file
    let mut file = File::create(&file_path)?;
    
    // Read binary content from response
    let content = response.bytes().await?;
    
    // Write binary data to file
    file.write_all(&content)?;
    
    println!("Download complete!");
    Ok(())
}
