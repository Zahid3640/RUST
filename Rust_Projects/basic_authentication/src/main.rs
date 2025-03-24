use reqwest::blocking::Client;
use reqwest::Error;

fn main() ->Result<(),Error>{
    let client=Client::new();
    let user="Testuser".to_string();
    let passrd:Option<String>=None;
    let reponse=client
    .get("http://httpbin.org/get")
    .basic_auth(user, passrd)
    .send()?;
    //.text()?;


    println!("{:?}",reponse);
    Ok(())
}
