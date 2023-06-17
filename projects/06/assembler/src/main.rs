use core::panic;
use std::{collections::HashMap, fs, str::FromStr};

macro_rules! create_enum {
    ($enumName:ident, $($name:ident => $num:expr => $str:expr),*,) => {
        enum $enumName {
            $($name = $num),*
        }

        impl FromStr for $enumName {
            type Err = String;

            fn from_str(s: &str) -> Result<Self, Self::Err> {
                match s {
                    $($str => Ok(Self::$name),)*
                    _ => Err(format!("unrecognized $enumName expression {s}")),
                }
            }
        }

        impl ToString for $enumName {
            fn to_string(&self) -> String {
                match self {
                    $(Self::$name => $str.to_string(),)*
                }
            }
        }
    };
}

create_enum!(
    Dest,
    NoDest => 0b000 => "",
    M => 0b001 => "M",
    D => 0b010 => "D",
    MD => 0b011 => "MD",
    A => 0b100 => "A",
    AM => 0b101 => "AM",
    AD => 0b110 => "AD",
    AMD => 0b1111 => "AMD",
);

create_enum!(
    Jump,
    NoJump => 0b000 => "",  // no jump
    JGT => 0b001 => "JGT",  // > 0
    JEQ => 0b010 => "JEQ",  // = 0
    JGE => 0b011 => "JGE",  // ≥ 0
    JLT => 0b100 => "JLT",  // < 0
    JNE => 0b101 => "JNE",  // ≠ 0
    JLE => 0b110 => "JLE",  // ≤ 0
    JMP => 0b111 => "JMP",  // always jump
);

create_enum!(
    Comp,
    // constants
    Zero => 0b0101010 => "0",
    One => 0b0111111 => "1",
    NegOne => 0b0111010 => "-1",
    // identity
    D => 0b0001100 => "D",
    A => 0b0110000 => "A",
    M => 0b1110000 => "M",
    // bitwise NOT
    NotD => 0b0001101 => "!D",
    NotA => 0b0110001 => "!A",
    NotM => 0b1110001 => "!M",
    // negation
    NegD => 0b0001111 => "-D",
    NegA => 0b0110011 => "-A",
    NegM => 0b1110011 => "-M",
    // increment
    IncD => 0b0011111 => "D+1",
    IncA => 0b0110111 => "A+1",
    IncM => 0b1110111 => "M+1",
    // decrement
    DecD => 0b0001110 => "D-1",
    DecA => 0b0110010 => "A-1",
    DecM => 0b1110010 => "M-1",
    // addition
    AddA => 0b0000010 => "D+A",
    AddM => 0b1000010 => "D+M",
    // subtraction
    SubDA => 0b0010011 => "D-A",
    SubAD => 0b0000111 => "A-D",
    SubDM => 0b1010011 => "D-M",
    SubMD => 0b1000111 => "M-D",
    // bitwise AND
    AndA => 0b0000000 => "D&A",
    AndD => 0b1000000 => "D&M",
    // bitwise OR
    OrA => 0b0010101 => "D|A",
    OrD => 0b1010101 => "D|M",
);

fn reserved_symbol_lookup(s: &str) -> Option<u16> {
    match s {
        // special symbols
        "SP" => Some(0),
        "LCL" => Some(1),
        "ARG" => Some(2),
        "THIS" => Some(3),
        "THAT" => Some(4),
        // registers
        "R0" => Some(0),
        "R1" => Some(1),
        "R2" => Some(2),
        "R3" => Some(3),
        "R4" => Some(4),
        "R5" => Some(5),
        "R6" => Some(6),
        "R7" => Some(7),
        "R8" => Some(8),
        "R9" => Some(9),
        "R10" => Some(10),
        "R11" => Some(11),
        "R12" => Some(12),
        "R13" => Some(13),
        "R14" => Some(14),
        "R15" => Some(15),
        // io devices memory map start addresses
        "SCREEN" => Some(16384),
        "KBD" => Some(24576),
        // no match found
        _ => None,
    }
}

enum Command {
    Label(String),
    A(String),
    C(String),
}

fn remove_comments(s: String) -> String {
    s.split_once("//").map(|(s, _)| s.to_string()).unwrap_or(s)
}

fn remove_whitespace(mut s: String) -> String {
    s.retain(|c| !c.is_whitespace());
    s
}

fn parse_command(line: &str) -> Option<Command> {
    let mut line = line.to_string();
    line = remove_comments(line);
    line = remove_whitespace(line);

    if line.is_empty() {
        return None;
    }

    let command = match line.split_at(1) {
        ("(", s) => Command::Label(s.strip_suffix(')').expect("( was not closed").to_string()),
        ("@", s) => Command::A(s.to_string()),
        _ => Command::C(line),
    };

    Some(command)
}

fn translate(text: &str) -> Vec<String> {
    let mut instructions = Vec::new();
    let mut labels = HashMap::new();

    for line in text.lines() {
        if let Some(command) = parse_command(line) {
            match command {
                Command::Label(label) => {
                    if reserved_symbol_lookup(label.as_str()).is_some() {
                        panic!("label ({label}) is a reserved symbol");
                    }
                    if labels.contains_key(label.as_str()) {
                        panic!("label ({label}) has already been used");
                    }
                    labels.insert(label, instructions.len() as u16);
                }
                _ => instructions.push(command),
            };
        };
    }

    let mut symbols = HashMap::new();
    instructions
        .into_iter()
        .map(|instruction| match instruction {
            Command::C(s) => translate_c_instruction(s.as_str()),
            Command::A(s) => translate_a_instruction(s.as_str(), &labels, &mut symbols),
            Command::Label(_) => panic!("this should be impossible"),
        })
        .collect()
}

fn translate_a_instruction(
    s: &str,
    labels: &HashMap<String, u16>,
    symbols: &mut HashMap<String, u16>,
) -> String {
    // either s is a number, in which case we just parse it
    let val = s.parse().unwrap_or_else(|_| {
        // or its in our table of reserved symbols
        reserved_symbol_lookup(s).unwrap_or_else(|| {
            // or its in our table of labels
            *labels.get(s).unwrap_or_else(|| {
                // or its in our table of symbols, else we make a new entry
                let location = symbols.len() as u16 + 16;
                symbols.entry(s.to_string()).or_insert(location)
            })
        })
    });

    format!("0{:015b}", val)
}

fn translate_c_instruction(s: &str) -> String {
    let (dest_exp, rest) = s.split_once('=').unwrap_or(("", s));
    let (comp_exp, jump_exp) = rest.split_once(';').unwrap_or((rest, ""));

    let dest_code = Dest::from_str(dest_exp).unwrap() as u16;
    let comp_code = Comp::from_str(comp_exp).unwrap() as u16;
    let jump_code = Jump::from_str(jump_exp).unwrap() as u16;

    format!("111{:07b}{:03b}{:03b}", comp_code, dest_code, jump_code)
}

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

    fs::write(outfile, output).unwrap();
}
