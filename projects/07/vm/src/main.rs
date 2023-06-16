use parser::parse;

mod command;
mod parser;

fn translate(text: &str) -> Vec<String> {
    let commands = parse(text);
    let assembly_code = commands.into_iter().map(|c| format!("{:?}", c)).collect();
    assembly_code
}

fn main() {
    let infile = std::env::args().nth(1).expect("no filename given");
    let mut outfile = infile
        .strip_suffix(".vm")
        .expect("filename must end in .vm")
        .to_string();
    outfile.push_str(".asm");

    let text = std::fs::read_to_string(infile).unwrap();
    let assembly_code = translate(&text);

    let output = assembly_code.join("\n");
    std::fs::write(outfile, output).unwrap();
}
