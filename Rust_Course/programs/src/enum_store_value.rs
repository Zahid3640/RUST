//Rust me enum ke variants me values store karne ka bhi option hota hai
enum shape{
    circle(f32),
    rectangle(f32,f64)
}
pub fn run(){
    let shape1=shape::circle(10.2);
    let shape2=shape::rectangle(10.2,32.3);

    match shape2{
        shape::circle(redius)=>println!("The Radius is :{redius}"),
        shape::rectangle(w,h)=>println!("The height  is {h} and width is {w}"),

    }
}