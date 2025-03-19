// array m same data type ka collection hota h
// isy two chizy btani hoti h 
// data type
// size/length 
pub fn run(){
   // let  mut arr1:[u8,8]; // array declaration
   let  mut arr1;
   arr1=[1,2,3,4,5];


    println!("[0] is :{}",arr1[0] );
    println!("arr1 is :{:?}",arr1 );

    arr1[1]=23;
    println!("arr1 is :{:?}",arr1 );
    println!("arr1 length is :{}",arr1.len() );

}