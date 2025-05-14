pub fn run(){
    // +,-,*,/
    let a:i32=8;
    let b :i32=4;
    let c=a+b;
    let c =a*b;
    let c=a/b;
    let c=a%b;
    println!("{}",c);

    //literal
    let a=2i32;
    let a=4u64;
    let a=1.3e3;
    println!("{}",a);

    // bollean
    let a=true&&false;
    let a=true||false;
    let a=!true;

    let a=3;
    let b=5;
    println!("{:03b}",a&b);
    println!("{:03b}",a|b);
    println!("{:03b}",a^b)

}