use std::sync::mpsc;
use std::thread;
use std::time::Duration;

pub fn run() {
    let (tx, rx) = mpsc::channel();

    thread::spawn(move || {
        let messages = vec!["Hi", "How are you?", "Bye"];
        
        for msg in messages {
            tx.send(msg).unwrap();
            thread::sleep(Duration::from_millis(500)); // Thoda delay
        }
    });

    for received in rx {
        println!("Received: {}", received);
    }
}
