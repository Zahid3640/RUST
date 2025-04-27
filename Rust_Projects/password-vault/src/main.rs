
mod passwentry;

use crate::passwentry::{prompt, read_password_from_file, ServiceInfo};

fn clr() {
    print!("{}[2J", 27 as char); // Clear screen
}

fn main() {
    clr();
    let ascii = r#"
      _____         _____ _____  __          ______  _____  _____  
     |  __ \ /\    / ____/ ____| \ \        / / __ \|  __ \|  __ \ 
     | |__) /  \  | (___| (___    \ \  /\  / / |  | | |__) | |  | |
     |  ___/ /\ \  \___ \\___ \    \ \/  \/ /| |  | |  _  /| |  | |
     | |  / ____ \ ____) |___) |    \  /\  / | |__| | | \ \| |__| |
     |_| /_/    \_\_____/_____/      \/  \/   \____/|_|  \_\_____/ 
    "#;
    println!("{ascii}");

    loop {
        println!("\nPASSWORD MENU MANAGER");
        println!("1. Password Entry");
        println!("2. List Entries");
        println!("3. Search Entry");
        println!("4. Quit");

        let mut choice = String::new();
        std::io::stdin().read_line(&mut choice).unwrap();
        match choice.trim() {
            "1" => {
                clr();
                let service = prompt("Service: ");
                let username = prompt("Username: ");
                let password = prompt("Password: ");
                let entry = ServiceInfo::new(service, username, password);
                entry.write_to_file();
            }
            "2" => {
                clr();
                let services = read_password_from_file().unwrap_or_else(|err| {
                    eprintln!("Error reading passwords: {}", err);
                    Vec::new()
                });
                for item in &services {
                    println!(
                        "Service: {}\n- Username: {}\n- Password: {}\n",
                        item.service, item.username, item.password
                    );
                }
            }
            "3" => {
                clr();
                let services = read_password_from_file().unwrap_or_else(|err| {
                    eprintln!("Error reading passwords: {}", err);
                    Vec::new()
                });
                let search = prompt("Search: ");
                for item in &services {
                    if item.service.eq_ignore_ascii_case(&search) {
                        println!(
                            "Service: {}\n- Username: {}\n- Password: {}\n",
                            item.service, item.username, item.password
                        );
                    }
                }
            }
            "4" => {
                clr();
                println!("GoodBye!");
                break;
            }
            _ => println!("Invalid Choice!"),
        }
    }
}
