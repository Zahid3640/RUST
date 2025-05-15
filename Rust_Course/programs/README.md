# What is Rust 
Rust ek modern, fast, aur secure system-level  programming language hai(like C/C++), but it gives memory safety without using a garbage collector.
Isay Mozilla ne develop kia tha (2010 ke around), aur iska main focus hai:
<pre><br>Safety
Speed
Concurrency.<br></pre>


# Rust ke 3 Major Features:
## 1. Memory Safety (without Garbage Collector)
Rust mein no garbage collector hota hai — phir bhi aap memory leaks aur crashes se safe rehte ho. Iske liye use hota hai:

<pre><br>Ownership
Borrowing
Lifetimes<br></pre>

 Is wajah se Rust ke programs bohot fast aur secure hote hain.

## 2.  Performance like C/C++
Rust ne C/C++ jaisa performance diya, lekin bugs aur memory issues se bachata hai.
Yeh isay ideal banata hai speed-critical applications ke liye.

## 3.  Concurrency without Data Races
Rust aapko threads ke zariye parallel programming karne deta hai — lekin without race conditions.
Yani multiple threads mein kaam karne ke bawajood bugs nahi aate.
# Variables & Mutability in Rust
## Variable kya hoti hai?
Rust mein variable ek memory ka naam hota hai jisme hum koi value store karte hain.
<pre><br>let x = 5;
println!("x = {}", x);<br></pre>

🔹 Yahan x ek variable hai jisme value 5 store hui hai.

## Default behavior: Immutable (na badalnay wali)
Rust mein by default har variable immutable hota hai — iska matlab ye value change nahin ho sakti.

<pre><br>let x = 10;
x = 20;  // ❌ Error: cannot assign twice to immutable variable<br></pre>

🧠 Rust hamesha safety aur predictability ko priority deta hai — isliye pehle se roknay ki koshish karta hai taake bugs na ho.

## Mutable Variables — mut keyword
Agar aap chahte ho ke variable ki value change ho sake to mut use karo:

<pre><br>let mut y = 10;
y = 20;  // ✅ No error
println!("y = {}", y); // prints: y = 20</br></pre>


## 1. let → Runtime Variable (Default: Immutable)
Temporary values ke liye jo mostly function ke andar hoti hain.

<pre><br>fn main() {
    let x = 5;         // Immutable
    let mut y = 10;    // Mutable
    println!("{}", x);
    y = 20;            // Allowed because it's mutable
    println!("{}", y);
}<br></pre>

## 2. const → Compile-Time Constant
Jiski value kabhi bhi change nahi hoti, aur wo compile-time pe fixed hoti hai.

<pre><br>const PI: f64 = 3.1415;
const MAX_USERS: u32 = 1000;

fn main() {
    println!("Pi is: {}", PI);
}<br></pre>
## 3. static → Single Memory Location (Fixed & Global)
Aisi value jo program ke lifetime tak ek hi memory location mein stored rahe — global state jaisa behave karti hai.
<pre><br>static SITE_NAME: &str = "SaduZai Wanda";

fn main() {
    println!("Welcome to {}", SITE_NAME);
}<br></pre>
## 🔐 Mutable static Example (unsafe):
<pre><br>static mut COUNTER: u32 = 0;

fn main() {
    unsafe {
        COUNTER += 1;
        println!("Counter: {}", COUNTER);
    }
}<br></pre>
⚠️ unsafe is liye required hai because Rust normally global mutable state allow nahi karta.

# 🔍 Summary Table:
<pre><br>
# Feature           	let	                    const                           	static
Scope	Local        (block/function)        	Global or local	                    Global only
Mutability        	✅ (with mut)	           ❌ Never                       	✅ (but needs unsafe)
Type Required?	    ❌ Optional            	✅ Yes	                          ✅ Yes
Lifetime	          Short (block)	          Forever (compiled-in)	          'static (whole app)
Compile-time?	     ❌ Runtime	             ✅ Compile-time	                 ✅ Compile-time
Use Case	        Temporary data	         Constants (math, config)        	Global state/memory
  <br></pre>

# Rust Data Types 
## 1. Scalar Types – Single value types
## 2. Compound Types – Multiple values combined
# 1. Scalar Types
Yeh wo types hain jo ek hi value ko hold karti hain — jaise number, character, boolean.

##  Integer Types (numbers without decimal)
<pre><br>
Type                   	Size                   	Range
i8                     	1 B                	-128 to 127
i32                    	4 B	                -2,147,483,648 to 2.1B
u32                    	4 B	                 0 to 4,294,967,295
isize               	depends   on system (32 or 64 bit)	<br></pre>

## 📌 i = signed integer (negative bhi), u = unsigned (only positive)
<pre><br>let age: i32 = 24;
let price: u32 = 1500;<br></pre>
##  Floating Point Types (numbers with decimal)
##  Boolean Type
<pre><br>let is_active: bool = true;
let is_admin = false;	<br></pre>
🧠 True ya false ko represent karta hai — usually condition checking mein use hota hai.

## Character Type
<pre><br>let ch: char = 'A';
let emoji: char = '😊';	<br></pre>
🧠 'char' Rust mein Unicode support karta hai — yani har language aur emoji bhi.

# 2. Compound Types
Yeh types multiple values ko ek sath hold karte hain.
## Tuple
Fixed-size combination of different types.
<pre><br>let info: (i32, f64, char) = (24, 5.6, 'Z');
let (age, height, initial) = info;
println!("Age: {}", info.0); // Access by index<br></pre>
## Array
Same type ke multiple values, fixed size.
<pre><br>let marks: [i32; 3] = [80, 85, 90];
println!("First Mark: {}", marks[0]);<br></pre>
[Array Code](https://github.com/Zahid3640/RUST/blob/main/Rust_Course/programs/src/array.rs)
📌 Agar tumhe dynamic size chahiye to Vec<T> use karte hain.

## Vector (Bonus)
<pre><br>let mut list = vec![1, 2, 3];
list.push(4);<br></pre>
🧠 Arrays fixed hoti hain, vectors grow kar sakti hain.

## Type Inference
Rust smart hai — agar tum type nahi bhi do, to woh guess kar leta hai:
<pre><br>let name = "Zahid"; // Rust assumes &str
let num = 50;       // Rust assumes i32<br></pre>
#  Functions and Scope in Rust 
## 1. What is a Function?
Rust mein function ek block of code hota hai jo specific kaam karta hai. Isse reuse, structure aur clarity milti hai.
### Syntax:
<pre><br>fn function_name(parameter: Type) -> ReturnType {
    // body
}<br></pre>
## 2. Hello Function Example
<pre><br>
fn main() {
    greet(); // function call
}

fn greet() {
    println!("Hello, Zahid!");
}<br></pre>
### Output:
<pre><br>
Hello, Zahid!<br></pre>
📌 fn keyword function define karta hai.
📌 greet() function ko main ke andar call kiya gaya.

## 3. Function with Parameters and Return Type
<pre><br>
fn main() {
    let sum = add(5, 3);
    println!("Sum is: {}", sum);
}

fn add(a: i32, b: i32) -> i32 {
    a + b
}<br></pre>
### Output:
<pre><br>
Sum is: 8<br></pre>
🔍 Breakdown:
fn add(a: i32, b: i32) -> i32 → ye function 2 integers leta hai aur integer return karta hai.

a + b is the return value (last expression without semicolon returns it).

## 4. Functions with Return using return
<pre><br>
fn square(x: i32) -> i32 {
    return x * x;
}<br></pre>
Agar aap return use karte ho, to uske baad ; lagta hai.
Agar return implicitly karna ho, to semicolon nahi lagate.

## 5. Function with No Return (Unit Type)
 <pre><br>
fn say_hello() {
    println!("Hello!");
}<br></pre>
Yahan function kuch return nahi karta, iska return type hota hai () (called Unit).


# Scope in Rust
## What is Scope?
Scope ka matlab hai: kahan tak koi variable ya function "visible" ya "accessible" hai.
Rust mein block {} ke andar jo variable declare hota hai, wo usi block tak limited hota hai.
 ### Variable Scope Example
<pre><br>fn main() {
    let name = "Zahid";
    {
        let age = 25;
        println!("Inside block: {}, {}", name, age);
    }
    // println!("{}", age); ❌ Error: `age` is out of scope
    println!("Outside block: {}", name);
}<br></pre>
### Output:
<pre><br>Inside block: Zahid, 25
Outside block: Zahid<br></pre>
🔍 age block ke andar define hua, isliye block ke bahar use nahi ho sakta.

### Function Scope
<pre><br>fn main() {
    let x = 10;
    print_number();
    // println!("{}", y); ❌ Error: y is out of scope
}

fn print_number() {
    let y = 20;
    println!("Inside print_number: {}", y);
}<br></pre>
# **Control Flow**
********************************************************************************
Control Flow ka matlab hai:

## "Program ka flow kaise control hota hai — kis block mein jana hai, kya execute karna hai."

Rust mein control flow ke main 5 tools hain:
<pre><br>
if / else
match
loop
while
for<br></pre>

## 1. if / else Statement
Rust mein if bilkul simple aur type-safe hota hai — condition true/false return karni chahiye.

<pre><br>
fn main() {
    let number = 10;

    if number > 0 {
        println!("Positive number");
    } else if number < 0 {
        println!("Negative number");
    } else {
        println!("Zero");
    }
}<br></pre>
### Output:

<pre><br>
Positive number<br></pre>
🔍 Note:
Parentheses () optional hain (if (number > 0) ❌ not needed)

Curly braces {} required hain.

## 2. if is an Expression (Return Value)
Rust mein if ek expression bhi hai — iska matlab ye value return kar sakta hai:

<pre><br>
fn main() {
    let condition = true;
    let number = if condition { 5 } else { 10 };
    println!("Value: {}", number);
}<br></pre>
### Output:
<pre><br>
Value: 5<br></pre>
## 3. match Statement (Powerful Switch Case)
match Rust ka most powerful pattern matching tool hai — JavaScript/Java/C++ ke switch ka upgrade.

<pre><br>
fn main() {
    let number = 2;

    match number {
        1 => println!("One"),
        2 => println!("Two"),
        3 => println!("Three"),
        _ => println!("Other number"), // default
    }
}<br></pre>
###  Output:

<pre><br>
Two<br></pre>
🔍 Breakdown:
Har => ke baad ek action ya value hoti hai.

_ wildcard hai (like default).

## 4. loop (Infinite Loop)
<pre><br>
fn main() {
    let mut count = 0;

    loop {
        println!("Count: {}", count);
        count += 1;

        if count == 3 {
            break; // exit loop
        }
    }
}<br></pre>
### Output:

<pre><br>
Count: 0
Count: 1
Count: 2<br></pre>
## 5. while Loop
<pre><br>
fn main() {
    let mut number = 3;

    while number != 0 {
        println!("{}!", number);
        number -= 1;
    }

    println!("Liftoff!");
}<br></pre>
###  Output:

<pre><br>
3!
2!
1!
Liftoff!<br></pre>
##  6. for Loop (Iteration)
Rust ka for loop safest and most used loop hai:

<pre><br>
fn main() {
    for i in 1..=5 {
        println!("i = {}", i);
    }
}<br></pre>
### Output:

<pre><br>
i = 1
i = 2
i = 3
i = 4
i = 5<br></pre>
🔍 Note:
1..=5 → includes 5

1..5 → excludes 5

