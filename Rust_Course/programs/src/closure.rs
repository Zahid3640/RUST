pub fn run() {
    let add = |a: i32, b: i32| -> i32 { a + b }; // Closure jo 2 numbers ko add karega
    println!("Sum: {}", add(5, 10));
}
