macro_rules! my_macro {
    () => {
        println!("Hello from my_macro!");
    };
}

pub fn run() {
    my_macro!(); // Macro call
}
