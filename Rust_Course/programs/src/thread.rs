use std::thread::{self, JoinHandle};
use std::time::Duration;

pub fn run() {
    println!("Main: ");
    println!("Main: ");
    println!("Main: ");
    println!("Main: ");
    println!("Main: ");
   let t =thread::spawn(|| {
            println!("Thread: ");
            println!("Thread: ");
            println!("Thread: ");
            println!("Thread: ");
            println!("Thread: ");
            println!("Thread: ");
          //  thread::sleep(Duration::from_millis(500));
        
    });
    t.join();
    //thread::sleep(Duration::from_millis(500));
    println!("Main out thread: ");
    println!("Main out thread: ");
    println!("Main out thread: ");
    println!("Main out thread: ");
    println!("Main out thread: ");
        
    
}
