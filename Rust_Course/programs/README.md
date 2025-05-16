# 🔶🔶🔶🔶 *What is Rust* 
*************************************************************
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

# 🔶🔶🔶🔶 *Rust Data Types* 
*************************************************************
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
#  🔶🔶🔶🔶 *Functions and Scope in Rust*
*************************************************************
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
# 🔶🔶🔶🔶 *Control Flow*
*************************************************************
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
# 🔶🔶🔶🔶 1. *Ownership*
****************************************************************
Rust mein har value ka owner hota hai. Har variable ko ek time par ek hi owner hota hai, aur jab owner destroy hota hai, to value bhi drop ho jaati hai (memory free ho jaati hai).

### Example:
<pre><br>
fn main() {
    let s1 = String::from("Hello");
    let s2 = s1; // Ownership of 's1' moves to 's2'

    // println!("{}", s1); // Error! 's1' no longer owns the value
    println!("{}", s2);  // Works fine
}<br></pre>
### Explanation:
s1 ne string "Hello" ko own kiya, phir s1 ki ownership s2 ko transfer ho gayi.

Iske baad s1 ko access karne ki koshish karte hain to error aata hai, kyunke ownership transfer ho chuki hai.

# 2. Ownership Rules:
<pre><br>
1. Each value in Rust has a variable that's its owner.
2 .A value can only have one owner at a time.
3. When the owner goes out of scope, the value will be dropped.<br></pre>
## 🔹 Rule 1: Each value in Rust has a single owner.
<pre><br> fn main() {
    let s = String::from("Zahid");
}
s is the owner of "Zahid" string.<br></pre>

Jab s scope ke bahar jayega, memory automatically free ho jayegi.
(No need for free() or delete)

## 🔹 Rule 2: When the owner goes out of scope, the value is dropped.
<pre><br>
fn main() {
    let name = String::from("Rust");
    println!("Name is: {}", name);
} // yahan name drop ho jata hai — memory free<br></pre>
Rust automatically drop() call karta hai.

### 🔹 Rule 3: When a value is assigned to another variable, ownership is moved, not copied (for heap data).
<pre><br>
fn main() {
    let s1 = String::from("Hello");
    let s2 = s1;

    // println!("{}", s1); ❌ Error — ownership moved
    println!("{}", s2); ✅
}<br></pre>
❓ Why Error?
String heap pe store hota hai, jab s1 ko s2 diya to ownership move ho gayi.

s1 → ❌ Invalid ho gaya

✅ Only one variable can own the data at a time!

## 🧊 But What If I Want to Keep s1 and s2?
# Use clone():
 <pre><br>
fn main() {
    let s1 = String::from("Hello");
    let s2 = s1.clone();

    println!("s1 = {}, s2 = {}", s1, s2);
}<br></pre>
🧠 clone() makes a deep copy. But it's expensive compared to move.

## 🔹 Stack vs Heap: Why Ownership Matters?
  <pre><br>
Feature	                 Stack                       	Heap
Fast	                     ✅                         	❌
Fixed size               	✅	                         ❌
Ownership	Not important  	✅                 Rust tracks ownership<br></pre>
Example	Integers (i32, bool)	String, Vec etc.

## 🔹 Ownership with Functions
<pre><br>
fn main() {
    let s = String::from("Zahid");
    takes_ownership(s);
    // println!("{}", s); ❌ Error
}

fn takes_ownership(name: String) {
    println!("Hello, {}", name);
}<br></pre>
🧠 Value passed into function → ownership bhi pass ho gaya!
## 🔹 Return Ownership
 <pre><br>
fn main() {
    let s1 = gives_ownership();
    let s2 = takes_and_gives_back(s1);
    println!("Final owner: {}", s2);
}

fn gives_ownership() -> String {
    String::from("Rust")
}

fn takes_and_gives_back(s: String) -> String {
    s
}<br></pre>
Data function mein gaya, wahan kaam hua, fir return karke ownership wapas mila.
# 3. Borrowing – References:
Agar tum chahte ho ke kisi variable ka access without ownership transfer ke ho, to tum borrowing ka use karte ho. Borrowing do types ka ho sakta hai:

Immutable Borrowing (multiple references allowed)

Mutable Borrowing (only one mutable reference allowed)

### Example:
<pre><br>
fn main() {
    let s1 = String::from("Hello");

    let s2 = &s1; // Immutable borrow
    let s3 = &s1; // Another immutable borrow
    println!("{}", s2);  // Works fine
    println!("{}", s3);  // Works fine

    // let s4 = &mut s1; // Error! Cannot have mutable and immutable borrows at the same time
}<br></pre>
### Explanation:
s2 aur s3 ne s1 ko immutable borrow kiya hai, isliye dono ko ek saath access kar sakte hain.

Agar tum mutable borrow ka use karte ho, to sirf ek hi mutable borrow allowed hota hai.

##  4. Mutable Borrowing – Only One at a Time:
Rust mein ek waqt mein sirf ek hi mutable reference allow hoti hai. Yeh is liye hota hai taake data races na ho aur program safe ho.

### Example:
 <pre><br>
fn main() {
    let mut s1 = String::from("Hello");

    let s2 = &mut s1; // Mutable borrow
    println!("{}", s2);  // Works fine

    // let s3 = &mut s1; // Error! Can't borrow 's1' as mutable more than once
}<br></pre>
### Explanation:
s2 ne s1 ko mutable borrow kiya hai, aur uske baad koi aur mutable reference nahi banayi ja sakti.

## 5. Borrowing and Function Arguments:
Rust mein tum function arguments ko pass karne ke liye ownership transfer ya borrowing ka use karte ho. Agar tum ownership pass karte ho, to function ke baad original variable use nahi ho sakta.

## Example (Ownership Transfer):
<pre><br>
fn takes_ownership(s: String) {
    println!("{}", s);
} // 's' goes out of scope here, so the value is dropped

fn main() {
    let s1 = String::from("Hello");
    takes_ownership(s1);  // Ownership of s1 moves to the function

    // println!("{}", s1);  // Error! 's1' is no longer valid
}<br></pre>
### Example (Immutable Borrowing):
<pre><br>
fn borrow_string(s: &String) {
    println!("{}", s);  // s is borrowed, ownership is not taken
}

fn main() {
    let s1 = String::from("Hello");
    borrow_string(&s1);  // Borrowing the value

    println!("{}", s1);  // Works fine, ownership is still with 's1'
}<br></pre>
### Explanation:
Ownership transfer ke case mein s1 function ke andar jaa kar destroy ho jata hai.

Borrowing ke case mein s1 ka ownership transfer nahi hota, aur tum main function ke baad bhi s1 ko access kar sakte ho.

## 6. The Rule of Lifetime in Borrowing:
Rust mein ek aur important cheez hai lifetimes. Lifetime ensures karte hain ke references valid rahein aur kisi bhi invalid memory access se bachaye.
 # 🔶🔶🔶🔶 *Lifetimes in Rust *
 *******************************************************
## 🔰 Motivation — Lifetimes ki Zarurat Kyun?
Rust mein hum references (&T, &mut T) use karte hain taake data ka ownership lose na ho.
Lekin agar reference kisi invalid data ki taraf point kare, to dangling pointer error hoti hai.
Rust ye error run-time par nahi, compile-time par pakadta hai — using lifetimes.

## 📌 Lifetime = Reference ka “Zinda Rehne Ka Time”
Lifetime ka matlab hota hai:
## "Yeh reference kab tak valid rahega?"

Rust compiler har reference ke peeche secretly lifetime attach karta hai.

## 🔥 Example Without Lifetimes — Compilation Error
<pre><br>fn get_ref() -> &String {
    let s = String::from("Zahid");
    &s // ❌ ERROR — s yahan destroy ho jaata hai
}<br></pre>
Yahan s function ke end pe destroy ho jata hai, lekin hum uska reference return kar rahe hain — invalid/dangling reference.

Rust allow nahi karega.

##  Fix with Lifetime Annotation
 <pre><br>
fn get_ref<'a>(input: &'a String) -> &'a String {
    input // return same reference that we received
}<br></pre>
🔍 Breakdown:
'a is a lifetime parameter (just like generics).

Hum compiler ko keh rahe hain:

“Input aur output dono references ek hi lifetime ke hain.”

# 🎯 Rule of Thumb:
## "Jis data ka reference return kar rahe ho, uska lifetime bhi pass karo."

## 📦 Example:
<pre><br>
fn main() {
    let name = String::from("Zahid");
    let result = longest(&name, &String::from("Nawaz"));
    println!("Longest: {}", result);
}

fn longest<'a>(a: &'a String, b: &'a String) -> &'a String {
    if a.len() > b.len() {
        a
    } else {
        b
    }
}<br></pre>
# 🔍 Explanation:
Dono inputs ka lifetime 'a hai.

Output ka lifetime bhi 'a hai.

So, return kiya gaya reference guaranteed hai ke valid rahega.

## ❗ Lifetime Mismatch Error
<pre><br>
fn main() {
    let r;
    {
        let x = 5;
        r = &x; // ❌ Error: x doesn't live long enough
    }
    println!("r: {}", r);
}<br></pre>
Yahan x block ke baad destroy ho jata hai, lekin r uska reference rakh raha hai — invalid!

# Lifetime in Structs
Agar aap struct mein reference rakhte ho, to lifetime specify karna zaroori hai:
<pre><br>
struct Person<'a> {
    name: &'a str,
}

fn main() {
    let name = String::from("Zahid");
    let p = Person { name: &name };
    println!("{}", p.name);
}<br></pre>
# 🔹 Closures in Rust – (Functions ko variable ki tarah treat karna)
# 🔥 What is a Closure?
Closure Rust mein anonymous function hoti hai — yani naam ke bagair function. Ye kisi variable mein store hoti hai aur doosray functions ko pass bhi ki ja sakti hai.

## ✅ Syntax:
<pre><br>let closure_name = |parameter| expression;
## ✅ Example:
<pre><br>let add = |a: i32, b: i32| a + b;

println!("{}", add(2, 3)); // Output: 5<br></pre>
## 🔍 Difference between fn and closure:
<pre><br>Function                  	Closure
Static hoti hai        	Dynamic hoti hai
Named hoti hai	         Anonymous hoti hai
Parameters fixed	       Parameters flexible<br></pre>

## 🧠 Closures capture variables:
<pre><br>let x = 5;
let print_x = || println!("X is: {}", x);

print_x(); // X is: 5<br></pre>
👉 Closure automatically x ko apne andar "capture" kar leta hai — isi ko lexical scope capturing kehte hain.

🔸 Iterators in Rust – (Looping in a smart way)
Rust mein iterators allow karte hain ke hum collections (arrays, vectors, etc.) pe loop kar sakein with smart functions.

## ✅ Example 1: Basic loop
<pre><br>let nums = vec![1, 2, 3];
for n in nums.iter() {
    println!("{}", n);
}<br></pre>
## ✅ Example 2: Using .map() with Closure
<pre><br>let nums = vec![1, 2, 3];
let doubled: Vec<i32> = nums.iter().map(|x| x * 2).collect();

println!("{:?}", doubled); // [2, 4, 6]<br></pre>
## ✅ .filter() Example:
<pre><br>let nums = vec![1, 2, 3, 4];
let evens: Vec<_> = nums.into_iter().filter(|x| x % 2 == 0).collect();

println!("{:?}", evens); // [2, 4]<br></pre>
## ⚠️ Important Functions with Iterators:
<pre><br>Function                   	Kaam
.map()                	Har item ko change karta hai
.filter()	             Sirf woh items rakhta hai jo condition match karein
.fold()	               Ek total ya result banata hai
.any()	                Check karta hai koi ek item condition match karta hai ya nahi
.all()                	Sab items condition match karte hain ya nahi<br></pre>


