use core::panic;
use std::collections::HashMap;

fn remove_comments(s: String) -> String {
    s.split_once("//")
        .map(|(exp, _)| exp.to_string())
        .unwrap_or(s)
}

fn remove_whitespace(mut s: String) -> String {
    s.retain(|c| !c.is_whitespace());
    s
}

struct Assembler<'a> {
    dest_table: HashMap<&'a str, &'a str>,
    comp_table: HashMap<&'a str, &'a str>,
    jump_table: HashMap<&'a str, &'a str>,
    reserved_symbols: HashMap<&'a str, u16>,
}

enum Instruction {
    ALiteral(u16),
    ASymbol(String),
    C(String),
}

impl<'a> Assembler<'a> {
    pub fn new() -> Self {
        let dest_table = HashMap::from([
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
        ]);

        let comp_table = HashMap::from([
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
        ]);

        let jump_table = HashMap::from([
            ("", "000"),    // no jump
            ("JGT", "001"), // > 0
            ("JEQ", "010"), // = 0
            ("JGE", "011"), // ≥ 0
            ("JLT", "100"), // < 0
            ("JNE", "101"), // ≠ 0
            ("JLE", "110"), // ≤ 0
            ("JMP", "111"), // always jump
        ]);

        let reserved_symbols = HashMap::from([
            ("SP", 0),
            ("LCL", 1),
            ("ARG", 2),
            ("THIS", 3),
            ("THAT", 4),
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
            ("SCREEN", 16384),
            ("KBD", 24576),
        ]);

        Self {
            dest_table,
            comp_table,
            jump_table,
            reserved_symbols,
        }
    }

    fn assemble(code: &str) -> Vec<String> {
        // initialize assembler
        let assembler = Assembler::new();

        // first pass over the code to parse it into a list of instructions and
        // a list of named symbols that refer to instruction/memory locations
        let (instructions, symbols) = assembler.parse_code(code);

        // second pass over the code to assembles the actual instructions
        let machine_code = assembler.assemble_instructions(&instructions, &symbols);

        machine_code
    }

    fn parse_code(&self, code: &str) -> (Vec<Instruction>, HashMap<String, u16>) {
        let mut instructions = Vec::new();
        let mut symbols = HashMap::new();
        let mut symbol_counter: u16 = 16;

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
                if self.reserved_symbols.contains_key(label.as_str()) {
                    panic!(
                        "label ({label}) cannot be one of the reserved symbols {:?}",
                        self.reserved_symbols.keys()
                    );
                }
                symbols.insert(label, instructions.len() as u16);
            } else {
                let instruction = match exp.strip_prefix("@") {
                    Some(k) => match k.parse::<u16>() {
                        Ok(val) => Instruction::ALiteral(val),
                        Err(_) => match self.reserved_symbols.get(k) {
                            Some(val) => Instruction::ALiteral(*val),
                            None => {
                                if !symbols.contains_key(k) {
                                    symbols.insert(k.to_string(), symbol_counter);
                                    symbol_counter += 1;
                                }
                                Instruction::ASymbol(k.to_string())
                            }
                        },
                    },
                    None => Instruction::C(exp),
                };
                instructions.push(instruction);
            }
        }

        (instructions, symbols)
    }

    fn assemble_instructions(
        &self,
        instructions: &Vec<Instruction>,
        symbols: &HashMap<String, u16>,
    ) -> Vec<String> {
        instructions
            .into_iter()
            .map(|instruction| self.assemble_instruction(instruction, symbols))
            .collect()
    }

    fn assemble_instruction(
        &self,
        instruction: &Instruction,
        symbols: &HashMap<String, u16>,
    ) -> String {
        match instruction {
            Instruction::ALiteral(val) => format!("0{:015b}", val),
            Instruction::ASymbol(name) => {
                format!("0{:015b}", symbols.get(&name.to_string()).unwrap())
            }
            Instruction::C(exp) => self.assemble_c_expression(exp),
        }
    }

    fn assemble_c_expression(&self, exp: &str) -> String {
        // get c instruction expression components
        let (dest_exp, rest) = exp.split_once("=").unwrap_or(("", &exp));
        let (comp_exp, jump_exp) = rest.split_once(";").unwrap_or((rest, ""));

        // map expressions to their corresponding machine code
        let dest_code = self.dest_table.get(dest_exp).expect(&format!(
            "invalid dest expression: {dest_exp}\nmust be one of {:?}",
            self.dest_table.keys()
        ));
        let jump_code = self.jump_table.get(jump_exp).expect(&format!(
            "invalid jump expression: {jump_exp}\nmust be one of {:?}",
            self.jump_table.keys()
        ));
        let comp_code = self.comp_table.get(comp_exp).expect(&format!(
            "invalid comp expression: {comp_exp}\nmust be one of {:?}",
            self.comp_table.keys()
        ));

        format!("111{}{}{}", comp_code, dest_code, jump_code)
    }
}

fn main() {
    let filename = std::env::args().nth(1).expect("no filename given");
    let code = std::fs::read_to_string(filename).unwrap();
    let machine_code = Assembler::assemble(&code);
    for code in machine_code {
        println!("{code}");
    }
}
