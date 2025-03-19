pub fn run(){
    // dynamic size length   heap  allocated
    //  change  kr skty is m
    let mut literal_string=String::from("hello how are you ");
    literal_string.push_str("i am fine");
    println!("mut string is  {}",literal_string);
}