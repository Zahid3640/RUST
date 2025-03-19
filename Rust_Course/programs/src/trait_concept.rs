//Rust me trait ek blueprint hota hai jo ek ya zyada functions define karta hai,
// jo kisi struct ya type me implement kiye ja sakte hain.
// ✅ trait ek common behavior define karta hai.
// ✅ Structs ya Enums me trait implement kar sakte hain.
// ✅ Ek struct multiple traits implement kar sakta hai.
// ✅ Traits polymorphism aur code reusability ke liye use hote hain.
trait Animals {
     fn make_sound(&self);
}
struct dog;
impl Animals for dog {
       fn make_sound(&self) {
          println!("WOO WOO");
       }
}
struct cat;
impl Animals for cat{
       fn make_sound(&self) {
          println!("Moe Moe");
       }
}
pub  fn run(){
    let d=dog;
    let c=cat;
    d.make_sound();
    c.make_sound();
}