#[derive(Default)]
struct user{
    name:String,
    age:u8
}
pub fn run(){
    let mut user_1=user{
        name:String::from("zahid"),
       // age:23
       ..Default::default()// default value show krwany kily use hota h k use hota h  
    };
    //user_1.age=34;
    println!("User1 name is {} and age {}",user_1.name,user_1.age);
}