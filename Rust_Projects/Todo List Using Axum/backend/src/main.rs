
mod error;
mod model;

use axum::{
    http::Method,
    extract::{Path, State},
    routing::{delete, get, post,put},
    Json, Router,
};
use tower_http::{cors::{Any,CorsLayer}};
use tokio::net::TcpListener;

use self::error::{Error, Result};
use crate::model::{ModelController, Todo, TodoBody};

async fn create_todo(
    mc: State<ModelController>,
    Json(todo_body): Json<TodoBody>,
) -> Result<Json<Todo>> {
    let todo = mc.create_todo(todo_body).await?;
    Ok(Json(todo))
}

async fn list_todos(mc: State<ModelController>) -> Result<Json<Vec<Todo>>> {
    let todos = mc.list_todos().await?;
    Ok(Json(todos))
}

async fn delete_todo(mc: State<ModelController>, Path(id): Path<u64>) -> Result<Json<Todo>> {
    let todo = mc.delete_todo(id).await?;
    Ok(Json(todo))
}
async fn update_todo(
    mc: State<ModelController>,
    Path(id): Path<u64>,
    Json(todo_body): Json<TodoBody>,
) -> Result<Json<Todo>> {
    let todo = mc.update_todo(id, todo_body).await?;
    Ok(Json(todo))
}
fn route(mc: ModelController) -> Router {
    Router::new()
        .route("/todos", get(list_todos).post(create_todo))
        .route("/todos/{id}", put(update_todo).delete(delete_todo))
        .with_state(mc)
}

#[tokio::main]
async fn main() -> Result<()> {
     let cors=CorsLayer::new()
     .allow_methods([Method::GET,Method::POST])
     .allow_origin(Any);



    let mc = ModelController::new().await?;
    let app = route(mc.clone())
       .layer(CorsLayer::permissive());

    let listener = TcpListener::bind("127.0.0.1:3000").await.unwrap();
    let addr = listener.local_addr().unwrap();
    println!("Server running at {:?}", addr);

    axum::serve(listener, app).await.unwrap();
    Ok(())
}
