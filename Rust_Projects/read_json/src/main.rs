use serde::{Serialize, Deserialize};
use serde_json;

#[derive(Serialize, Deserialize, Debug)]
struct Paragraph {
    name: String,
}

#[derive(Serialize, Deserialize, Debug)]
struct Article {
    article: String,
    author: String,
    paragraph: Vec<Paragraph>,
}

#[derive(Serialize, Deserialize, Debug)]
struct Articles {
    articles: Vec<Article>,
}

fn main() {
    let json = r#"
    {
        "articles": [
            {
                "article": "The Rust Programming Language",
                "author": "Zahid",
                "paragraph": [
                    { "name": "Rust is a systems programming language." },
                    { "name": "It focuses on safety, speed, and concurrency." },
                    { "name": "It prevents memory-related bugs." }
                ]
            },
            {
                "article": "Introduction to Solana",
                "author": "Ali",
                "paragraph": [
                    { "name": "Solana is a high-performance blockchain." },
                    { "name": "It supports fast and low-cost transactions." },
                    { "name": "Rust is used to develop smart contracts on Solana." }
                ]
            }
        ]
    }"#;

    match read_json(json) {
        Ok(parsed) => {
            println!("📚 Articles:");
            for (i, article) in parsed.articles.iter().enumerate() {
                println!("📰 Article {}: {}", i + 1, article.article);
                println!("✍ Author: {}", article.author);
                println!("📜 Paragraphs:");
                for (j, p) in article.paragraph.iter().enumerate() {
                    println!("   {}. {}", j + 1, p.name);
                }
                println!("---------------------------------\n");
            }
        }
        Err(e) => eprintln!("❌ Error parsing JSON: {}", e),
    }
}

fn read_json(raw_json: &str) -> Result<Articles, serde_json::Error> {
    serde_json::from_str(raw_json)
}
