macro_rules! sum {
    ($a:expr, $b:expr) => {
        println!("Sum is: {}", $a + $b);
    };
}

pub fn run() {
    sum!(10, 20); // Output: Sum is: 30
}
