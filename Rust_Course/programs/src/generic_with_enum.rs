enum Result<T, E> {
    Ok(T),
    Err(E),
}

pub fn run() {
    let success: Result<i32, &str> = Result::Ok(200);
    let failure: Result<i32, &str> = Result::Err("Not Found");

    match success {
        Result::Ok(val) => println!("Success: {}", val),
        Result::Err(err) => println!("Error: {}", err),
    }

    match failure {
        Result::Ok(val) => println!("Success: {}", val),
        Result::Err(err) => println!("Error: {}", err),
    }
}
// fn square<T: std::ops::Mul<Output = T> + Copy>(x: T) -> T {
//     x * x
// }

// pub fn run() {
//     println!("Square of 4: {}", square(4));     // Output: 16
//     println!("Square of 3.5: {}", square(3.5)); // Output: 12.25
// }

