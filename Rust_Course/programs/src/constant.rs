const MAX_USERS: u32 = 1000; // Constant (fix)
pub fn run() {
    let users = 500; // Variable (runtime pe change ho sakta hai)
    println!("Max Users: {}, Current Users: {}", MAX_USERS, users);
}
