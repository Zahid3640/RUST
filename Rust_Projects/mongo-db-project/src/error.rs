use std::convert::Infallible;
use warp::{http::StatusCode, reject::Reject, Rejection, Reply};
use serde::Serialize;
use mongodb::bson::document::ValueAccessError;
use mongodb::error::Error as MongoError;

#[derive(Debug)]
pub enum Error {
    InvalidIDError(String),
    MongoQueryError(String),
}

impl std::fmt::Display for Error {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            Error::InvalidIDError(id) => write!(f, "Invalid ID: {}", id),
            Error::MongoQueryError(msg) => write!(f, "Database error: {}", msg),
        }
    }
}

impl std::error::Error for Error {}

/// ✅ Convert MongoDB internal error
impl From<MongoError> for Error {
    fn from(err: MongoError) -> Self {
        Error::MongoQueryError(err.to_string())
    }
}

/// ✅ Convert BSON document access error
impl From<ValueAccessError> for Error {
    fn from(err: ValueAccessError) -> Self {
        Error::MongoQueryError(err.to_string())
    }
}

/// ✅ Convert custom error to Warp Rejection
impl Reject for Error {}

/// ✅ This is used to wrap results in your main.rs or handler.rs
pub type Result<T> = std::result::Result<T, Error>;

/// ✅ This handles any rejections from filters
pub async fn handle_rejection(err: Rejection) -> std::result::Result<impl Reply, Infallible> {
    if let Some(error) = err.find::<Error>() {
        let (code, message) = match error {
            Error::InvalidIDError(_) => (StatusCode::BAD_REQUEST, error.to_string()),
            Error::MongoQueryError(_) => (StatusCode::INTERNAL_SERVER_ERROR, error.to_string()),
        };

        let json = warp::reply::json(&ErrorResponse {
            code: code.as_u16(),
            message,
        });

        Ok(warp::reply::with_status(json, code))
    } else {
        // fallback for unknown errors
        let json = warp::reply::json(&ErrorResponse {
            code: 500,
            message: "Internal server error".to_string(),
        });
        Ok(warp::reply::with_status(json, StatusCode::INTERNAL_SERVER_ERROR))
    }
}

#[derive(Serialize)]
struct ErrorResponse {
    code: u16,
    message: String,
}
