pub fn run(){
    let number=5; 
    if number % 3==0 && number % 4==0{
        println!("Number is devisible both 3 or 4");
    }
    else if number % 3==0 {
        println!("Number is devisible 3");
    }
    else if number % 4==0 {
        println!("Number is devisible 4");
    }
    else{ println!("Number is neither devisible ");}
}