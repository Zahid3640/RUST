pub fn run(){
    let s1:String=get_string(); // s1 new owner of hello
    println!("value of s1 is this{}:",s1);
    let s2:String=String::from("world");// owner of world
    let s3:String=send_get_string(s2); // ownership transfer
    // s3 new owner of world

    println!("value of s3 is this{}:",s3);
}
fn get_string()->String{   
    let new_string:String=String::from("hello"); // owner  of hello
    return new_string;// transfer of ownership
}
// owner of world
fn send_get_string(recivd_string:String)->String{
   return recivd_string;// trasfer ownership to s3
}