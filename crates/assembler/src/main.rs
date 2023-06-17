use assembler::{assemble, parse};

fn main() {
    let infile = std::env::args().nth(1).expect("no filename given");
    let mut outfile = infile
        .strip_suffix(".asm")
        .expect("filename must end in .asm")
        .to_string();
    outfile.push_str(".hack");

    let text = std::fs::read_to_string(infile).unwrap();
    let instructions = parse(&text);
    let mut machine_code = assemble(instructions);
    machine_code.push('\n'); // add a final newline so we can directly compare with nand2tetris implementation

    std::fs::write(outfile, machine_code).unwrap();
}
