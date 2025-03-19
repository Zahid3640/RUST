trait Greet {
    fn say_hello(&self) {
        println!("Hello, Rustacean!");
    }
}

struct Person;
impl Greet for Person {}  // Default behavior use hoga

pub fn run() {
    let p = Person;
    p.say_hello(); // Output: Hello, Rustacean!
}
