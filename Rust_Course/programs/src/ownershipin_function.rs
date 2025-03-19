use std::string;

pub fn run(){
    let str1:String=String::from("hello"); // str1 owner of hello
    process_string(str1); // transfer of ownership
   // println!("value  is this{}:",str1);
}
fn process_string(str2:String){   //st2 new owner of hello 
    println!("Num1 vale is{}",str2);
}
// Stack allocation 
// pub fn run(){
//     let num1:u8=23;
//     process_integer(num1);
//     println!("value  is this{}:",num1);
// }
// fn process_integer(item1:u8){   // u8 funtion jo return kr rah h usy btata h
//     println!("Num1 vale is{}",item1);
// }