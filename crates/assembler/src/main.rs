use assembler::{assemble, parse};

fn main() {
    let infile = std::env::args().nth(1).expect("no filename given");
    let text = std::fs::read_to_string(infile).unwrap();
    let instructions = parse(&text);
    let machine_code = assemble(instructions);
    println!("{machine_code}");
}
