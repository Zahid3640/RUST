use std::io;
use rand::Rng;
use std::cmp::Ordering;

fn main() {
    loop {
        println!("\n Wellcome to Guessing Game");
        println!("🎯 Choose difficulty level");
        println!("1. Easy (1-50)");
        println!("2. Medium (1-100)");
        println!("3. Hard (1-500)");
        println!("Enter your choice (1, 2, or 3): ");
        let mut difficulty = String::new();
        io::stdin().read_line(&mut difficulty).expect("Failed to read input");
        let difficulty: u32 = difficulty.trim().parse().unwrap_or(2);

        let max_range = match difficulty {
            1 => 50,
            3 => 500,
            _ => 100,
        };

        let secret_number = rand::thread_rng().gen_range(1..=max_range);
        let mut attempts = 0;

        println!("\n🔢 Guess the number (between 1 and {})!", max_range);

        loop {
            let mut guess = String::new();
            io::stdin().read_line(&mut guess).expect("Failed to read input");

            let guess: u32 = match guess.trim().parse() {
                Ok(num) => num,
                Err(_) => {
                    println!("❌ Invalid input! Please enter a number.");
                    continue;
                }
            };

            attempts += 1;

            match guess.cmp(&secret_number) {
                Ordering::Less => println!("⬇️ Too small! Try again."),
                Ordering::Greater => println!("⬆️ Too big! Try again."),
                Ordering::Equal => {
                    println!("🎉 You guessed it in {} attempts!", attempts);
                    break;
                }
            }
        }

        println!("\n🔄 Do you want to play again? (y/n): ");
        let mut play_again = String::new();
        io::stdin().read_line(&mut play_again).expect("Failed to read input");

        if !play_again.trim().eq_ignore_ascii_case("y") {
            println!("👋 Thanks for playing! Goodbye.");
            break;
        }
    }
}


