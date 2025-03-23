use std::error::Error;
use csv;

use serde::Deserialize;
#[derive(Debug,Deserialize)]
struct Person{
    name:String,
    age:u8,
    city:String,
}
fn read_from_file(path:&str)->Result<(),Box<dyn Error>>{
    let  mut reader=csv::Reader::from_path(path)?;

    for result in reader.deserialize()  {
        let person_data:Person=result?;
        println!("Name:{},   Age:{},   City:{}", person_data.name, person_data.age, person_data.city);    
    }
    Ok(())

}

fn main() {
    if let Err(e)=read_from_file("./Sample.csv")  {
        eprintln!("Error: {}",e);
    }
}
