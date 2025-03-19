trait Fly {
    fn fly(&self);
}

trait Swim {
    fn swim(&self);
}

struct Duck;
impl Fly for Duck {
    fn fly(&self) {
        println!("Duck is flying!");
    }
}
impl Swim for Duck {
    fn swim(&self) {
        println!("Duck is swimming!");
    }
}

pub fn run() {
    let d = Duck;
    d.fly();  // Output: Duck is flying!
    d.swim(); // Output: Duck is swimming!
}
