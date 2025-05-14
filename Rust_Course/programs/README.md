# What is Rust 
✅ Rust ek modern, fast, aur secure programming language hai.
Isay Mozilla ne develop kia tha (2010 ke around), aur iska main focus hai:
Safety, Speed, aur Concurrency.

## Rust Kin Cheezon Ke Liye Best Hai?
<pre><br>Field	Example
System Programming	Operating Systems, Embedded Systems
WebAssembly	Browser ke liye fast code
Blockchain Development	Smart Contracts (e.g., Solana)
Backend Servers / APIs	Web services with Actix, Rocket etc.
CLI Tools (Command line apps)	Fast tools like ripgrep, exa, etc.
Games	Low-level game engines<br></pre>

# Rust ke 3 Major Features:
## 1. Memory Safety (without Garbage Collector)
Rust mein no garbage collector hota hai — phir bhi aap memory leaks aur crashes se safe rehte ho. Iske liye use hota hai:

<pre><br>Ownership
Borrowing
Lifetimes<br></pre>

🔐 Is wajah se Rust ke programs bohot fast aur secure hote hain.

## 2. ⚡ Performance like C/C++
Rust ne C/C++ jaisa performance diya, lekin bugs aur memory issues se bachata hai.
Yeh isay ideal banata hai speed-critical applications ke liye.

## 3. 🤝 Concurrency without Data Races
Rust aapko threads ke zariye parallel programming karne deta hai — lekin without race conditions.
Yani multiple threads mein kaam karne ke bawajood bugs nahi aate.

🤔 Rust Kyun Seekhna Chahiye?
<pre><br>Reason	Benefit
💨 Fast & Efficient	C/C++ jaisi speed — safer way mein
🧠 Smart Compiler	Aapki mistakes compile-time pe pakadta hai
🌐 Growing Community	Job scope increasing in Web3, systems
🔐 Memory Safe	Crashes, leaks, null pointer errors se safe
📦 Cargo Package Manager	Super easy dependency management
💬 Rustaceans Community	Supportive developers around the world<br></pre>

## 🔧 Real-World Examples:
<pre><br>Company	Use Case
Dropbox	File sync engine
Cloudflare	Networking & DNS security tools
Mozilla	Servo browser engine (Rust-based)
Amazon	Firecracker MicroVMs
Solana	Blockchain smart contracts<br></pre>
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
