use std::fs;

pub fn run() {
    let content = fs::read_to_string("example.txt").expect("File read nahi ho saki");
    println!("File content: {}", content);
}
