//Rust me struct ek custom data type hai jo multiple values ko group karne ke liye use hota hai.
//Ek object ya entity ko represent karta hai
struct Person {
    name: String,
    age: u8,
}

pub fn run() {
    // `Person` ka ek instance (object) create karna
    let person1 = Person {
        name: String::from("Zahid"),
        age: 25,
    };

    // Values print karna
    println!("Name: {}", person1.name);
    println!("Age: {}", person1.age);
}

