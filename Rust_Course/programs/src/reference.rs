// reference m privious variable ka address hota h or baki bi meta data hota jis sy hum safety ko brha skty h
pub fn run(){
    let  s1=5; 
    let  r1=&s1; // auto de referencing ho rahi h
    println!("The value of r2 is {}:",r1 );
}
// pub fn run(){
//     let mut s1=5; 
//     s1=s1+1;
//     let  r1=&mut s1;
//           *r1=*r1+1;
//     println!("The value of r2 is {}:",r1 );
// }