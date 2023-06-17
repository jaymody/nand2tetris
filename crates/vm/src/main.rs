use vm::translate;

fn main() {
    let infile = std::env::args().nth(1).expect("no filename given");
    let text = std::fs::read_to_string(infile).unwrap();
    let assembly_code = translate(&text);
    println!("{assembly_code}");
}
