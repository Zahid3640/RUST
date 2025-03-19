//Rust me static ek global constant hota hai jo program ke poore duration tak memory me rehta hai
//✅ const aur static dono constant values hain, lekin static ek fixed memory address use karta hai.
static MAX_USERS: u32 = 1000; // Global constant

pub fn run() {
    println!("Max Users Allowed: {}", MAX_USERS);
}
//Agar aapko static variable ko mutable banana hai, to unsafe block ka use karna padega.
// static mut COUNT: i32 = 0; // Mutable static variable

// pub fn run() {
//     unsafe {
//         COUNT += 1; // Unsafe block required
//         println!("COUNT: {}", COUNT);
//     }
// }
