use regex::Regex;

pub fn run() {
    let re = Regex::new(r"(\d{3})-(\d{3})-(\d{4})").unwrap();
    let text = "My phone number is 123-456-7890";
    
    if let Some(captures) = re.captures(text) {
        println!("Area Code: {}", &captures[1]);
        println!("First 3 Digits: {}", &captures[2]);
        println!("Last 4 Digits: {}", &captures[3]);
    }
}
