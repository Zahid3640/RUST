// Rust me Generics ek powerful feature hai jo hume ek hi code ko multiple types ke liye reuse karne ka option deta hai.
// ➡ Iska use functions, structs, enums aur traits ke saath kiya jata hai.

// ✅ Code Reusability – Ek function ya struct multiple types ke saath kaam kar sakta hai.
// ✅ Type Safety – Rust compile-time pe type checking karta hai.
// ✅ Performance – Generics compile hone ke baad specific type ke liye optimize ho jate hain.


//Agar ek struct ke andar do alag-alag types chahiye, to aise likh sakte hain:
struct Point<T, U> {
    x: T,
    y: U,
}

pub fn run() {
    let mix_point = Point { x: 5, y: 4.5 }; // Integer + Float

    println!("Mixed Point: ({}, {})", mix_point.x, mix_point.y);
}


// struct Point<T> {
//     x: T,
//     y: T,
// }

// pub fn run() {
//     let int_point = Point { x: 5, y: 10 };
//     let float_point = Point { x: 3.2, y: 4.5 };

//     println!("Integer Point: ({}, {})", int_point.x, int_point.y);
//     println!("Float Point: ({}, {})", float_point.x, float_point.y);
// }


// fn print_value<T: std::fmt::Display>(x: T) {
//     println!("Value: {}", x);
// }

// pub fn run() {
//     print_value(10);      // Output: Value: 10
//     print_value(3.14);    // Output: Value: 3.14
//     print_value("Rust");  // Output: Value: Rust
// }
