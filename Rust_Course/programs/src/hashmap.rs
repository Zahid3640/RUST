use std::collections::HashMap;

pub fn run() {
    let mut student_marks = HashMap::new(); // Empty HashMap

    // Data insert karna
    student_marks.insert("Ali", 90);
    student_marks.insert("Sara", 85);
    student_marks.insert("Usman", 78);

    println!("{:?}", student_marks);
}
