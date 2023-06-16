use core::panic;
use lazy_static::lazy_static;
use std::{collections::HashMap, fs};

type StrMap = HashMap<&'static str, &'static str>;

lazy_static! {
    static ref DEST_TABLE: StrMap  = { HashMap::from([
        // no destination
        ("", "000"),
        // just M
        ("M", "001"),
        // just D
        ("D", "010"),
        // M and D
        ("MD", "011"),
        ("DM", "011"),
        // just A
        ("A", "100"),
        // A and M
        ("AM", "101"),
        ("MA", "101"),
        // A and D
        ("AD", "110"),
        ("DA", "110"),
        // A, M, and D
        ("ADM", "111"),
        ("AMD", "111"),
        ("DAM", "111"),
        ("DMA", "111"),
        ("MAD", "111"),
        ("MDA", "111"),
    ])};

    static ref COMP_TABLE: StrMap  = { HashMap::from([
        // constants
        ("0", "0101010"),
        ("1", "0111111"),
        ("-1", "0111010"),
        // pass through value
        ("D", "0001100"),
        ("A", "0110000"),
        ("M", "1110000"),
        // bitwise NOT
        ("!D", "0001101"),
        ("!A", "0110001"),
        ("!M", "1110001"),
        // negation
        ("-D", "0001111"),
        ("-A", "0110011"),
        ("-M", "1110011"),
        // increment
        ("D+1", "0011111"),
        ("A+1", "0110111"),
        ("M+1", "1110111"),
        // decrement
        ("D-1", "0001110"),
        ("A-1", "0110010"),
        ("M-1", "1110010"),
        // addition
        ("D+A", "0000010"),
        ("A+D", "0000010"),
        ("D+M", "1000010"),
        ("M+D", "1000010"),
        // subtraction
        ("D-A", "0010011"),
        ("A-D", "0000111"),
        ("D-M", "1010011"),
        ("M-D", "1000111"),
        // bitwise AND
        ("D&A", "0000000"),
        ("A&D", "0000000"),
        ("D&M", "1000000"),
        ("M&D", "1000000"),
        // bitwise OR
        ("D|A", "0010101"),
        ("A|D", "0010101"),
        ("D|M", "1010101"),
        ("M|D", "1010101"),
    ])};

    static ref JUMP_TABLE: StrMap  = { HashMap::from([
        ("", "000"),    // no jump
        ("JGT", "001"), // > 0
        ("JEQ", "010"), // = 0
        ("JGE", "011"), // ≥ 0
        ("JLT", "100"), // < 0
        ("JNE", "101"), // ≠ 0
        ("JLE", "110"), // ≤ 0
        ("JMP", "111"), // always jump
    ])};

    static ref RESERVED_SYMBOLS: HashMap<&'static str, u16>  = { HashMap::from([
        // special symbols
        ("SP", 0),
        ("LCL", 1),
        ("ARG", 2),
        ("THIS", 3),
        ("THAT", 4),
        // registers
        ("R0", 0),
        ("R1", 1),
        ("R2", 2),
        ("R3", 3),
        ("R4", 4),
        ("R5", 5),
        ("R6", 6),
        ("R7", 7),
        ("R8", 8),
        ("R9", 9),
        ("R10", 10),
        ("R11", 11),
        ("R12", 12),
        ("R13", 13),
        ("R14", 14),
        ("R15", 15),
        // io devices memory map start addresses
        ("SCREEN", 16384),
        ("KBD", 24576),
    ])};
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

fn get_command(line: &str) -> Option<Command> {
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

fn assemble(text: &str) -> Vec<String> {
    let mut instructions = Vec::new();
    let mut labels = HashMap::new();

    for line in text.lines() {
        if let Some(command) = get_command(line) {
            match command {
                Command::Label(label) => {
                    if RESERVED_SYMBOLS.contains_key(label.as_str()) {
                        panic!(
                            "label ({label}) cannot be one of the reserved symbols {:?}",
                            RESERVED_SYMBOLS.keys()
                        );
                    }
                    if labels.contains_key(label.as_str()) {
                        panic!("label ({label}) has already been specified");
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
            Command::C(s) => assemble_c_instruction(s.as_str()),
            Command::A(s) => assemble_a_instruction(s.as_str(), &labels, &mut symbols),
            Command::Label(_) => panic!("this should be impossible"),
        })
        .collect()
}

fn assemble_a_instruction(
    s: &str,
    labels: &HashMap<String, u16>,
    symbols: &mut HashMap<String, u16>,
) -> String {
    // either s is a number, in which case we just parse it
    let val = s.parse().unwrap_or_else(|_| {
        // or its in our table of reserved symbols
        *RESERVED_SYMBOLS.get(s).unwrap_or_else(|| {
            // or its in our table of labels
            labels.get(s).unwrap_or_else(|| {
                // or its in our table of symbols, else we make a new entry
                let location = symbols.len() as u16 + 16;
                symbols.entry(s.to_string()).or_insert(location)
            })
        })
    });

    format!("0{:015b}", val)
}

fn assemble_c_instruction(s: &str) -> String {
    let (dest_exp, rest) = s.split_once('=').unwrap_or(("", s));
    let (comp_exp, jump_exp) = rest.split_once(';').unwrap_or((rest, ""));

    fn exp_to_machine_code<'a>(name: &'a str, exp: &'a str, table: &'a StrMap) -> &'a str {
        table.get(exp).unwrap_or_else(|| {
            panic!(
                "invalid {name} expression: {exp}\nmust be one of {:?}",
                table.keys()
            )
        })
    }
    let dest_code = exp_to_machine_code("dest", dest_exp, &DEST_TABLE);
    let comp_code = exp_to_machine_code("comp", comp_exp, &COMP_TABLE);
    let jump_code = exp_to_machine_code("jump", jump_exp, &JUMP_TABLE);

    format!("111{}{}{}", comp_code, dest_code, jump_code)
}

fn main() {
    let infile = std::env::args().nth(1).expect("no filename given");
    let mut outfile = infile
        .strip_suffix(".asm")
        .expect("filename must end in .asm")
        .to_string();
    outfile.push_str(".hack");

    let text = std::fs::read_to_string(infile).unwrap();
    let machine_code = assemble(&text);

    let mut output = machine_code.join("\n");
    output.push('\n'); // add a final newline so we can directly compare with nand2tetris implementation

    fs::write(outfile, output).unwrap();
}
