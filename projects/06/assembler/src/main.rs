use core::panic;
use lazy_static::lazy_static;
use std::{collections::HashMap, fs};

lazy_static! {
    static ref DEST_TABLE: HashMap<&'static str, &'static str>  = { HashMap::from([
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

    static ref COMP_TABLE: HashMap<&'static str, &'static str>  = { HashMap::from([
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

    static ref JUMP_TABLE: HashMap<&'static str, &'static str>  = { HashMap::from([
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

fn remove_comments(s: String) -> String {
    s.split_once("//")
        .map(|(exp, _)| exp.to_string())
        .unwrap_or(s)
}

fn remove_whitespace(mut s: String) -> String {
    s.retain(|c| !c.is_whitespace());
    s
}

enum Instruction {
    A(String),
    C(String),
}

fn assemble(code: &str) -> String {
    let (instructions, labels) = parse_code(code);
    let machine_code = assemble_instructions(&instructions, &labels);
    let mut output = machine_code.join("\n");
    output.push_str("\n"); // add a final newline so we can directly compare with nand2tetris implementation
    output
}

fn parse_code(code: &str) -> (Vec<Instruction>, HashMap<String, u16>) {
    let mut instructions = Vec::new();
    let mut labels = HashMap::new();

    for line in code.lines() {
        let exp = remove_whitespace(remove_comments(line.to_string()));

        if exp.is_empty() {
            continue;
        }

        if exp.starts_with("(") {
            let label = exp
                .strip_prefix("(")
                .unwrap()
                .strip_suffix(")")
                .expect("( was not closed")
                .to_string();

            if RESERVED_SYMBOLS.contains_key(label.as_str()) {
                panic!(
                    "label ({label}) cannot be one of the reserved symbols {:?}",
                    RESERVED_SYMBOLS.keys()
                );
            }

            if labels.contains_key(label.as_str()) {
                panic!("label ({label}) has already been specified")
            }

            labels.insert(label, instructions.len() as u16);
        } else {
            let instruction = match exp.strip_prefix("@") {
                Some(suffix) => Instruction::A(suffix.to_string()),
                None => Instruction::C(exp),
            };
            instructions.push(instruction);
        }
    }

    (instructions, labels)
}

fn assemble_instructions(
    instructions: &Vec<Instruction>,
    labels: &HashMap<String, u16>,
) -> Vec<String> {
    let mut symbols = HashMap::new();
    instructions
        .into_iter()
        .map(|instruction| assemble_instruction(instruction, labels, &mut symbols))
        .collect()
}

fn assemble_instruction(
    instruction: &Instruction,
    labels: &HashMap<String, u16>,
    symbols: &mut HashMap<String, u16>,
) -> String {
    match instruction {
        Instruction::A(s) => assemble_a_instruction(s, labels, symbols),
        Instruction::C(s) => assemble_c_instruction(s),
    }
}

fn assemble_a_instruction(
    s: &str,
    labels: &HashMap<String, u16>,
    symbols: &mut HashMap<String, u16>,
) -> String {
    let val = match s.parse::<u16>() {
        Ok(num) => num,
        Err(_) => match RESERVED_SYMBOLS.get(s) {
            Some(num) => *num,
            None => match labels.get(s) {
                Some(num) => *num,
                None => match symbols.get(s) {
                    Some(num) => *num,
                    None => {
                        let i = symbols.len() as u16 + 16;
                        symbols.insert(s.to_string(), i);
                        i
                    }
                },
            },
        },
    };

    format!("0{:015b}", val)
}

fn assemble_c_instruction(s: &str) -> String {
    // get c instruction expression components
    let (dest_exp, rest) = s.split_once("=").unwrap_or(("", &s));
    let (comp_exp, jump_exp) = rest.split_once(";").unwrap_or((rest, ""));

    // map expressions to their corresponding machine code
    let dest_code = DEST_TABLE.get(dest_exp).expect(&format!(
        "invalid dest expression: {dest_exp}\nmust be one of {:?}",
        DEST_TABLE.keys()
    ));
    let jump_code = JUMP_TABLE.get(jump_exp).expect(&format!(
        "invalid jump expression: {jump_exp}\nmust be one of {:?}",
        JUMP_TABLE.keys()
    ));
    let comp_code = COMP_TABLE.get(comp_exp).expect(&format!(
        "invalid comp expression: {comp_exp}\nmust be one of {:?}",
        COMP_TABLE.keys()
    ));

    format!("111{}{}{}", comp_code, dest_code, jump_code)
}

fn main() {
    let infile = std::env::args().nth(1).expect("no filename given");
    let mut outfile = infile
        .strip_suffix(".asm")
        .expect("filename must end in .asm")
        .to_string();
    outfile.push_str(".hack");

    let code = std::fs::read_to_string(infile).unwrap();
    let output = assemble(&code);

    fs::write(outfile, output).unwrap();
}
