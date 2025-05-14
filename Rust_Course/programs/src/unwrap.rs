pub fn run(){
//    let result:Result<u32,&str>=Err("Error");
let result:Result<u32,&str>=Ok(10);
   println!("{}",result.unwrap());



   let result=Some(43);
    println!("{}",result.unwrap());


     let result:Option<&str>=None;
    println!("{}",result.unwrap());
}