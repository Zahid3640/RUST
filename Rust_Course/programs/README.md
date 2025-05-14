# Rust Data Types 
## 1. Scalar Types – Single value types
## 2. Compound Types – Multiple values combined
# 1. Scalar Types
Yeh wo types hain jo ek hi value ko hold karti hain — jaise number, character, boolean.

##  Integer Types (numbers without decimal)
Type	Size	Range
<pre><br>i8	1 B	-128 to 127
i32	4 B	-2,147,483,648 to 2.1B
u32	4 B	0 to 4,294,967,295
isize	depends on system (32 or 64 bit)	<br></pre>

📌 i = signed integer (negative bhi), u = unsigned (only positive)
let age: i32 = 24;
let price: u32 = 1500;
##  Floating Point Types (numbers with decimal)
##  Boolean Type
let is_active: bool = true;
let is_admin = false;
🧠 True ya false ko represent karta hai — usually condition checking mein use hota hai.

## Character Type
let ch: char = 'A';
let emoji: char = '😊';
🧠 'char' Rust mein Unicode support karta hai — yani har language aur emoji bhi.

# 2. Compound Types
Yeh types multiple values ko ek sath hold karte hain.
## Tuple
Fixed-size combination of different types.
let info: (i32, f64, char) = (24, 5.6, 'Z');
let (age, height, initial) = info;
println!("Age: {}", info.0); // Access by index
## Array
Same type ke multiple values, fixed size.
let marks: [i32; 3] = [80, 85, 90];
[Array Code](https://github.com/Zahid3640/RUST/blob/main/Rust_Course/programs/src/array.rs)

println!("First Mark: {}", marks[0]);
📌 Agar tumhe dynamic size chahiye to Vec<T> use karte hain.

## Vector (Bonus)
let mut list = vec![1, 2, 3];
list.push(4);
🧠 Arrays fixed hoti hain, vectors grow kar sakti hain.

## Type Inference
Rust smart hai — agar tum type nahi bhi do, to woh guess kar leta hai:
let name = "Zahid"; // Rust assumes &str
let num = 50;       // Rust assumes i32
