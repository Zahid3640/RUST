struct user{
    name:String,
    age:u8
}
impl user {
    fn display(&self) {
        println!("User1 name is {} and age {}",self.name,self.age);
    }
}
pub fn run(){
    let mut user_1=user{
        name:String::from("zahid"),
        age:23
    };
    
    user_1.display();
   
 }

