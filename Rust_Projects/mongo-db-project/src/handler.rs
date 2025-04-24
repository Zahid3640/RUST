// use std::fmt::Error;

// use crate::{db::DB,WebResult};
// use serde::{Serialize,Deserialize};
// use warp::{http::Statuscode,reject,Reply::json,Reply};



// pub struct BookRequest{
//     pub name:String,
//     pub auther:String,
//     pub num_pages:usize,
//     pub tages:Vec<String>
// }

// pub async fn books_list_handler(db:DB)->WebResult<impl Reply>{
//     let books=db.fetch_books().await.map_err(|e|reject::custom(e))?;
//     Ok(json(&books))
// }
// pub async fn create_book_handler(body:BookRequest,db:DB)->WebResult<impl Reply>{
//     db.create_book(&body).await.map_err(|e| reject::custom(e))?;
//     Ok(Statuscode::CREATED)
// }
// pub async fn edit_book_handler(id:String,body:BookRequest,db:DB)->WebResult<impl Reply>{
//     db.edit_book(&id,&body).await.map_err(|e|reject::custom(e))?;
//     Ok(Statuscode::Ok)
// }
// pub async fn delete_book_handler(id:String,db:DB)->WebResult<impl Reply>{
//     db.delete_book(&id).await.map_err(|e| reject::custom(e))?;
//     Ok(Statuscode::Ok)
// }
use crate::{db::DB, WebResult};
use serde::{Deserialize, Serialize};
use warp::{http::StatusCode, reject, reply::json, Reply};

#[derive(Deserialize, Serialize)]
pub struct BookRequest {
    pub name: String,
    pub auther: String,
    pub num_pages: usize,
    pub tags: Vec<String>, // Fixed typo
}

pub async fn books_list_handler(db: DB) -> WebResult<impl Reply> {
    let books = db.fetch_books().await.map_err(|e| reject::custom(e))?;
    Ok(json(&books))
}

pub async fn create_book_handler(body: BookRequest, db: DB) -> WebResult<impl Reply> {
    db.create_book(&body).await.map_err(|e| reject::custom(e))?;
    Ok(warp::reply::with_status("Book Created", StatusCode::CREATED))
}

pub async fn edit_book_handler(id: String, body: BookRequest, db: DB) -> WebResult<impl Reply> {
    db.edit_book(&id, &body).await.map_err(|e| reject::custom(e))?;
    Ok(warp::reply::with_status("Book Updated", StatusCode::OK))
}

pub async fn delete_book_handler(id: String, db: DB) -> WebResult<impl Reply> {
    db.delete_book(&id).await.map_err(|e| reject::custom(e))?;
    Ok(warp::reply::with_status("Book Deleted", StatusCode::OK))
}
