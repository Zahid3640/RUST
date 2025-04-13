use std::collections::HashMap;
use firebase_rs::*;
use serde::{Serialize, Deserialize};

#[derive(Serialize, Deserialize, Debug)]
struct User {
    name: String,
    age: u8,
    email: String,
}

#[derive(Serialize, Deserialize, Debug)]
struct Response {
    name: String,
}

#[tokio::main]
async fn main() {
    let user = User {
        name: "ZAHID NAWAZ".to_string(),
        age: 23,
        email: "zahidnawazpahoor36@gmail.com".to_string(),
    };

    let firebase = Firebase::new("https://rust-crud-4687c-default-rtdb.firebaseio.com/").unwrap();

    let response = set_user(&firebase, &user).await;
    println!("Saved user with ID: {:?}", response.name);

    let user_data = get_user(&firebase, &response.name).await;
    println!("Fetched single user: {:?}", user_data);

    let all_users = get_users(&firebase).await;
    println!("All users: {:?}", all_users);

    let mut updated_user = user_data;
    updated_user.email = "updated.mail@gmail.com".to_string();
    let updated = update_user(&firebase, &response.name, &updated_user).await;
    println!("Updated user: {:?}", updated);

    delete_user(&firebase, &response.name).await;
    println!("Deleted user");
}

async fn set_user(firebase_client: &Firebase, user: &User) -> Response {
    let firebase = firebase_client.at("users");
    let result = firebase.set::<User>(&user).await;
    match result {
        Ok(res) => string_to_response(&res.data),
        Err(err) => {
            eprintln!("Error setting user: {:?}", err);
            std::process::exit(1);
        }
    }
}

async fn get_users(firebase_client: &Firebase) -> HashMap<String, User> {
    let firebase = firebase_client.at("users");
    let result = firebase.get::<HashMap<String, User>>().await;
    match result {
        Ok(data) => data,
        Err(err) => {
            eprintln!("Error getting users: {:?}", err);
            HashMap::new()
        }
    }
}

async fn get_user(firebase_client: &Firebase, id: &String) -> User {
    let firebase = firebase_client.at("users").at(&id);
    let result = firebase.get::<User>().await;
    match result {
        Ok(user) => user,
        Err(err) => {
            eprintln!("Error getting user {}: {:?}", id, err);
            std::process::exit(1);
        }
    }
}

async fn update_user(firebase_client: &Firebase, id: &String, user: &User) -> User {
    let firebase = firebase_client.at("users").at(&id);
    let result = firebase.update::<User>(&user).await;
    match result {
        Ok(res) => string_to_user(&res.data),
        Err(err) => {
            eprintln!("Error updating user {}: {:?}", id, err);
            std::process::exit(1);
        }
    }
}

async fn delete_user(firebase_client: &Firebase, id: &String) {
    let firebase = firebase_client.at("users").at(&id);
    let result = firebase.delete().await;
    if let Err(err) = result {
        eprintln!("Error deleting user {}: {:?}", id, err);
    }
}

fn string_to_response(s: &str) -> Response {
    serde_json::from_str(s).unwrap_or_else(|err| {
        eprintln!("Failed to parse response: {:?}", err);
        std::process::exit(1);
    })
}

fn string_to_user(s: &str) -> User {
    serde_json::from_str(s).unwrap_or_else(|err| {
        eprintln!("Failed to parse user: {:?}", err);
        std::process::exit(1);
    })
}
