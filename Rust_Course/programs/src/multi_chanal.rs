use std::sync::mpsc;
use std::thread;
use std::time::Duration;

pub fn run() {
    let (tx, rx) = mpsc::channel();
    let tx1 = tx.clone(); // Second sender

    thread::spawn(move || {
        tx.send("Message from Thread 1").unwrap();
    });

    thread::spawn(move || {
        tx1.send("Message from Thread 2").unwrap();
    });

    for received in rx {
        println!("Received: {}", received);
    }
}
