#[derive(Debug)]
enum matherr {
    devidedby0,
    other
    
}
fn div(x:u32,y:u32)->Result<u32,matherr>{
    if y==0{
       return  Err(matherr::devidedby0);
    }
    Ok(x/y)
}
pub fn run(){
    //panic!("ERROR");

    let arr=[1,2,3,4];
    let x:Option<&i32>=arr.get(7);
    match x {
        Some(val)=>println!("{val}"),
        None=>println!("None")
    }
    let a=1;

    let b=0;
    let c=div(a, b);
    match c {
        Ok(val)=>println!("{val}"),
        Err(err)=>println!("{:?}",err),
    }
    
}