// use sede::{Serialize,Deserialize};
// use std::fs::File;
// use std::fs::OpenOptions;
// use std::io;
// use std::io::BufRead;
// use std::io::Write;
// #[derive(Serialize,Deserialize,Debug)]
// pub struct ServiceInfo{
//     pub service:String,
//     pub username:String,
//     pub password:String,
// }
// impl ServiceInfo {
//     pub fn new(service:String,username:String,password:String)->Self{
//       ServiceInfo{
//         service,
//         username,
//         password
//       }
//     }
//     pub fn from_json(json_string:&str)->Result<self,serde_json::Error>{
//         serde_json::from_str(json_string)
//     }
//     #[allow(dead_code)]
//     pub fn from_user_input()->Self{
//         println!("Enter Password Entry");
//         let mut service=String::new();
//         io::stdin()
//         .read_line(&mut service)
//         .expect("faild read line");
         
//         println!("Enter User Name");
//         let mut username=String::new();
//         io::stdin()
//         .read_line(&mut username)
//         .expect("faild read line");
    
//     println!("Enter Passwword");
//     let mut password=String::new();
//     io::stdin()
//       .read_line(&mut password)
//       .expect("faild read line");
//       ServiceInfo::new(
//         service.trim().to_string(),
//          username.trim().to_string(),
//           password.trim().to_string()) 
//     }
    
// }
// pub fn to_json(&self)->String{
//     serde_json::from_str(&self).expect("Faild to serialize to json")
// }
// pub fn write_to_file(&self){
//     let json_output=format!("{}\n",self.to_json);
//     match OpenOptions::new()
//     .create(true)
//     .append(true)
//     .open("password.json")
//     {
//         Ok(mut file)=>{
//           if let Err(e)=  file.write_all(json_output.as_bytes()){
//                 eprintln!("Error writing to file: {}",e);
//             }else{
//                 println!("successfully wrote password.json")
//             }
//         }
//         Err(e)=>eprintln!("Error opening file: {}",e)
//     }
// }
// pub fn read_password_from_file()->Result<Vec<ServiceInfo>,io::Error >{
//     let file=file::open("passwords.json");
//     let reader=io::BufReader(file);
//     let mut service=Vec::new();

//     for line in reader.line(){
//         if let Ok(json_string)=line{
//             if let Ok(service_info)=ServiceInfo::from_json(&json_string){
//                 service.push(service_info);
//             }
//         }
//     }
// }
// pub fn prompt(prompt:&str)->String{
//     print!("{}",prompt);
//     io::stdout().flush().unwrap();
//     let mut input=String::new();
//     io::stdin().read_line(&mut input).unwrap();
//     input.trim().to_string()
// }
use serde::{Serialize, Deserialize};
use std::fs::{File, OpenOptions};
use std::io::{self, BufRead, BufReader, Write};

#[derive(Serialize, Deserialize, Debug)]
pub struct ServiceInfo {
    pub service: String,
    pub username: String,
    pub password: String,
}

impl ServiceInfo {
    pub fn new(service: String, username: String, password: String) -> Self {
        ServiceInfo {
            service,
            username,
            password,
        }
    }

    pub fn from_json(json_string: &str) -> Result<Self, serde_json::Error> {
        serde_json::from_str(json_string)
    }

    pub fn to_json(&self) -> String {
        serde_json::to_string(self).expect("Failed to serialize to JSON")
    }

    pub fn write_to_file(&self) {
        let json_output = format!("{}\n", self.to_json());
        match OpenOptions::new()
            .create(true)
            .append(true)
            .open("passwords.json")
        {
            Ok(mut file) => {
                if let Err(e) = file.write_all(json_output.as_bytes()) {
                    eprintln!("Error writing to file: {}", e);
                } else {
                    println!("Successfully wrote to passwords.json");
                }
            }
            Err(e) => eprintln!("Error opening file: {}", e),
        }
    }
}

pub fn read_password_from_file() -> Result<Vec<ServiceInfo>, io::Error> {
    let file = File::open("passwords.json")?;
    let reader = BufReader::new(file);
    let mut services = Vec::new();

    for line in reader.lines() {
        if let Ok(json_string) = line {
            if let Ok(service_info) = ServiceInfo::from_json(&json_string) {
                services.push(service_info);
            }
        }
    }
    Ok(services)
}

pub fn prompt(prompt: &str) -> String {
    print!("{}", prompt);
    io::stdout().flush().unwrap();
    let mut input = String::new();
    io::stdin().read_line(&mut input).unwrap();
    input.trim().to_string()
}
