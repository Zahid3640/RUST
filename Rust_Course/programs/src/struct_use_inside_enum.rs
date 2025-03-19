//Agar hume complex data store karna ho to hum structs ko enum ke andar use kar sakte hain.
struct Person {
    name: String,
    age: u8,
}

enum Status {
    Active,
    Inactive,
    Banned(String), // Ban reason
    UserInfo(Person),
}

pub fn run() {
    let user = Status::UserInfo(Person {
        name: String::from("Zahid"),
        age: 25,
    });
   let user2=Status::Active;
   let user3=Status::Inactive;
   let user4=Status::Banned( "Spamming".to_string());           
    match user4 {
        Status::Active => println!("User is Active"),
        Status::Banned(reason) => println!("User is Banned: {}", reason),
        Status::UserInfo(person) => println!("User {} is {} years old", person.name, person.age),
        _ => println!("Unknown Status"),
    }
}
