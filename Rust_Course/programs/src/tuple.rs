pub fn run(){
    //  different data type data store in tuple
    let emp_info:(&str,u8)=("zahid",23);

    //de structring
    let (emp_name,emp_age)=emp_info;
    
    println!("Emp name is  {} and age is {}",emp_name,emp_age);
}