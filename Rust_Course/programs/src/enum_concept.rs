//Rust me enum ek custom data type hai jo multiple related values ko ek 
//single type me represent karne ke liye use hota hai.
//Data Representation:Multiple possible states ko represent karta hai
// Pattern Matching:match statement se direct handle kar sakte hain

enum Day{
    Monday,
    Tuesday,
    Wednesday,
    Thursday,
    Friday,
    Saturday,
    Sunday,
}
pub fn run(){
    let today=Day::Friday;
    match today{
        Day::Monday=>println!("Its Monday"),
        Day::Tuesday=>println!("Its Tuesday"),
        Day::Wednesday=>println!("Its Wednesday"),
        Day::Thursday=>println!("Its Thursday"),
        Day::Friday=>println!("Its Friday"),
        Day::Saturday=>println!("Its Saturday"),
        Day::Sunday=>println!("Its Sunday"),
         _=>println!("Its an other day")
    }
}