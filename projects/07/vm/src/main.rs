enum Command {
    Operation(Operation),
    Memory(Memory),
    Branch(Branch),
    Function(String, u16),
}

enum Operation {
    Add,
    Sub,
    Neg,
    Eq,
    Gt,
    Lt,
    And,
    Or,
    Not,
}

enum Memory {
    Push(Segment, u16),
    Pop(Segment, u16),
}

enum Segment {
    Argument,
    Local,
    Static,
    Constant,
    This,
    That,
    Pointer,
    Temp,
}

enum Branch {
    Label(String),
    Goto(String),
    IfGoto(String),
}

fn remove_comments(s: &str) -> &str {
    s.split_once("//").map(|(s, _)| s).unwrap_or(s)
}

fn translate(text: &str) -> Vec<String> {
    let mut assembly_code = Vec::new();
    for line in text.lines() {
        let command = remove_comments(line).trim();
        if !command.is_empty() {
            assembly_code.push(command.to_string());
        }
    }
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
