trait Shape {
    fn area(&self) -> f64;
}

struct Circle {
    radius: f64,
}

impl Shape for Circle {
    fn area(&self) -> f64 {
        3.14 * self.radius * self.radius
    }
}

pub fn run() {
    let c = Circle { radius: 5.0 };
    println!("Circle Area: {}", c.area()); // Output: 78.5
}
