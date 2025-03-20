use std::fs::File;
use std::io::Write;

pub fn run() {
    let mut file = File::create("example.txt").expect("File create nahi ho saki");
    file.write_all(b"Hello, Rust!").expect("File me likhne me error aaya");
}
