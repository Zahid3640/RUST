// write khta h k ik time pr multiply write ni kr skty 
// ik ny ny agr write  complete kr lia h tu usy use kr lo tab dusra start kry 
// y khta h k write kro lihkn ik pattern k sath phly ik phir dusra 
pub fn run(){
    let mut s1:String=String::from("hello "); 
    let r1=&mut s1;
    r1.push_str("bro");
    println!("The value of r1 is {}:",r1 );
    let r2=&mut s1;
    r2.push_str(" i am zahid");
    println!("The value of r2 is {}:",r2 );
}
// jab read krty h tu kuch ni hoga msla tab ho ga jab write kry gy
// pub fn run(){
//     let  s1:String=String::from("hello "); 
//     let r1=&s1;
//     let r2=&s1;
//     println!("The value of r1 is {}and r2 is {}:",r1,r2 );
// }