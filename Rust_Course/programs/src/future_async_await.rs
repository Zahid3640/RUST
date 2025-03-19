// use std::time::Duration;
// use tokio::time::sleep;

// async fn say_hello() {
//     sleep(Duration::from_secs(2)).await;
//     println!("Hello from Future!");
// }

// #[tokio::main]
// pub async fn run() {
//     say_hello().await;
// }
use tokio::time::{sleep, Duration};

async fn task1() {
    sleep(Duration::from_secs(2)).await;
    println!("Task 1 completed!");
}

async fn task2() {
    sleep(Duration::from_secs(1)).await;
    println!("Task 2 completed!");
}

#[tokio::main]
pub async fn run() {
    tokio::join!(task1(), task2());
}
