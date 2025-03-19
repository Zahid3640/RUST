// clone ik trah ka value copy ho jati h or alg alg memory m value store hoti h jis trah stack m hoti h wo usy use kr skty h
// y expensive method hota h 
pub fn run(){
    let s1:String=String::from("hello"); 
    let len:usize=calculte_len(s1.clone());
    println!("The length of {}  is  {}:",s1 ,len);
}
fn calculte_len(s:String)->usize{  
    let length=s.len(); 
    return length;
}