// borrow m hum sirf refeence pass krty h ownrship trasfer ni krty
pub fn run(){
    let s1:String=String::from("hello"); 
    let len:usize=calculte_len(&s1);
    println!("The length of {}  is  {}:",s1 ,len);
}
fn calculte_len(s:&String)->usize{  
    let length=s.len(); 
    return length;
}