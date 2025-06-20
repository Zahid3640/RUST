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
##  Shadowing in Rust – "Purane Variable Par Naya Naam Daal Dena"
Rust mein shadowing ka matlab hota hai ek hi variable ka naam dobara use karna, lekin nayi value ke sath. Is se purani value overwrite nahi hoti, balke "shadow" ho jaati hai — yani naya version us purane ko chhupaa deta hai.

## Example:
<pre><br>
fn main() {
    let x = 5;
    let x = x + 1;
    let x = x * 2;
    println!("x: {}", x); // Output: x: 12
}<br></pre>
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
<pre><br>let closure_name = |parameter| expression;<br></pre>
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
<pre><br>Function              Kaam
.map()                	Har item ko change karta hai
.filter()	             Sirf woh items rakhta hai jo condition match karein
.fold()	               Ek total ya result banata hai
.any()	                Check karta hai koi ek item condition match karta hai ya nahi
.all()                	Sab items condition match karte hain ya nahi<br></pre>

# *struct in Rust – Structure Banane Ka Tareeqa*
Rust mein struct ka use hota hai custom data types banane ke liye, jisme tum multiple fields rakh sakte ho.
## 🧠 Socho:
Tum ek Person ka data represent karna chahte ho jisme name, age, aur email ho — to struct perfect hai.

### Syntax:
<pre><br> struct Person {
    name: String,
    age: u8,
    email: String,
}<br></pre>
###  Usage:
<pre><br>fn main() {
    let zahid = Person {
        name: String::from("Zahid Nawaz"),
        age: 25,
        email: String::from("zahid@example.com"),
    };

    println!("Name: {}, Age: {}, Email: {}", zahid.name, zahid.age, zahid.email);
}<br></pre>
## 🧾 Key Points:
Struct ek data container hai.
Tum multiple fields define kar sakte ho with different types.
Structs reusable hote hain.
# enum in Rust – Multiple Possible Options
enum ka matlab hai "enumeration" — iska use hota hai jab tum ek value me multiple possible types ya states rakhna chahte ho.
## 🧠 Socho:
Tumhare paas Payment Method ho sakta hai: Cash, CreditCard, ya Paypal.
## Syntax:
<pre><br>enum PaymentMethod {
    Cash,
    CreditCard(String),
    Paypal(String),
}<br></pre>
## Usage:
<pre><br>fn main() {
    let method = PaymentMethod::CreditCard(String::from("1234-5678-9012-3456"));

    match method {
        PaymentMethod::Cash => println!("Paid by Cash"),
        PaymentMethod::CreditCard(number) => println!("Paid by Credit Card: {}", number),
        PaymentMethod::Paypal(email) => println!("Paid via PayPal: {}", email),
    }
}<br></pre>
##  🧾 Key Points:
Enum ka use hota hai jab tumhare data ke multiple shapes or states ho sakte hain.
Har variant ke sath tum data attach bhi kar sakte ho.
match ka use karke tum different cases ko handle kar sakte ho.
## struct vs enum – Comparison Table:
 <pre><br>Feature	                  struct	                               enum
Purpose             	Multiple fields in one structure	    One value from multiple options
Examples	           Person, Car, Student	                 Result, Option, PaymentMethod
Data Combination   	All fields must exist                	Only one variant is active at a time
Matching           	Access fields directly	                se match to handle each variant<br></pre>
# What are Generics?
 Generic ka matlab hota hai "generalized type" — aap code likhtay ho jo har tarah ke data types ke liye kaam karein.

## Example: Without generics (Duplicate Code)
<pre><br>
fn print_i32(x: i32) {
    println!("i32 value: {}", x);
}

fn print_str(x: &str) {
    println!("str value: {}", x);
}<br></pre>
##  With Generics (Ek hi function sab ke liye)
<pre><br>
fn print_value<T: std::fmt::Display>(x: T) {
    println!("Value: {}", x);
}

fn main() {
    print_value(42);        // i32
    print_value("Zahid");   // &str
    print_value(3.14);      // f64
}<br></pre>
🔸 T is just a placeholder for any type.
T: Display ka matlab — T must be printable.

## 📦 Use in Structs and Enums
## Struct with Generic
<pre><br>
struct Point<T> {
    x: T,
    y: T,
}

let p1 = Point { x: 1, y: 2 };
let p2 = Point { x: 3.5, y: 4.5 };<br></pre>
##  Enum with Generic
<pre><br>
enum Option<T> {
    Some(T),
    None,
}<br></pre>
# What is a Trait?
 Trait Rust ka interface jaisa concept hai — define karta hai kya behavior expected hai kisi type se.

## Trait Declaration
<pre><br>
trait Speak {
    fn speak(&self);
}<br></pre>
## Implement Trait for Struct
<pre><br>
struct Person;

impl Speak for Person {
    fn speak(&self) {
        println!("Hello! I am a person.");
    }
}

let p = Person;
p.speak(); // Output: Hello! I am a person.<br></pre>
## Trait Bounds with Generics
Jab aap chahte ho ke generic types sirf specific behavior wale types ko accept karein.
<pre><br>
fn describe<T: Speak>(item: T) {
    item.speak();
}<br></pre>
## Traits with Multiple Bounds
<pre><br>
use std::fmt::Display;
use std::fmt::Debug;

fn print_info<T: Display + Debug>(x: T) {
    println!("Display: {}", x);
    println!("Debug: {:?}", x);
}<br></pre>
## Default Methods in Traits
Aap ek method trait mein default define kar sakte ho.
<pre><br>
trait Greet {
    fn say_hi(&self) {
        println!("Hi from default!");
    }
}

struct User;
impl Greet for User {}

let u = User;
u.say_hi(); // "Hi from default!"<br></pre>
## Returning Trait Objects (Dynamic Dispatch)
<pre><br>
trait Animal {
    fn speak(&self);
}

struct Dog;
struct Cat;

impl Animal for Dog {
    fn speak(&self) {
        println!("Woof!");
    }
}
impl Animal for Cat {
    fn speak(&self) {
        println!("Meow!");
    }
}

fn get_animal(s: &str) -> Box<dyn Animal> {
    if s == "dog" {
        Box::new(Dog)
    } else {
        Box::new(Cat)
    }
}<br></pre>
## Trait vs Generic – Difference
<pre><br>Feature	               Trait (interface)	                      Generic (type parameter)
Use-case          	Behavior define karna                     	Type ko flexible rakhna
Syntax            	trait TraitName {}                         	fn name<T>() {}
Reuse              	Multiple types me behavior               	Multiple types me logic
Dispatch type	      Static or Dynamic (dyn)	                  Mostly static (compile-time)<br></pre>

##  Summary:
<pre><br>Topic                       	Explanation
T                  	   Generic type placeholder
trait	                 Interface/behavior definition
impl                   TraitName for Type	Trait ko implement karna
T: TraitName	          Generic ke liye constraint
dyn Trait	             Trait object (runtime behavior)<br></pre>
# *Modules and Crates* 
## Rust ke Code Structure ke 3 Important Components
<pre><br>Concept                    	Matlab
Crate             	Ek complete binary ya library project
Module            	Code ka logical group (file or block)
Package	          Cargo ka ek project jo ek ya zyada crates contain kar sakta hai<br></pre>

##  1. What is a Crate?
Crate Rust ka smallest compilation unit hai.
Har binary (executable) aur library ek crate hoti hai.
Har crate ka entry point hota hai:

### main.rs for binary crate

### lib.rs for library crate

##  Example:
<pre><br>
cargo new hello_crate<br></pre>
<pre><br>
// src/main.rs
fn main() {
    println!("Hello from main crate!");
}<br></pre>
## 2. What is a Module?
Module Rust mein code ko organize karne ka tareeqa hai.

Har file/module can:

Define structs, enums, functions, etc.

Be public or private

## Module create karne ke 3 tareeqe:
### 🔹 A. Inline module (same file ke andar)
<pre><br>
mod greeting {
    pub fn say_hello() {
        println!("Hello, Zahid!");
    }
}

fn main() {
    greeting::say_hello();
}<br></pre>
### 🔹 B. Separate file module
Folder structure:

<pre><br>
src/
├── main.rs
└── greeting.rs<br></pre>
<pre><br>
// main.rs
mod greeting;<br></pre>
<pre><br>
fn main() {
    greeting::say_hello();
}<br></pre>
<pre><br>
// greeting.rs
pub fn say_hello() {
    println!("Hello from file!");
}<br></pre>
## 🔹 C. Nested module (folder inside folder)
Folder structure:

<pre><br>
src/
├── main.rs
└── greeting/
    ├── mod.rs
    └── english.rs<br></pre>
<pre><br>
// main.rs
mod greeting;

fn main() {
    greeting::english::say_hi();
}<br></pre>
<pre><br>
// greeting/mod.rs
pub mod english;<br></pre>
<pre><br>
// greeting/english.rs
pub fn say_hi() {
    println!("Hi Zahid!");
}<br></pre>
## 🔐 Public vs Private in Modules
By default, everything is private.

Use pub to expose (public) things.

<pre><br>
mod tools {
    pub fn hammer() {
        println!("Hammering!");
    }

    fn private_tool() {
        println!("Can't call me from outside.");
    }
}

fn main() {
    tools::hammer(); // ✅ OK
    // tools::private_tool(); ❌ error
}<br></pre>
## 🔹 use Keyword – Shortcut for Accessing Modules
<pre><br>
mod tools {
    pub fn hammer() {
        println!("Using hammer");
    }
}

use tools::hammer;

fn main() {
    hammer(); // No need for tools::
}<br></pre>
# 🔶 3. What is a Package?
A package contains 0 or 1 library crate and any number of binary crates.

It has a Cargo.toml file.

### Example:

<pre><br>
[package]
name = "my_project"
version = "0.1.0"
edition = "2021"

[dependencies]<br></pre>
## 🔹 External Crates – 3rd Party Libraries
External crates ko Cargo.toml mein add karo:

<pre><br>
[dependencies]
rand = "0.8"
Then use in your Rust file:<br></pre>

<pre><br>
use rand::Rng;

fn main() {
    let number = rand::thread_rng().gen_range(1..=10);
    println!("Random: {}", number);
}<br></pre>
## 🧠 Summary Table
<pre><br>Term                    	Meaning
Crate            	Compilable unit (binary/lib)
Module           	Code organization (folder/file)
Package	          Cargo project with one or more crates
mod	              Module declare karne ke liye
pub              	Public banaane ke liye
use              	Shortcut access dene ke liye<br></pre>
# *Error Handling in RusT*
Rust exception-based model use nahi karta (like try/catch).
Instead, Rust compile-time pe force karta hai ke aap errors ko handle karo.

## 🔹 Rust mein do types ke errors hote hain:
Type	Description
1. Recoverable	Aisi error jise handle karke program continue kar sakta hai (e.g., file not found).
2. Unrecoverable	Aisi error jahan program ko crash karna chahiye (e.g., array out of bounds).

## 🔸 1. Result Enum (Recoverable Errors)
<pre><br>
enum Result<T, E> {
    Ok(T),
    Err(E),
}<br></pre>
### Example:
<pre><br>
use std::fs::File;

fn main() {
    let file = File::open("test.txt");

    match file {
        Ok(f) => println!("File opened successfully!"),
        Err(e) => println!("Failed to open file: {}", e),
    }
}<br></pre>
## 🔸 2. Option Enum (for optional values)
<pre><br>
enum Option<T> {
    Some(T),
    None,
}<br></pre>
### Example:
<pre><br>
fn get_username(id: u32) -> Option<String> {
    if id == 1 {
        Some("Zahid".to_string())
    } else {
        None
    }
}

fn main() {
    let name = get_username(2);
    match name {
        Some(n) => println!("Username: {}", n),
        None => println!("No username found."),
    }
}<br></pre>
## 🔸 3. unwrap() — Quick & Dirty ❌ (Only if you're 100% sure)
<pre><br>
let file = File::open("test.txt").unwrap();
Agar Ok() milta hai to value return karta hai.<br></pre>

Agar Err() milta hai to program panic karega.

## 🔸 4. expect() — unwrap() + custom error
<pre><br>
let file = File::open("test.txt").expect("Failed to open file");<br></pre>
Better than unwrap() because ye custom message show karta hai.

## 🔸 5. ? Operator — Short way to return error
Agar aap function ke result ko handle nahi karna chahte, to ? operator use karo to error ko aage return kar do.

<pre><br>
use std::fs::File;
use std::io::{self, Read};

fn read_file() -> Result<String, io::Error> {
    let mut f = File::open("data.txt")?; // if error, return it
    let mut content = String::new();
    f.read_to_string(&mut content)?;
    Ok(content)
}<br></pre>
? operator internally match karta hai:

<pre><br>
match File::open("data.txt") {
    Ok(f) => f,
    Err(e) => return Err(e),
}<br></pre>
# 🔸 6. Custom Error Types (Advanced)
<pre><br>
use std::fmt;

#[derive(Debug)]
enum MyError {
    NotFound,
    PermissionDenied,
}

impl fmt::Display for MyError {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "{:?}", self)
    }
}<br></pre>
## 🔹 7. panic!?
Jab Rust ka program kisi serious error mein phase jaye, aur aage chalna unsafe ho, to Rust use roknay ke liye crash karta hai. Ye crash panic! macro ke through hota hai.

Think of panic! as:

## "Yeh problem bohat bara hai. Main program ko yahan rokun ga!"

## ✅ Syntax:
<pre><br>
panic!("Kuch toh ghalat ho gaya!");<br></pre>
## 🔸 Summary Table
<pre><br>Method                       	Use-case
Result<T, E>               	Handle recoverable error
Option<T>	                  Value may be present or not
unwrap()                   	Get value or panic
expect()	                   unwrap + custom message
? operator                  	Propagate error easily
panic!()	                Crash program immediately (unrecoverable)<br></pre>
# 🔶🔶🔶 *Concurrency in Rust: Mutex, Arc, and Threads* 
***********************************************************************
Rust mein Concurrency (multiple tasks ko ek hi waqt mein chalana) ko handle karna kuch unique hai. Rust ki ownership system ko dhyan mein rakhtay hue concurrency safe banaya gaya hai.

# 🔶 1. Threads in Rust:
Rust mein threads ko create karna kaafi asaan hai. Tum easily ek thread create kar ke usme koi bhi kaam perform kar sakte ho.

<pre><br>
use std::thread;

fn main() {
    let handle = thread::spawn(|| {
        println!("Thread started");
    });

    handle.join().unwrap(); // Waits for the thread to finish
    println!("Main thread finished");
}<br></pre>
###  Explanation:
## thread::spawn se ek naya thread start hota hai.

## join() method thread ke complete hone tak wait karne ka kaam karta hai.

## 🔶 2. Sharing Data Between Threads:
Rust mein shared data ko multiple threads ke beech safely share karna thoda tricky hota hai. Mutex aur Arc isko manage karte hain.

Mutex (Mutual Exclusion):
<pre><br>
use std::sync::{Arc, Mutex};
use std::thread;

fn main() {
    let counter = Arc::new(Mutex::new(0));

    let mut handles = vec![];

    for _ in 0..10 {
        let counter = Arc::clone(&counter);
        let handle = thread::spawn(move || {
            let mut num = counter.lock().unwrap();
            *num += 1;
        });

        handles.push(handle);
    }

    for handle in handles {
        handle.join().unwrap();
    }

    println!("Counter: {}", *counter.lock().unwrap());
}<br></pre>
## Explanation:
Mutex: Yeh ek lock mechanism hai jo ek time par sirf ek thread ko data access karne ki permission deta hai.

lock() ke through data ko access karte hain. Jab ek thread ka kaam complete hota hai, lock release ho jata hai.

Arc ek atomic reference counter hai jo multiple threads ko ek hi resource share karne ki permission deta hai.

## 🔶 3. Arc (Atomic Reference Counting):
<pre><br>
use std::sync::{Arc, Mutex};
use std::thread;

fn main() {
    let counter = Arc::new(Mutex::new(0));

    let counter1 = Arc::clone(&counter);
    let counter2 = Arc::clone(&counter);

    let handle1 = thread::spawn(move || {
        let mut num = counter1.lock().unwrap();
        *num += 1;
    });

    let handle2 = thread::spawn(move || {
        let mut num = counter2.lock().unwrap();
        *num += 1;
    });

    handle1.join().unwrap();
    handle2.join().unwrap();

    println!("Counter: {}", *counter.lock().unwrap());
}<br></pre>
## Explanation:
Arc (atomic reference counter) se multiple threads ko shared ownership milti hai.

Mutex ke saath use karte hue, Arc allow karta hai multiple threads ko ek shared resource ko safely access karna.

## 🔶 4. Deadlock Problem in Rust:
Rust deadlock ka issue naturally avoid karta hai because ownership system threads ko deadlock ke chance ko kam karta hai.

Deadlock Example:
<pre><br>
use std::sync::{Arc, Mutex};
use std::thread;

fn main() {
    let mutex1 = Arc::new(Mutex::new(0));
    let mutex2 = Arc::new(Mutex::new(0));

    let handle1 = thread::spawn(move || {
        let _lock1 = mutex1.lock().unwrap();
        println!("Thread 1 locked mutex 1");

        let _lock2 = mutex2.lock().unwrap(); // Will cause deadlock
        println!("Thread 1 locked mutex 2");
    });

    let handle2 = thread::spawn(move || {
        let _lock2 = mutex2.lock().unwrap();
        println!("Thread 2 locked mutex 2");

        let _lock1 = mutex1.lock().unwrap(); // Will cause deadlock
        println!("Thread 2 locked mutex 1");
    });

    handle1.join().unwrap();
    handle2.join().unwrap();
}<br></pre>
Yeh deadlock tab hota hai jab ek thread mutex 1 ko lock karta hai aur doosra thread mutex 2 ko lock karta hai, aur phir dono threads ko doosre mutex ki zaroorat padti hai. Yeh ek deadlock situation create karta hai.

## 🧠 Summary:
<pre><br>Concept	                         Explanation
thread::spawn               	Ek naya thread create karta hai
Mutex                       	Data ko lock kar ke safe access deta hai
Arc                         	Multiple threads ko ek shared resource safely access karne deta hai
lock()	                      Data ko access karne ke liye lock ka use karta hai
Deadlock	                    Jab do threads ek dusre ka resource wait karte hain aur koi bhi proceed nahi kar pata<br></pre>
# 🔶🔶🔶 *TESTING* 
**************************************************************
# Summary:
<pre><br>Concept	                           Explanation
Unit Tests                 	Specific function ya logic ko test karna.
Integration Tests	          Multiple functions ya modules ko test karna.
Documentation Tests        	Documentation mein code examples ko validate karna.
Assertions                  Test cases ke andar conditions ko check karna<br></pre>
# 🔶🔶🔶  *Rust Web Frameworks*
****************************************************************
Rust ka web development ecosystem abhi kaafi grow kar raha hai. Rust ke web frameworks ka major faida yeh hai ke yeh tumhare code ko safe aur fast banate hain, jo ke Rust ke core features hain. Rust ke web frameworks ka use kar ke tum highly concurrent aur parallel applications bana sakte ho jo memory safety guarantee karte hain.

## 🔶 1. Rocket Framework
Rocket ek high-level web framework hai jo tumhe easy-to-use aur developer-friendly features deta hai. Yeh framework highly type-safe hai aur Rust ke features ka best use karta hai, jaise ownership aur borrowing.

## Features:
Routing: Easy routing system jisme tum URL patterns define kar sakte ho.

Type Safety: Rocket ki major strength yeh hai ke yeh tumhare code ko type-safe banata hai, matlab ke errors compile-time par hi handle ho jaate hain.

Request Guards: Tum request guards define kar sakte ho jo tumhare HTTP requests ko filter karte hain.

Templating: Rocket mein built-in templating support hota hai jisse tum HTML pages ko dynamically render kar sakte ho.

## Example:
<pre><br>
use rocket::{get, launch, routes};

#[get("/")]
fn hello() -> &'static str {
    "Hello, Rocket!"
}

#[launch]
fn rocket() -> _ {
    rocket::build().mount("/", routes![hello])
}<br></pre>
## Explanation:

#[get("/")]: Yeh request ko handle karta hai jo root URL pe aati hai.

rocket::build(): Rocket application ko build karta hai.

## When to Use Rocket:
Jab tumhe type safety, simple routing, aur templating ki zaroorat ho.

Jab tum web applications ko quickly develop karna chahte ho.

## 🔶 2. Actix-Web Framework
Actix-Web ek fast aur powerful web framework hai jo Rust ke performance ke faayde ko fully use karta hai. Yeh framework highly concurrent hai aur tumhe asynchronous programming ko leverage karne ka moka deta hai.

## Features:
Asynchronous: Actix Web ka core asynchronous programming hai, jo tumhe concurrency aur parallelism ki madad se fast requests handle karne mein madad karta hai.

Actor-based Model: Actix Web actor model use karta hai jo threads ko efficiently manage karne mein madad karta hai.

Routing: Actix Web mein powerful routing system hai, jisme tum complex URL patterns define kar sakte ho.

Middleware Support: Yeh tumhe middleware define karne ki suvidha deta hai jaise logging, authentication, etc.

## Example:
<pre><br>
use actix_web::{web, App, HttpServer, Responder};

async fn hello() -> impl Responder {
    "Hello, Actix Web!"
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    HttpServer::new(|| {
        App::new().route("/", web::get().to(hello))
    })
    .bind("127.0.0.1:8080")?
    .run()
    .await
}<br></pre>
## Explanation:

async fn hello() -> impl Responder: Yeh async function hai jo HTTP request handle karta hai.

HttpServer::new(): Actix Web server ko start karta hai.

.bind("127.0.0.1:8080"): Server ko bind karta hai ek specific IP aur port par.

## When to Use Actix:
Jab tumhe high-performance aur concurrency handle karni ho.

Jab tum asynchronous programming ko use karte hue large-scale applications build karna chahte ho.

## 🔶 3. Tide Framework
Tide ek simple aur asynchronous web framework hai jo tumhe lightweight aur fast web applications banane ki suvidha deta hai.

## Features:
Async by Default: Tide fully asynchronous hai, jo tumhe efficient concurrency aur parallelism provide karta hai.

Extensible: Tum apni custom middleware aur features add kar sakte ho.

Lightweight: Yeh framework kaafi lightweight hai, jo simple web applications ke liye perfect hai.

## Example:
<pre><br>
use tide::Request;

async fn hello_world(_: Request<()>) -> &'static str {
    "Hello, Tide!"
}

#[async_std::main]
async fn main() -> Result<(), std::io::Error> {
    let mut app = tide::new();
    app.at("/").get(hello_world);
    app.listen("127.0.0.1:8080").await?;
    Ok(())
}<br></pre>
## Explanation:

app.at("/").get(hello_world): Yeh URL path define karta hai aur hello_world function ko map karta hai.

app.listen(): Web server ko specific IP aur port par listen karne ke liye start karta hai.

## When to Use Tide:
Jab tum simple, lightweight aur asynchronous web applications develop karna chahte ho.

Jab tumhein ek easy-to-use aur quick web framework ki zaroorat ho.

## 🔶 4. Warp Framework
Warp ek highly flexible aur powerful web framework hai, jo Rust ke async aur filter-based architecture ka use karta hai. Yeh framework composable filters ke concept par based hai.

## Features:
Filter-based Architecture: Yeh tumhe filters define karne ki suvidha deta hai jo requests ko process karte hain.

Async by Default: Warp bhi asynchronous hai, jo tumhein concurrency aur parallelism efficiently handle karne mein madad karta hai.

Composable: Tum filters ko easily compose kar sakte ho, jisse complex tasks ko handle karna asaan ho jaata hai.

## Example:
<pre><br>
use warp::Filter;

#[tokio::main]
async fn main() {
    let hello = warp::path!("hello" / String)
        .map(|name| format!("Hello, {}!", name));

    warp::serve(hello)
        .run(([127, 0, 0, 1], 3030))
        .await;
}<br></pre>
## Explanation:

warp::path!("hello" / String): Yeh ek path define karta hai jo /hello/{name} URL ko handle karega.

warp::serve(hello): Server ko run karta hai aur incoming requests ko handle karta hai.

## When to Use Warp:
Jab tumhe flexible aur composable filters ka use karte hue web applications build karne ho.

Jab tum asynchronous programming ke sath flexible architecture chahte ho.

## 🔶 5. Hyper Framework
Hyper ek low-level web framework hai jo tumhe HTTP server aur client ka kaam karne ki suvidha deta hai. Yeh framework fast aur efficient hai, lekin tumhein zyada customization aur control ka option deta hai.

## Features:
Low-level HTTP: Hyper tumhe low-level HTTP control deta hai, jo tumhein custom web servers aur clients banane mein madad karta hai.

Asynchronous: Yeh bhi asynchronous hai, jo concurrency ko efficiently handle karta hai.

## Example:
<pre><br>
use hyper::{Body, Client, Request, Response, Server};
use hyper::service::{make_service_fn, service_fn};

async fn hello(req: Request<Body>) -> Result<Response<Body>, hyper::Error> {
    Ok(Response::new(Body::from("Hello, Hyper!")))
}

#[tokio::main]
async fn main() {
    let make_svc = make_service_fn(|_conn| async { Ok::<_, hyper::Error>(service_fn(hello)) });

    let addr = ([127, 0, 0, 1], 8080).into();
    let server = Server::bind(&addr).serve(make_svc);

    println!("Listening on http://{}", addr);
    server.await.unwrap();
}<br></pre>
## Explanation:

hyper::service::service_fn: Yeh function request ko handle karta hai.

Server::bind(&addr): Server ko bind karta hai ek specific address aur port par.

## When to Use Hyper:
Jab tumhe custom HTTP server ya client banane ki zaroorat ho.

Jab tum low-level control chahte ho apne web server par.

## 🧠 Summary:
<pre><br>Framework                  	Features                     	Use Case
Rocket             	Type safety, Routing,               Templating	Simple aur safe web applications
Actix-Web          	High performance, Asynchronous     	Large-scale, high-performance web applications
Tide	               Lightweight, Async by default	      Simple, quick web applications
Warp	              Composable filters, Asynchronous	    Flexible web applications with custom filters
Hyper             	Low-level control, Asynchronous     	Custom HTTP server/client<br></pre>
# SPL Token Kya Hota Hai?
## 🔷 SPL = Solana Program Library
SPL Token ek standard hai jo Solana blockchain par Fungible ya Non-Fungible tokens banata hai — bilkul waise jaise:

# Ethereum par ERC-20 (for FT) ya ERC-721 (for NFT) hotay hain.

## SPL Token ka kaam:
<pre><br>Coin ya token banana
Use kisi ko transfer karna
Mint, burn, freeze, set authority<br></pre>

# SPL Tokens ki Types
Type	Use Case
<pre><br>🔹 SPL Fungible Token (SPL-FT)	Coins jaise SOL, USDC, ZahidCoin
🔹 SPL Non-Fungible Token (SPL-NFT)	Digital Art, Tickets, Memberships
🔹 SPL Token 2022	Updated version with new features (metadata, fees etc.)<br></pre>
# Fungible vs Non-Fungible Token – Asaan Zabaan Mein
# 🔹 Fungible Token (FT) – “Barabar aur Badalnay Wale”
Matlab: Har unit same hoti hai, interchange kar sakte ho.

# 🔸 Examples:
<pre><br>1 Rupee = 1 Rupee
1 SOL = 1 SOL
1 ZahidCoin = 1 ZahidCoin<br></pre>

# 🔹 Real-life Example:
Jaise 100 rupee ke 100 note hain — har note barabar hai, kisi ka bhi use karo, farq nahi parta.

# 🔸 Non-Fungible Token (NFT) – “Unique aur Alag”
Matlab: Har token alag hota hai. Badal nahi sakte.

## 🔸 Examples:
<pre><br>Ek art ka piece
Property document
Certificate
Digital photo NFT<br></pre>

## 🔹 Real-life Example:
Ek passport ya NIC — sab ke paas hota hai, lekin har ek unique hota hai.
