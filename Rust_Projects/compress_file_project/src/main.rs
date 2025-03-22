// extern  crate flate2;
// use flate2::write::GzEncoder;
// use flate2::Compression;
// use std::env::args;
// use std::env::Args;
// use std::io::copy;
// use std::io::BufReader;
// use std::fs::File;
// use std::time::Instant; 



// fn main() {
//     if args().len()!=3{
//     println!("Usage: `Source` `target` ");
//     return;
//     }
//     let mut input=BufReader::new(File::open(args().nth(1).unwrp()).unwrap());
//     let output=File::create(args().nth(2).unwrap()).unwrap();
//     let  mut encoder=GzEncoder::new(output, Compression::default());
//     let start=Instant::now();
//     Copy(&mut input,&mut encoder).unwrap();
//     let output=encoder.finish().unwrap();
//     println!(
//         "Source len: {:?}",
//         input.get_ref().metadata().unwrap().len()
//     );
//     println!( "Target len: {:?}",output.metadata().unwrap().len());
//     println!("Elapsed :{:?}",start.elapsed());
// }
extern crate flate2;
use flate2::write::GzEncoder;
use flate2::Compression;
use std::env::args;
use std::io::{copy, BufReader};
use std::fs::File;
use std::time::Instant;

fn main() {
    if args().len() != 3 {
        println!("Usage: `Source` `Target` ");
        return;
    }

    let source_file = args().nth(1).unwrap();
    let target_file = args().nth(2).unwrap();

    let input_file = File::open(source_file).expect("Failed to open source file");
    let output_file = File::create(target_file).expect("Failed to create target file");

    let mut input = BufReader::new(input_file);
    let mut encoder = GzEncoder::new(output_file, Compression::default());

    let start = Instant::now();

    copy(&mut input, &mut encoder).expect("Failed to copy data");

    let output = encoder.finish().expect("Failed to finalize compression");

    println!(
        "Source size: {:?} bytes",
        input.get_ref().metadata().unwrap().len()
    );
    println!("Target size: {:?} bytes", output.metadata().unwrap().len());
    println!("Elapsed time: {:?}", start.elapsed());
}
