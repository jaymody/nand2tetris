use crate::opcode::{OpCode, Segment};

fn remove_comments(s: &str) -> &str {
    s.split_once("//").map(|(s, _)| s).unwrap_or(s)
}

pub fn parse_opcode(line: &str) -> Option<OpCode> {
    let args: Vec<&str> = remove_comments(line).trim().split_whitespace().collect();
    let opcode = match args[..] {
        [] => return None,
        [op] => match op {
            "return" => OpCode::Return,
            "add" => OpCode::Add,
            "sub" => OpCode::Sub,
            "neg" => OpCode::Neg,
            "eq" => OpCode::Eq,
            "gt" => OpCode::Gt,
            "lt" => OpCode::Lt,
            "and" => OpCode::And,
            "or" => OpCode::Or,
            "not" => OpCode::Not,
            _ => panic!("unrecognized opcode {op}"),
        },
        [op, arg] => match op {
            "label" => OpCode::Label(arg.to_string()),
            "goto" => OpCode::Goto(arg.to_string()),
            "if-goto" => OpCode::IfGoto(arg.to_string()),
            _ => panic!("unrecognized opcode {op}"),
        },
        [op, arg1, arg2] => {
            let val: u16 = arg2
                .parse()
                .expect("{arg2} is not a valid 16-bit unsigned integer");

            match op {
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

                    match op {
                        "push" => OpCode::Push(segment, val),
                        "pop" => OpCode::Pop(segment, val),
                        _ => panic!("unreachable"),
                    }
                }
                "function" => OpCode::Function(arg1.to_string(), val),
                "call" => OpCode::Call(arg1.to_string(), val),
                _ => panic!("unrecognized opcode {op}"),
            }
        }
        _ => {
            panic!(
                "opcode must have at most 2 arguments instead {} arguments were found",
                args.len() - 1
            )
        }
    };
    Some(opcode)
}
