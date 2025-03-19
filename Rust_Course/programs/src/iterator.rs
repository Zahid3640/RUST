// pub fn run() {
//     let numbers = vec![1, 2, 3, 4, 5];

//     for num in numbers.iter() {
//         println!("{}", num);
//     }
// }
pub fn run() {
    let numbers = vec![1, 2, 3];
    
    let doubled: Vec<i32> = numbers.iter().map(|x| x * 2).collect();
    
    println!("{:?}", doubled);
}
