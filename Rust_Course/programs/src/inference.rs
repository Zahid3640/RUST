use std::any::type_name_of_val;

// inference feature of programming laguage m hota h k jab user koi size wgra na btay tu wo bydefault size consider kr lyta h
pub fn run(){
    let x=5;  // by default i32 consider krta h
    let y=5.5;  // by default f64 consider krta h
    let z="hello";  // by default &str consider krta h

    println!("type of x:{}",type_name_of_val(&x));
    println!("type of y:{}",type_name_of_val(&y));
    println!("type of z:{}",type_name_of_val(&z));
}