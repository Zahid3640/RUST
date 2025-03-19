fn add(a: i32, b: i32) -> i32 {
    a + b
}

pub fn run() {
    let func_ptr: fn(i32, i32) -> i32 = add; // Function pointer
    let result = func_ptr(5, 10);
    println!("Result: {}", result);
}
