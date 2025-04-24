// use chrono::prelude::*;
// use serde::{Serialize,Dserialize};
// use db::DB;
// use core::error;
// use std::convert::Infallible;

// use warp::{Filter,Rejection};
// type Result<T>=std::result::Result<T,error::Error>;
// type WebResult<T>=std::result::Result<T,Rejection>;

// mod db;
// mod error;
// mod handler;

// #[derive(Serialize,Deserialize)]
// pub struct Book{
//     pub id:String,
//     pub name:String,
//     pub auther:String,
//     pub num_pages:usize,
//     pub added_at:DateTime<utc>,
//     pub tags:Vec<String>
// }
// #[tokio::main]
// async fn main()->Result<()>{
//    let db = DB::init().await?;
//    let book=warp::path("book");
//    let book_routes=book
//    .and(warp::post())
//    .and(warp::body::json())
//    .and(with_db(db.clone()))
//    .and_then(handler::create_book_handler)
//    .or(book
//         .and(warp::put())
//         .and(warp::path::param())
//         .and(warp::body::json())
//         .and(with_db(db.clone()))
//         .and_then(handler::edit_book_handler))
//         .or(book
//             .and(warp::delete())
//             .and(warp::path::param())
//             .and(with_db(db.clone()))
//             .and_then(handler::delete_book_handler))
//         .or(book
//             .and(warp::get())
//             .and(with_db(db.clone()))
//             .and_then(handler::books_list_handler));
//     let routes=book_routes.recover(error::handle_rejection);
//     println!("Started on port 8080");
//     warp::serve(routes).run(([0, 0, 0, 0], 8080)).await;
//     Ok(())
// }

// fn with_db(db:DB)->impl Filter <Extract = (DB,),Error = Infallible> + clone{
//     warp::any().map(move || db.clone())
// }
use chrono::prelude::*;
use serde::{Serialize, Deserialize}; // Fixed typo: Dserialize ➜ Deserialize
use db::DB;
use std::convert::Infallible;

use warp::{Filter, Rejection};

type Result<T> = std::result::Result<T, error::Error>;
type WebResult<T> = std::result::Result<T, Rejection>;

mod db;
mod error;
mod handler;

#[derive(Serialize, Deserialize)]
pub struct Book {
    pub id: String,
    pub name: String,
    pub auther: String,
    pub num_pages: usize,
    pub added_at: DateTime<Utc>, // Fixed typo: utc ➜ Utc
    pub tags: Vec<String>,
}

#[tokio::main]
async fn main() -> Result<()> {
    let db = DB::init().await?;

    let book = warp::path("book");
    
    let book_routes = book
    .and(warp::post())
    .and(warp::body::json())
    .and(with_db(db.clone()))
    .and_then(|body, db| async move {
        handler::create_book_handler(body, db).await
    })
    .or(book
        .and(warp::put())
        .and(warp::path::param())
        .and(warp::body::json())
        .and(with_db(db.clone()))
        .and_then(|id, body, db| async move {
            handler::edit_book_handler(id, body, db).await
        }))
    .or(book
        .and(warp::delete())
        .and(warp::path::param())
        .and(with_db(db.clone()))
        .and_then(|id, db| async move {
            handler::delete_book_handler(id, db).await
        }))
    .or(book
        .and(warp::get())
        .and(with_db(db.clone()))
        .and_then(|db| async move {
            handler::books_list_handler(db).await
        }));

    
    let routes = book_routes.recover(error::handle_rejection);
    
    println!("Started on port 8080");
    warp::serve(routes).run(([0, 0, 0, 0], 8080)).await;

    Ok(())
}

// Fixed: `clone` ➜ `Clone` (trait, so must be capitalized)
fn with_db(db: DB) -> impl Filter<Extract = (DB,), Error = Infallible> + Clone {
    warp::any().map(move || db.clone())
}
