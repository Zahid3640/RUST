use std::thread;
use std::time::Duration;

pub fn run() {
    let mut handles = vec![];

    for i in 0..7 {
        let handle = thread::spawn(move || {
            println!("Thread {} is running", i);
           // thread::sleep(Duration::from_millis(500));
        });

        handles.push(handle);
    }

    for handle in handles {
        println!("Thread  is running");
        handle.join().unwrap();
    }
}
