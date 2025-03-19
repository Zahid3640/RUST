pub fn run(){
    let nothing_reference=create_string_reference();
}
fn create_string_reference()->String{
    let s:String=String::from("hello");
    return s;
}