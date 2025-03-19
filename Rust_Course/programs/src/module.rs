mod math {
    pub fn add(a: i32, b: i32) -> i32 {
        a + b
    }
}

pub fn run() {
    let result = math::add(5, 3);
    println!("Sum is: {}", result);
}
