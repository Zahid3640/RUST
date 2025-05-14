#[derive(Debug)]
struct lang {
    language: String,
    version: String,
}

pub fn run() {
    println!("zahid nawaz");
    let lang = "rust";
    println!("{}", lang);
    println!("{} {}", lang, lang);
    println!("{lang}");

    let x = 2;
    println!("{0}*{0}={1}", x, x * x);

    let lang = lang {
        language: "rust".to_string(),

        version: "2.4".to_string(),
    };

    println!("{:?}", lang);
    println!("{:#?}", lang)
}
