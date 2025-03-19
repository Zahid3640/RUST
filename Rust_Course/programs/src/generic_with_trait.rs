trait Area<T> {
    fn calculate(&self) -> T;
}

struct Rectangle {
    width: f64,
    height: f64,
}

impl Area<f64> for Rectangle {
    fn calculate(&self) -> f64 {
        self.width * self.height
    }
}

pub fn run() {
    let rect = Rectangle { width: 10.0, height: 5.0 };
    println!("Area: {}", rect.calculate());
}
