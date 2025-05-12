// use std::io;

// fn main() {
//     println!("Simple Calculator");
//     println!("...................");

//     println!("Enter First number:");
//     let mut num1 = String::new();
//     io::stdin().read_line(&mut num1).expect("Failed to read input");
//     let num1: f64 = num1.trim().parse().expect("Invalid number");

//     println!("Enter Second number:");
//     let mut num2 = String::new();
//     io::stdin().read_line(&mut num2).expect("Failed to read input");
//     let num2: f64 = num2.trim().parse().expect("Invalid number");

//     println!("Choose the operation (+, -, *, /):");
//     let mut operation = String::new();
//     io::stdin().read_line(&mut operation).expect("Failed to read operation");
//     let operation = operation.trim();

//     let result = match operation {
//         "+" => num1 + num2,
//         "-" => num1 - num2,
//         "*" => num1 * num2,
//         "/" => {
//             if num2 == 0.0 {
//                 println!("Division by zero is not allowed");
//                 return;
//             }
//             num1 / num2
//         },
//         _ => {
//             println!("Invalid operator");
//             return;
//         }
//     };

//     println!("Result: {}", result);
// }
use actix_files::Files;
use actix_web::{web, App, HttpServer, Responder, HttpResponse};
use actix_cors::Cors;
use serde::Deserialize;

#[derive(Deserialize)]
struct CalculatorInput {
    num1: f64,
    num2: f64,
    operation: String,
}

async fn calculate(data: web::Json<CalculatorInput>) -> impl Responder {
    let num1 = data.num1;
    let num2 = data.num2;
    let op = data.operation.trim();

    let result = match op {
        "+" => Some(num1 + num2),
        "-" => Some(num1 - num2),
        "*" => Some(num1 * num2),
        "/" => {
            if num2 == 0.0 {
                return HttpResponse::BadRequest().body("Division by zero is not allowed.");
            }
            Some(num1 / num2)
        }
        _ => return HttpResponse::BadRequest().body("Invalid operator."),
    };

    HttpResponse::Ok().body(format!("Result: {}", result.unwrap()))
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    println!("Server running at http://localhost:8080");

    HttpServer::new(|| {
        App::new()
            .wrap(Cors::permissive())
            .route("/calculate", web::post().to(calculate))
            .service(Files::new("/", "./static").index_file("index.html")) // Serve index.html
    })
    .bind(("127.0.0.1", 8080))?
    .run()
    .await
}
