
// usi array m changing ho gi memory m new array ni bny gi
pub fn run(){
    // let  mut arr1:[u8,8]; // array declaration
    let  mut arr1:[&str;3]=["hello","code","love"];
 
      write_arry(&mut arr1);
     println!("arr1 is :{:?}",arr1 );
 }
 fn write_arry(arr2:&mut[&str;3]){
    arr2[1]="fellow";
    println!("arr2 is :{:?}",arr2 );
 }