#[derive(Debug)]
enum Command {
    Operation(Operation),
    Memory(Memory),
    Branch(Branch),
    Function(Function),
}

#[derive(Debug)]
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

#[derive(Debug)]
enum Memory {
    Push(Segment, u16),
    Pop(Segment, u16),
}

#[derive(Debug)]
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

#[derive(Debug)]
enum Branch {
    Label(String),
    Goto(String),
    IfGoto(String),
}

#[derive(Debug)]
enum Function {
    Function(String, u16),
    Call(String, u16),
    Return,
}

fn remove_comments(s: &str) -> &str {
    s.split_once("//").map(|(s, _)| s).unwrap_or(s)
}

fn get_command(command_str: &str) -> Command {
    let args: Vec<&str> = command_str.split_whitespace().collect();
    match args[..] {
        [] => panic!("command_str must be non-empty (whitespace is considered empty)"),
        [cmd] => match cmd {
            "return" => Command::Function(Function::Return),
            "add" => Command::Operation(Operation::Add),
            "sub" => Command::Operation(Operation::Sub),
            "neg" => Command::Operation(Operation::Neg),
            "eq" => Command::Operation(Operation::Eq),
            "gt" => Command::Operation(Operation::Gt),
            "lt" => Command::Operation(Operation::Lt),
            "and" => Command::Operation(Operation::And),
            "or" => Command::Operation(Operation::Or),
            "not" => Command::Operation(Operation::Not),
            _ => panic!("unrecognized command {cmd}"),
        },
        [cmd, arg] => match cmd {
            "label" => Command::Branch(Branch::Label(arg.to_string())),
            "goto" => Command::Branch(Branch::Goto(arg.to_string())),
            "if-goto" => Command::Branch(Branch::IfGoto(arg.to_string())),
            _ => panic!("unrecognized command {cmd}"),
        },
        [cmd, arg1, arg2] => {
            let val: u16 = arg2
                .parse()
                .expect("{arg2} is not a valid 16-bit unsigned integer");

            match cmd {
                "push" | "pop" => {
                    let segment = match arg1 {
                        "argument" => Segment::Argument,
                        "local" => Segment::Local,
                        "static" => Segment::Static,
                        "constant" => Segment::Constant,
                        "this" => Segment::This,
                        "that" => Segment::That,
                        "pointer" => Segment::Pointer,
                        "temp" => Segment::Temp,
                        _ => panic!("{arg1} is not a valid segment identifier"),
                    };

                    match cmd {
                        "push" => Command::Memory(Memory::Push(segment, val)),
                        "pop" => Command::Memory(Memory::Pop(segment, val)),
                        _ => panic!("unreachable"),
                    }
                }
                "function" => Command::Function(Function::Function(arg1.to_string(), val)),
                "call" => Command::Function(Function::Call(arg1.to_string(), val)),
                _ => panic!("unrecognized command {cmd}"),
            }
        }
        _ => {
            panic!(
                "command must have at most 2 arguments instead {} arguments were found",
                args.len() - 1
            )
        }
    }
}

fn translate(text: &str) -> Vec<String> {
    let mut assembly_code = Vec::new();

    for line in text.lines() {
        let command_str = remove_comments(line).trim();
        if command_str.is_empty() {
            continue;
        }
        let command = get_command(command_str);
        assembly_code.push(format!("{:?}", command));
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
