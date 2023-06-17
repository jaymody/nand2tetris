use assembler::translate;

fn main() {
    let infile = std::env::args().nth(1).expect("no filename given");
    let mut outfile = infile
        .strip_suffix(".asm")
        .expect("filename must end in .asm")
        .to_string();
    outfile.push_str(".hack");

    let text = std::fs::read_to_string(infile).unwrap();
    let machine_code = translate(&text);

    let mut output = machine_code.join("\n");
    output.push('\n'); // add a final newline so we can directly compare with nand2tetris implementation

    std::fs::write(outfile, output).unwrap();
}
