
use std::sync::{Arc, Mutex};
use serde::{Serialize, Deserialize};
use crate::error::{Error, Result};

#[derive(Clone, Debug, Serialize)]
pub struct Todo {
    pub id: u64,
    pub title: String,
}

#[derive(Deserialize)]
pub struct TodoBody {
    pub title: String,
}

#[derive(Clone)]
pub struct ModelController {
    pub todo_store: Arc<Mutex<Vec<Option<Todo>>>>,
}

impl ModelController {
    pub async fn new() -> Result<Self>{
        Ok(
            Self {
                todo_store: Arc::new(
                    Mutex::new(
                         vec![
                    Some(Todo { id: 0, title: String::from("Write Rust code")}),
                    Some(Todo { id: 1, title: String::from("Write  tsss Rust code")}),
                ]))
            }
        )
    }
}
impl ModelController {
    pub async fn create_todo(&self, todo_body: TodoBody) -> Result<Todo> {
        let mut store = self.todo_store.lock().unwrap();
        let id = store.len() as u64;
        let todo = Todo {
            id:id,
            title: todo_body.title,
        };
        store.push(Some(todo.clone()));
        Ok(todo)
    }

    pub async  fn list_todos(&self) -> Result<Vec<Todo>> {
        let store = self.todo_store.lock().unwrap();
        let todos = store.iter().filter_map(|todo| todo.clone()).collect();
        Ok(todos)
    }
    pub async fn delete_todo(&self, id: u64) -> Result<Todo> {
        let mut store = self.todo_store.lock().unwrap();
        if (id as usize) < store.len() {
            if let Some(todo) = store.get_mut(id as usize).and_then(|t| t.take()) {
                return Ok(todo);
            }
        }
        Err(Error::InternalServerError) // 🔥 Fix: Handle invalid IDs properly
    }
    pub async fn update_todo(&self, id: u64, todo_body: TodoBody) -> Result<Todo> {
        let mut store = self.todo_store.lock().unwrap();
        if (id as usize) < store.len() {
            if let Some(todo) = store.get_mut(id as usize) {
                *todo = Some(Todo {
                    id,
                    title: todo_body.title,
                });
                return Ok(todo.clone().unwrap());
            }
        }
        Err(Error::InternalServerError)
    }
    }
