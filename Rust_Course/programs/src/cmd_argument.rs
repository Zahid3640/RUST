use std::env;
pub fn run(){
    println!("Arument pass by CMD");
    let argu:Vec<String>=env::args().collect();

    for aggument in argu{
        println!(" ARGUMENT IS:{}",aggument);
    }
}