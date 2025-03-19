pub fn run(){
    let  mut v:Vec<&str>=vec!["hello","code","you"];
    write_vector(&mut v);
     println!("Vector V is :{:?}",v);
 }
 fn write_vector(v1:&mut Vec<&str>){
       v1.push("heelo");
       println!("Vector V1 is :{:?}",v1);
 }