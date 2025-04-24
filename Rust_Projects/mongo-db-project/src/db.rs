// use std::process::id;

// use crate::{error::Error::*,handler::BookRequest,Book,Result};
// use chrono::prelude::*;
// use futures::future::ok;
// use futures::io::Cursor;
// use futures::StreamExt;
// use mongodb::bson::{doc,document::Document,oid::ObjectId,Bson};
// use mongodb::{options::ClientOptions,Client,Collection};
// use warp::filters::host::Authority;
// use warp::filters::query;
// use warp::filters::trace::named;
// const DB_NAME:&str="booky";
// const Coll:&str="books";
// const ID:&str="_id";
// const NAME:&str="name";
// const AUTHOR:&str="author";
// const NUM_PAGES:&str="num_pages";
// const ADDED_AT:&str="added_at";
// const TAGES:&str="tages";
// #[derive(Clone,Debug)]

// pub struct DB{
//     pub client:Client,
// }

// impl DB{
//    pub async fn init()->Result<Self>{
//     let mut client_options=ClientOptions::parse("mongodb://127.0.0.1:27017").await?;
//     client_options.app_name=Some("booky".to_string());

//     ok(Self{
//           client:Client::with_options(client_options)?,
//     })
//    }
//    pub async fn fetch_books(&self)->Result<Vec<Book>>{
//     let mut Cursor=self
//     .get_collection()
//     .find(None,None)
//     .await()
//     .map_err(MongoQueryError)?;
//     let mut result:Vec<Book>=Vec::new();
//     while let Some(doc)=Cursor.next().await() {
//         result.push(self.doc_to_book(&doc?)?)
//     }
//     ok(result)
//    }
//    pub async fn create_book(&self,entry:&BookRequest)->Result<()>{
//     let doc=doc! {
//         NAME:entry.name.clone(),
//         AUTHOR:entry.auther.clone(),
//         ADDED_AT:Utc::now(),
//         NUM_PAGES:entry.num_pages as i32,
//         TAGES:entry.tages.clone()
//     };
//     self.get_collection()
//     .insert_one(doc, None)
//     .await
//     .map_err(MongoQueryError)?;
//         ok(())
//    }
//    pub async fn delete_book(&self,id:&str)->Result<()>{
//     let oid=ObjectId::with_string(&id).map_err(|_| InvalidIDError(id.to_owned()))?;
//     let filter= doc! {
//         "_id":oid,
//     };
//     self.get_collection()
//     .delete_one(filter, None)
//     .await
//     .map_err(MongoQueryError)?;
//        ok(())
//    }
//    pub async fn edit_book(&self,id:&str,query:&BookRequest)->Result<()>{
//     let oid=ObjectId::with_string(&id).map_err(|_| InvalidIDError(id.to_owned()))?;
//     let query= doc! {
//         "_id":oid,
//     };
//     let doc=doc! {
//         NAME:entry.name.clone(),
//         AUTHOR:entry.auther.clone(),
//         ADDED_AT:Utc::now(),
//         NUM_PAGES:entry.num_pages as i32,
//         TAGES:entry.tages.clone()
//     };
//     self.get_collection()
//     .update_one(query,doc, None)
//     .await
//     .map_err(MongoQueryError)?;
//        ok(())
//    }
//    fn get_collection(&self)->Collection{
//     self.client.database(DB_NAME).collection(Coll);
//    }
//    fn doc_to_book(&self,doc:Document)->Result<Book> {
//       let  id=doc.get_object_id(ID)?;
//       let   name=doc.get_str(NAME)?;
//       let author=doc.get_str(AUTHOR)?;
//       let  num_pages=doc.get_str(NUM_PAGES)?;
//       let added_at=doc.get_datetime(ADDED_AT)?;
//       let tages=doc.get_array(TAGES)?;

//       let book=Book{
//         id:id.to_hex(),
//         name:name.to_owned(),
//         auther:doc.to_owned(),
//         num_pages:num_pages as usize,
//         added_at:*added_at,
//         tags:tages
//         .iter()
//         .filter_map(|entry|match entry {
//             Bson::String(v)=>Some(v.to_owned()),
//             _=>None,
//         })
//         .collect(),
//       };
//       ok(book)
//    }
// } 
//use crate::{error::Error::*, handler::BookRequest, Book, Result};
// already defined Error enum...

// use crate::error::{Error, Result};
// use crate::error::Error::{InvalidIDError, MongoQueryError};
// use crate::{handler::BookRequest, Book};
// use chrono::prelude::*;
// use futures::stream::StreamExt;
// use mongodb::bson::{doc, document::Document, oid::ObjectId, Bson};
// use mongodb::{options::ClientOptions, Client, Collection};

// const DB_NAME: &str = "booky";
// const COLL: &str = "books";
// const ID: &str = "_id";
// const NAME: &str = "name";
// const AUTHOR: &str = "author";
// const NUM_PAGES: &str = "num_pages";
// const ADDED_AT: &str = "added_at";
// const TAGS: &str = "tags";

// #[derive(Clone, Debug)]
// pub struct DB {
//     pub client: Client,
// }

// impl DB {
//     pub async fn init() -> Result<Self> {
//         let mut client_options = ClientOptions::parse("mongodb://127.0.0.1:27017").await?;
//         client_options.app_name = Some("booky".to_string());

//         Ok(Self {
//             client: Client::with_options(client_options)?,
//         })
//     }

//     pub async fn fetch_books(&self) -> Result<Vec<Book>> {
//         let mut cursor = self
//             .get_collection()
//             .find(None, None)
//             .await
//             .map_err(|e| MongoQueryError(e.to_string()))?;

//         let mut result: Vec<Book> = Vec::new();
//         while let Some(doc) = cursor.next().await {
//             result.push(self.doc_to_book(&doc?)?);
//         }
//         Ok(result)
//     }

//     pub async fn create_book(&self, entry: &BookRequest) -> Result<()> {
//         let doc = doc! {
//             NAME: entry.name.clone(),
//             AUTHOR: entry.auther.clone(),
//             ADDED_AT: Utc::now(),
//             NUM_PAGES: entry.num_pages as i32,
//             TAGS: entry.tags.clone()
//         };
//         self.get_collection()
//             .insert_one(doc, None)
//             .await
//             .map_err(|e| MongoQueryError(e.to_string()))?;
//         Ok(())
//     }

//     pub async fn delete_book(&self, id: &str) -> Result<()> {
//         let oid = ObjectId::with_string(id).map_err(|_| InvalidIDError(id.to_owned()))?;
//         let filter = doc! { "_id": oid };
//         self.get_collection()
//             .delete_one(filter, None)
//             .await
//             .map_err(|e| MongoQueryError(e.to_string()))?;
//         Ok(())
//     }

//     pub async fn edit_book(&self, id: &str, query: &BookRequest) -> Result<()> {
//         let oid = ObjectId::with_string(id).map_err(|_| InvalidIDError(id.to_owned()))?;
//         let filter = doc! { "_id": oid };
//         let update = doc! {
//             "$set": {
//                 NAME: query.name.clone(),
//                 AUTHOR: query.auther.clone(),
//                 ADDED_AT: Utc::now(),
//                 NUM_PAGES: query.num_pages as i32,
//                 TAGS: query.tags.clone()
//             }
//         };
//         self.get_collection()
//             .update_one(filter, update, None)
//             .await
//             .map_err(|e| MongoQueryError(e.to_string()))?;
//         Ok(())
//     }

//     fn get_collection(&self) -> Collection<Document> {
//         self.client.database(DB_NAME).collection(COLL)
//     }

//     fn doc_to_book(&self, doc: &Document) -> Result<Book> {
//         let id = doc.get_object_id(ID)?;
//         let name = doc.get_str(NAME)?;
//         let author = doc.get_str(AUTHOR)?;
//         let num_pages = doc.get_i32(NUM_PAGES)?;
//         let added_at = doc.get_datetime(ADDED_AT)?;
//         let tags = doc.get_array(TAGS)?;

//         let book = Book {
//             id: id.to_hex(),
//             name: name.to_string(),
//             auther: author.to_string(),
//             num_pages: num_pages as usize,
//             added_at: *added_at,
//             tags: tags
//                 .iter()
//                 .filter_map(|entry| match entry {
//                     Bson::String(v) => Some(v.to_string()),
//                     _ => None,
//                 })
//                 .collect(),
//         };
//         Ok(book)
//     }
// }

use crate::error::{Result};
use crate::error::Error::{InvalidIDError, MongoQueryError};
use crate::{handler::BookRequest, Book};
use futures::stream::StreamExt;
use mongodb::bson::{doc, document::Document, oid::ObjectId, DateTime as MongoDateTime};
use mongodb::{options::ClientOptions, Client, Collection};
use chrono::{DateTime as ChronoDateTime, Utc};
use std::time::SystemTime;

const DB_NAME: &str = "booky";
const COLL: &str = "books";
const ID: &str = "_id";
const NAME: &str = "name";
const AUTHOR: &str = "author";
const NUM_PAGES: &str = "num_pages";
const ADDED_AT: &str = "added_at";
const TAGS: &str = "tags";

#[derive(Clone, Debug)]
pub struct DB {
    pub client: Client,
}

impl DB {
    pub async fn init() -> Result<Self> {
        let mut client_options = ClientOptions::parse("mongodb://127.0.0.1:27017").await?;
        client_options.app_name = Some("booky".to_string());

        Ok(Self {
            client: Client::with_options(client_options)?,
        })
    }

    pub async fn fetch_books(&self) -> Result<Vec<Book>> {
        let mut cursor = self
            .get_collection()
            .find(None, None)
            .await
            .map_err(|e| MongoQueryError(e.to_string()))?;

        let mut result: Vec<Book> = Vec::new();
        while let Some(doc) = cursor.next().await {
            result.push(self.doc_to_book(&doc?)?);
        }
        Ok(result)
    }

    pub async fn create_book(&self, entry: &BookRequest) -> Result<()> {
        let doc = doc! {
            NAME: entry.name.clone(),
            AUTHOR: entry.auther.clone(),
            ADDED_AT: MongoDateTime::from(SystemTime::now()),
            NUM_PAGES: entry.num_pages as i32,
            TAGS: entry.tags.clone()
        };
        self.get_collection()
            .insert_one(doc, None)
            .await
            .map_err(|e| MongoQueryError(e.to_string()))?;
        Ok(())
    }

    pub async fn delete_book(&self, id: &str) -> Result<()> {
        let oid = ObjectId::parse_str(id).map_err(|_| InvalidIDError(id.to_owned()))?;
        let filter = doc! { ID: oid };
        self.get_collection()
            .delete_one(filter, None)
            .await
            .map_err(|e| MongoQueryError(e.to_string()))?;
        Ok(())
    }

    pub async fn edit_book(&self, id: &str, query: &BookRequest) -> Result<()> {
        let oid = ObjectId::parse_str(id).map_err(|_| InvalidIDError(id.to_owned()))?;
        let filter = doc! { ID: oid };
        let update = doc! {
            "$set": {
                NAME: query.name.clone(),
                AUTHOR: query.auther.clone(),
                ADDED_AT: MongoDateTime::from(SystemTime::now()),
                NUM_PAGES: query.num_pages as i32,
                TAGS: query.tags.clone()
            }
        };
        self.get_collection()
            .update_one(filter, update, None)
            .await
            .map_err(|e| MongoQueryError(e.to_string()))?;
        Ok(())
    }

    fn get_collection(&self) -> Collection<Document> {
        self.client.database(DB_NAME).collection(COLL)
    }

    // Function to convert MongoDB BSON DateTime to Chrono DateTime
    fn bson_to_chrono_datetime(bson_datetime: &MongoDateTime) -> ChronoDateTime<Utc> {
        let system_time: SystemTime = bson_datetime.to_system_time();
        let datetime: ChronoDateTime<Utc> = system_time.into();
        datetime
    }

    fn doc_to_book(&self, doc: &Document) -> Result<Book> {
        let id = doc.get_object_id(ID)?.to_hex();
        let name = doc.get_str(NAME)?.to_string();
        let auther = doc.get_str(AUTHOR)?.to_string();

        // Convert BSON DateTime to Chrono DateTime
        let added_at_bson: &MongoDateTime = doc.get_datetime(ADDED_AT)?;
        let added_at = Self::bson_to_chrono_datetime(added_at_bson);

        let num_pages = doc.get_i32(NUM_PAGES)? as usize;

        let tags = doc
            .get_array(TAGS)?
            .iter()
            .filter_map(|b| b.as_str().map(|s| s.to_string()))
            .collect();

        Ok(Book {
            id,
            name,
            auther,
            added_at,
            num_pages,
            tags,
        })
    }
}
