use std::io;
pub fn run(){
    let mut input=String::new();
    io::stdin().read_line(&mut input).expect("fail input");
    println!("{}",input);
}