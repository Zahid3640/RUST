pub fn run(){
    
    let num1:u8=23;
    let num2:u8=34;
    let result=add(num1,num2);
    println!("Sum is this{}:",result);
}
fn add(item1:u8,item2:u8)->u8{   //-> u8 funtion jo return kr rah h usy btata h
    return item1+item2;
}