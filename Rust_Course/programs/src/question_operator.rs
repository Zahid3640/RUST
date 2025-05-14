fn divide(a: i32, b: i32) -> Result<i32, String> {
    if b == 0 {
        return Err("Division by zero".to_string());
    }
    Ok(a / b)
}

pub fn run() -> Result<(), String> {
    let result = divide(10, 0)?; // 🔥 yahan ? use hua
    println!("Result: {}", result);
    Ok(())
}
