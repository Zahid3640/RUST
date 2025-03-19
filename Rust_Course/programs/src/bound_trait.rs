trait Speak{
    fn speak(&self);
}
struct human;
impl Speak for human{
    fn speak(&self){
        println!("This is human");
    }
}
struct robot;
impl Speak for robot{
    fn speak(&self){
        println!("This is robot");
    }
}
fn introduce(s:&impl Speak){
    s.speak();
}
pub fn run(){
    let h=human;
    let r=robot;
    introduce(&h);
    introduce(&r);
}