pub fn run(){
    let s1:String=String::from("hello"); // owner of hello
    let (s2,len)=calculte_len(s1);// ownership trasfer
          // s2 new owner 
    println!("The length of {} is {}:",s2 ,len);
}
fn calculte_len(s:String)->(String,usize){  // s new owner of hello
    let length=s.len(); 
    return (s,length);// ownership trasfer wapis
}


// pub fn run(){
//     let s1:String=String::from("hello"); 
//     let len:usize=calculte_len(s1);

//     println!("The length of {} is {}:",s1 ,len);
// }
// fn calculte_len(s:String)->usize{   
//     return s.len();
// }