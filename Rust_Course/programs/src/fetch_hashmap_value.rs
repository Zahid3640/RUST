use std::collections::HashMap;

pub fn run() {
    let mut scores = HashMap::new();
    scores.insert("Math", 80);
    scores.insert("Science", 90);

    let subject = "Science";
    
    match scores.get(subject) {
        Some(&score) => println!("{} score: {}", subject, score),
        None => println!("{} ka score nahi mila!", subject),
    }
}
