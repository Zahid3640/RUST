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
### Use:
Temporary values ke liye jo mostly function ke andar hoti hain.

<pre><br>fn main() {
    let x = 5;         // Immutable
    let mut y = 10;    // Mutable
    println!("{}", x);
    y = 20;            // Allowed because it's mutable
    println!("{}", y);
}<br></pre>

## 2. const → Compile-Time Constant
### Use:
Jiski value kabhi bhi change nahi hoti, aur wo compile-time pe fixed hoti hai.

<pre><br>const PI: f64 = 3.1415;
const MAX_USERS: u32 = 1000;

fn main() {
    println!("Pi is: {}", PI);
}<br></pre>
## 3. static → Single Memory Location (Fixed & Global)
### Use:
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
You said:
m ny rust ka new course start kia h jo ap sy pocho btaty jana h deeply puri detail us ki
ChatGPT said:
Updated saved memory
Great, Zahid! Aap jab bhi kisi topic par Rust course se related question puchna chahein, bas mention kar dein. Main aapko har concept ki Urdu-style clarity ke sath step-by-step explanation dunga — theory ke sath examples bhi agar zarurat ho.

Shuru karne ke liye aap mujhe bata dein:

Aap kis topic par hain course mein?

Kya aapke paas code ya concept hai jo samajh nahi aaya?

Kya aapko theory chahiye ya practical coding ke examples ke zariye samajhna hai?

Bas puchhna shuru kar dein!

You said:
unwrap
ChatGPT said:
Great Zahid! Aaj hum unwrap ka concept Rust mein detail se samjhtay hain — basic se lekar depth tak, with examples, use-cases, aur Urdu-style clarity.

🔶 unwrap in Rust — Kya hota hai?
Rust mein unwrap() ek method hai jo Option aur Result types par use hoti hai.

Rust errors ko handle karne ke liye safe types use karta hai:

✔ Option Type:
rust
Copy
Edit
Some(value)     // Agar value mili
None            // Agar value nahi mili
✔ Result Type:
rust
Copy
Edit
Ok(value)       // Operation successful
Err(error)      // Operation failed
🟩 unwrap() ka kaam:
Agar Some(value) ya Ok(value) hai ➤ value ko return karega.

Agar None ya Err(e) hai ➤ program panic karega (i.e. crash ho jata hai).

🔸 Example with Option
rust
Copy
Edit
fn main() {
    let name = Some("Zahid");
    println!("Name: {}", name.unwrap());
}
Output:

makefile
Copy
Edit
Name: Zahid
Agar aap None ko unwrap karo:

rust
Copy
Edit
fn main() {
    let name: Option<&str> = None;
    println!("Name: {}", name.unwrap()); // ❌ Panic karega
}
Error:

rust
Copy
Edit
thread 'main' panicked at 'called `Option::unwrap()` on a `None` value'
🔸 Example with Result
rust
Copy
Edit
fn main() {
    let result: Result<i32, &str> = Ok(10);
    println!("Result: {}", result.unwrap());  // ✅ 10
}
Agar Err ho:

rust
Copy
Edit
fn main() {
    let result: Result<i32, &str> = Err("Something went wrong");
    println!("Result: {}", result.unwrap());  // ❌ Panic
}
Error:

rust
Copy
Edit
thread 'main' panicked at 'called `Result::unwrap()` on an `Err` value: "Something went wrong"'
⚠ Kab unwrap() Use Karna Chahiye?
✅ Use When:
Aap 100% sure ho ke value Some ya Ok hi hogi.

Test code ya prototypes mein.

❌ Avoid When:
Production code mein — kyun ke crash hone ka risk hota hai.

Jab uncertain inputs ho (like user input, file I/O, network response, etc).

🔐 Alternatives to unwrap()
match use karo — safer aur controlled behavior:

rust
Copy
Edit
let value = Some(5);
match value {
    Some(v) => println!("Value: {}", v),
    None => println!("No value found"),
}
unwrap_or(default) — agar value nahi mili to default le lo:

rust
Copy
Edit
let value: Option<i32> = None;
let num = value.unwrap_or(0);
println!("Number: {}", num);  // Output: 0
expect("Custom error message") — panic to karega, but message aapka hoga:

rust
Copy
Edit
let result: Result<i32, &str> = Err("Fail");
println!("{}", result.expect("Custom failure"));
🧠 Summary
Type	unwrap() on Success	unwrap() on Failure
Option	Returns value from Some(x)	Panics on None
Result	Returns value from Ok(x)	Panics on Err(e)

Agar aap chahein to main iske real-world use-cases (like file read, user input) ke examples bhi dikhata hoon.

Aap next topic ya question bata dein — ya agar unwrap ka kisi aur angle se doubt ho to puchhein freely.

You said:
panic 
ChatGPT said:
Zahid bhai, ab chalte hain panic! macro ki taraf jo Rust mein error handling ka critical part hai.

🔥 panic! in Rust — Full Explanation in Simple Style
🔹 Kya hota hai panic!?
Jab Rust ka program kisi serious error mein phase jaye, aur aage chalna unsafe ho, to Rust use roknay ke liye crash karta hai. Ye crash panic! macro ke through hota hai.

Think of panic! as:

"Yeh problem bohat bara hai. Main program ko yahan rokun ga!"

✅ Syntax:
rust
Copy
Edit
panic!("Kuch toh ghalat ho gaya!");
🧪 Simple Example:
rust
Copy
Edit
fn main() {
    panic!("Main crash kar gaya!");
}
Output:

javascript
Copy
Edit
thread 'main' panicked at 'Main crash kar gaya!', src/main.rs:2:5
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace
⚠ Kab panic! hota hai automatically?
Jab aap unwrap() kisi None ya Err pe lagate ho.

Jab array ka index out of bounds ho.

Jab aap khud panic! likhtay ho intentionally.

🔸 Example 1: Array Out of Bounds
rust
Copy
Edit
fn main() {
    let nums = [1, 2, 3];
    println!("{}", nums[5]);  // ❌ Index 5 doesn't exist
}
Output:

vbnet
Copy
Edit
thread 'main' panicked at 'index out of bounds: the len is 3 but the index is 5'
🔸 Example 2: Unwrap None
rust
Copy
Edit
fn main() {
    let name: Option<&str> = None;
    println!("{}", name.unwrap());  // ❌ Panic here
}
🔎 Panic ka Faida kya?
Rust "safe by default" language hai. Agar koi problem serious hai (e.g. null reference, corrupt memory), to program crash karta hai taake aap ko pata chal jaye. Isse bugs chhupte nahi, samne aate hain.

🧰 Advanced: Catching Panic
Aap panic ko catch bhi kar saktay ho (but rarely needed).

rust
Copy
Edit
use std::panic;

fn main() {
    let result = panic::catch_unwind(|| {
        panic!("Boom!");
    });

    println!("Caught panic: {:?}", result.is_err());  // true
}
💡 Panic vs Error Handling
Concept	Description
panic!	Program ko turant roknay ka signal (crash)
Result<T, E>	Error ko gracefully handle karne ka way

Production code mein hamesha Result preferred hota hai — taake user ko crash ka samna na ho.

🧠 Summary
panic! Rust ka emergency brake hai.

Automatically hota hai on unwrap failure, array index issues, etc.

Aap manually bhi likh saktay ho jab program continue nahi kar sakta.

Avoid in production — use Result or error handling instead.

Agar aap chahain to main panic ka backtrace samjha sakta hoon ya real-world project mein iska role explain kar sakta hoon. Next topic ya question bhi poochh saktay hain — main tayar hoon 🔥

You said:
question operator
ChatGPT said:
Great Zahid bhai! Ab hum samajhtay hain ? question mark operator ko Rust mein — yeh Rust ka ek powerful aur elegant shortcut hai error handling ke liye.

❓ ? (Question Mark Operator) — Kya Hai?
Rust mein ? operator use hota hai Result aur Option types ke sath, taake aap easily errors ko forward kar sako — bina zyada match ya if let likhne ke.

🔍 Meaning:
"? ka matlab hai: agar value Err (ya None) hai, to function se turant return kar do wohi error."

🔶 Syntax Example with Result:
rust
Copy
Edit
fn divide(a: i32, b: i32) -> Result<i32, String> {
    if b == 0 {
        return Err("Division by zero".to_string());
    }
    Ok(a / b)
}

fn main() -> Result<(), String> {
    let result = divide(10, 2)?; // 🔥 yahan ? use hua
    println!("Result: {}", result);
    Ok(())
}
🔑 Explanation:
Agar divide return kare Ok(5) ➜ result milta hai aur program continue karta hai.

Agar Err("Division by zero") ➜ main() turant return kar deta hai wohi error.

🔶 Example with Option:
rust
Copy
Edit
fn get_name(maybe_name: Option<&str>) -> Option<&str> {
    let name = maybe_name?;  // 🔥 if None, return None
    Some(name)
}
🔁 Without ? — Long Version
rust
Copy
Edit
fn divide(a: i32, b: i32) -> Result<i32, String> {
    if b == 0 {
        return Err("Division by zero".to_string());
    }
    Ok(a / b)
}

fn main() -> Result<(), String> {
    let result = match divide(10, 0) {
        Ok(val) => val,
        Err(e) => return Err(e),
    };
    println!("Result: {}", result);
    Ok(())
}
🔁 Yehi kaam ? operator ne ek line mein kar diya.

📌 Important Points
Feature	Explanation
Use with	Result<T, E> or Option<T>
Works only in	Functions that return Result or Option
Rust version	Rust 1.13+
Auto return	Agar Err ya None ho to function se return hota hai

💥 Invalid Use (Error):
rust
Copy
Edit
fn main() {
    let result = divide(10, 0)?; // ❌ Error — main return type Result nahi hai
}
🛠 Fix:

rust
Copy
Edit
fn main() -> Result<(), String> {
    let result = divide(10, 0)?; // ✅ Now it's valid
    Ok(())
}
🧠 Summary
Symbol	Use for	Behavior
?	Result / Option	If error or None, exit the function early
Works only in	Function returning Result or Option	

✅ Real-World Use Case
Reading a file:

rust
Copy
Edit
use std::fs::File;
use std::io::{self, Read};

fn read_file() -> io::Result<String> {
    let mut file = File::open("data.txt")?;  // 🔥
    let mut contents = String::new();
    file.read_to_string(&mut contents)?;
    Ok(contents)
}
Aap chahein to main iska real-world project ya ? ke inner working ka breakdown bhi samjha sakta hoon. Agar doubt hai ya aap next Rust topic chahte hain to bas bata dein ✅

You said:
rust
ChatGPT said:
Great Zahid bhai! Aapka topic hai Rust, aur aap detail mein seekhna chahte ho — har concept deeply samajhna hai. Aaj tak hum cover kar chuke hain:

✅ unwrap

✅ panic!

✅ ? (question mark operator)

Agar aap chahen, to next Rust topic step-by-step start karte hain. Yahaan kuch important Rust topics hain jinke through hum complete understanding build kar sakte hain:

✅ Recommended Rust Learning Path:
Step	Topic	Status
1	Variables & Mutability	🔜 Start karein?
2	Data Types (i32, f64, bool, etc.)	🔜
3	Functions & Return Values	🔜
4	if, match, loop, for, etc.	🔜
5	Ownership & Borrowing (MOST Important)	🔜
6	Structs & Enums	🔜
7	Pattern Matching	🔜
8	Result & Option in depth	🔜
9	Modules & Crates	🔜
10	Traits & Generics	🔜
11	Lifetimes	🔜
12	Smart Pointers (Box, Rc, etc.)	🔜
13	Concurrency (thread, tokio)	🔜
14	File Handling, Error Handling	🔜
15	Real Project / CRUD / API	🔜

Aap batao:
Kis topic se aaj start karein?
Agar aap beginner ho to main recommend karunga:

🔰 Variables & Mutability se start karein — aur phir Ownership tak step-by-step chalte hain.

Aap sirf "haan" ya topic ka naam bhej do — main full explanation Urdu-style clarity ke sath shuru kar doon.

You said:
step by step sary cover kro detail k sath alg alg
ChatGPT said:
Updated saved memory
Perfect Zahid bhai! Ab hum Rust ko step-by-step cover karenge — har topic ko alag se, Urdu-style clarity ke sath, taake aapko sab kuch deeply samajh aaye.

🧭 Rust Learning Roadmap (Step-by-Step)
📍 Step 1: Variables & Mutability (shuru karte hain)
Let’s dive in 👇

🧠 Step 1: Variables & Mutability in Rust
🔸 Variable kya hoti hai?
Rust mein variable ek memory ka naam hota hai jisme hum koi value store karte hain.

rust
Copy
Edit
let x = 5;
println!("x = {}", x);
🔹 Yahan x ek variable hai jisme value 5 store hui hai.

🔐 Default behavior: Immutable (na badalnay wali)
Rust mein by default har variable immutable hota hai — iska matlab ye value change nahin ho sakti.

rust
Copy
Edit
let x = 10;
x = 20;  // ❌ Error: cannot assign twice to immutable variable
🧠 Rust hamesha safety aur predictability ko priority deta hai — isliye pehle se roknay ki koshish karta hai taake bugs na ho.

✅ Mutable Variables — mut keyword
Agar aap chahte ho ke variable ki value change ho sake to mut use karo:

rust
Copy
Edit
let mut y = 10;
y = 20;  // ✅ No error
println!("y = {}", y); // prints: y = 20
🔍 Example:
rust
Copy
Edit
fn main() {
    let mut name = "Zahid";
    println!("Name: {}", name);

    name = "Zahid Nawaz";  // ✅ Allowed because it's mutable
    println!("Updated Name: {}", name);
}
❗ Important Points:
Feature	Detail
Immutable	let x = 5; (can't change x)
Mutable	let mut x = 5; (can change x)
Constant	Use const for fixed values (covered next)
Type Inference	Rust guess kar leta hai type: let x = 5; ➜ i32

🔧 Constant Variables (const)
Use hoti hai jab value kabhi bhi change nahi hoti, aur wo compile time pe fixed hoti hai.

rust
Copy
Edit
const PI: f64 = 3.1415;
println!("Pi = {}", PI);
⚠ Differences:
let	const
Runtime value	Compile-time fixed
Optional type	Type zaroori hoti hai
Can be mutable	Always immutable
Lowercase allowed	Always UPPERCASE required

🔚 Summary:
Rust mein variables by default immutable hain.

mut lagane se value change kar sakte ho.

const se compile-time constants banti hain.

Type inference default hai — Rust samajh leta hai.

Agar aap chaho to main is topic pe MCQs, practice problems, ya quiz bhi bana sakta hoon.

Bolo bhai — next step chalu karoon (Data Types)? Ya is topic pe kuch aur poochhna hai?







You said:
phly tu rust btana ta kia h


ChatGPT said:
Zahid bhai, zabardast sawal! Pehle ye samajhna bohot zaroori hai ke "Rust hota kya hai?" — agar buniyad (foundation) clear ho gi to aapko future mein har topic deeply samajhne mein asani hogi.

🦀 Rust Kya Hai? — Full Explanation in Simple Urdu
✅ Rust ek modern, fast, aur secure programming language hai.
Isay Mozilla ne develop kia tha (2010 ke around), aur iska main focus hai:
Safety, Speed, aur Concurrency.

🔥 Rust Kin Cheezon Ke Liye Best Hai?
Field	Example
System Programming	Operating Systems, Embedded Systems
WebAssembly	Browser ke liye fast code
Blockchain Development	Smart Contracts (e.g., Solana)
Backend Servers / APIs	Web services with Actix, Rocket etc.
CLI Tools (Command line apps)	Fast tools like ripgrep, exa, etc.
Games	Low-level game engines

⚙️ Rust ke 3 Major Features:
1. 🛡️ Memory Safety (without Garbage Collector)
Rust mein no garbage collector hota hai — phir bhi aap memory leaks aur crashes se safe rehte ho. Iske liye use hota hai:

Ownership

Borrowing

Lifetimes

🔐 Is wajah se Rust ke programs bohot fast aur secure hote hain.

2. ⚡ Performance like C/C++
Rust ne C/C++ jaisa performance diya, lekin bugs aur memory issues se bachata hai.
Yeh isay ideal banata hai speed-critical applications ke liye.

3. 🤝 Concurrency without Data Races
Rust aapko threads ke zariye parallel programming karne deta hai — lekin without race conditions.
Yani multiple threads mein kaam karne ke bawajood bugs nahi aate.

🤔 Rust Kyun Seekhna Chahiye?
Reason	Benefit
💨 Fast & Efficient	C/C++ jaisi speed — safer way mein
🧠 Smart Compiler	Aapki mistakes compile-time pe pakadta hai
🌐 Growing Community	Job scope increasing in Web3, systems
🔐 Memory Safe	Crashes, leaks, null pointer errors se safe
📦 Cargo Package Manager	Super easy dependency management
💬 Rustaceans Community	Supportive developers around the world

🔧 Real-World Examples:
Company	Use Case
Dropbox	File sync engine
Cloudflare	Networking & DNS security tools
Mozilla	Servo browser engine (Rust-based)
Amazon	Firecracker MicroVMs
Solana	Blockchain smart contracts

📜 Rust ka Hello World Example:
rust
Copy
Edit
fn main() {
    println!("Hello, Zahid!");
}
fn main() ➜ Program ka entry point

println! ➜ Console pe output

🧠 Summary: Rust is...
A powerful, memory-safe, and super-fast language jo C/C++ ki jagah le raha hai web3, system dev, and APIs ke liye.

Agar aap kahen to main ye explain kar sakta hoon:

Rust vs C++

Rust ka use Web3 ya backend mein kaise hota hai

Rust ka job scope

Ab bolo bhai — agla step Variables & Mutability shuru karoon, ya Rust ke use-cases pe thoda aur discussion karein?







You said:
let constant or static ko alg alg btao
ChatGPT said:
Zahid bhai, aapka sawal "let, const, aur static" ke beech ka farq samajhne ka hai — yeh Rust ka important topic hai. Chaliye in teeno ko deeply, separately, aur examples ke sath samajhte hain.

🧠 Rust mein let, const, aur static ka Difference
✅ 1. let → Runtime Variable (Default: Immutable)
🔹 Use:
Temporary values ke liye jo mostly function ke andar hoti hain.

rust
Copy
Edit
fn main() {
    let x = 5;         // Immutable
    let mut y = 10;    // Mutable
    println!("{}", x);
    y = 20;            // Allowed because it's mutable
    println!("{}", y);
}
⚙️ Characteristics:
Feature	Value
Scope	Local (function, block, loop)
Mutable?	Default: ❌; with mut: ✅
Type?	Optional (Rust infer kar leta hai)
Lifetime	Function ya block tak limited
Compile-time?	Nahin (Runtime hoti hai)

✅ 2. const → Compile-Time Constant
🔹 Use:
Jiski value kabhi bhi change nahi hoti, aur wo compile-time pe fixed hoti hai.

rust
Copy
Edit
const PI: f64 = 3.1415;
const MAX_USERS: u32 = 1000;

fn main() {
    println!("Pi is: {}", PI);
}
⚙️ Characteristics:
Feature	Value
Scope	Global ya local (both)
Mutable?	❌ Never mutable
Type?	✅ Must be specified
Lifetime	Always available (compile-time)
Compile-time?	✅ Yes
Storage	Value ko inline embed karta hai — har jagah copy hoti hai

✅ 3. static → Single Memory Location (Fixed & Global)
🔹 Use:
Aisi value jo program ke lifetime tak ek hi memory location mein stored rahe — global state jaisa behave karti hai.

rust
Copy
Edit
static SITE_NAME: &str = "SaduZai Wanda";

fn main() {
    println!("Welcome to {}", SITE_NAME);
}
⚙️ Characteristics:
Feature	Value
Scope	Global
Mutable?	✅ But only with unsafe block
Type?	✅ Required
Lifetime	'static i.e., full program lifetime
Compile-time?	✅ Yes
Thread-Safe?	❌ Mutable static is unsafe

🔐 Mutable static Example (unsafe):
rust
Copy
Edit
static mut COUNTER: u32 = 0;

fn main() {
    unsafe {
        COUNTER += 1;
        println!("Counter: {}", COUNTER);
    }
}
⚠️ unsafe is liye required hai because Rust normally global mutable state allow nahi karta.

# 🔍 Summary Table:
<pre><br>
# Feature           	let	                    const                           	static
Scope	Local        (block/function)       	Global or local	                   Global only
Mutability        	✅ (with mut)	           ❌ Never                       	✅ (but needs unsafe)
Type Required?	    ❌ Optional           	✅ Yes	                          ✅ Yes
Lifetime	           Short (block)	         Forever (compiled-in)	          'static (whole app)
Compile-time?	       ❌ Runtime	             ✅ Compile-time	                ✅ Compile-time
Use Case	           Temporary data	         Constants (math, config)        	Global state/memory
  <br></pre>

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
