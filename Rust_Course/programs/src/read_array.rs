
pub fn run(){
    // let  mut arr1:[u8,8]; // array declaration
    let   arr1:[&str;3]=["hello","code","love"];
 
      write_arry(arr1);
     println!("arr1 is :{:?}",arr1 );
 }
 fn write_arry(arr2:[&str;3]){
    println!("arr2 is :{:?}",arr2 );
 }