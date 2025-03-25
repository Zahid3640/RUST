use actix_web::{HttpServer, get, App, web::Path, Responder};
use rhai::Engine;
use std::fs;
use std::path::PathBuf;

#[get("/multiply/{num1}/{num2}")]
async fn multiply(path: Path<(i64, i64)>) -> impl Responder {
    let (num1, num2) = path.into_inner();
    let mut engine = Engine::new();

    // ✅ Functions ke taur par register karna zaroori hai
    engine.register_fn("num1", move || num1);
    engine.register_fn("num2", move || num2);

    let path = PathBuf::from("src/multiply.rhai");

    // ✅ Ensure File Exists
    if !path.exists() {
        return format!("Error: File {:?} not found!", path);
    }

    match engine.eval_file::<i64>(path) {
        Ok(result) => format!("{}", result),
        Err(e) => format!("Error: {:?}", e),
    }
}

#[get("/add/{num1}/{num2}")]
async fn add(path: Path<(i64, i64)>) -> impl Responder {
    let (num1, num2) = path.into_inner();
    let mut engine = Engine::new();

    // ✅ Functions ke taur par register karna zaroori hai
    engine.register_fn("num1", move || num1);
    engine.register_fn("num2", move || num2);

    let path = PathBuf::from("src/add.rhai");

    // ✅ Ensure File Exists
    if !path.exists() {
        return format!("Error: File {:?} not found!", path);
    }

    match engine.eval_file::<i64>(path) {
        Ok(result) => format!("{}", result),
        Err(e) => format!("Error: {:?}", e),
    }
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    HttpServer::new(|| {
        App::new()
            .service(multiply)
            .service(add)
    })
    .bind(("127.0.0.1", 8080))?
    .run()
    .await
}
