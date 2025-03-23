use serde::{Serialize,Deserialize};
#[derive(Serialize,Deserialize)]
struct Paragraph{
    name:String,
}
#[derive(Serialize,Deserialize)]
struct Article{
    article:String,
    aurthur:String,
    paragraph:Vec<Paragraph>,
}

fn main() {
    let article=Article{
        article:String::from("this tis first article"),
        aurthur:String::from("Zahid"),
        paragraph:vec![
         Paragraph{
            name:String::from("this is first paragraph"),
        },
        Paragraph{
            name:String::from("this is second paragraph"),
        },
        Paragraph{
            name:String::from("this is third paragraph"),
        },  
        ]
};
let json=serde_json::to_string(&article).unwrap();
println!("JSON FORMAT: {}",json);
}
