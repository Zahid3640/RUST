pub fn run() {
    let numbers = vec![1, 2, 3, 4, 5];
    let mut doubled = Vec::new();

    for num in numbers.iter() {
        doubled.push(num * 2);
    }

    println!("{:?}", doubled);
}
