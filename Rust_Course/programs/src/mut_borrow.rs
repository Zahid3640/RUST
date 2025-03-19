pub fn run(){
    let mut s1:String=String::from("hello "); 
    append(&mut s1);
    println!("The value of s1 is  {}:",s1 );
}
fn append(s:&mut String){
    s.push_str("World");
}