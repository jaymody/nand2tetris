mod command;
mod parser;

use command::Command;
use parser::parse;

struct CodeGenerator {
    assembly: String,
    label_counter: u16,
}

impl CodeGenerator {
    pub fn new() -> Self {
        let mut assembler = Self {
            assembly: String::new(),
            label_counter: 0,
        };
        // initialize SP to point to 256
        assembler.emit_load_constant(256);
        assembler.emit(
            "
            @SP
            M=D
            ",
        );
        assembler
    }

    fn new_label(&mut self, s: &str) -> String {
        self.label_counter += 1;
        format!("{s}_{}", self.label_counter - 1)
    }

    pub fn assembly(self) -> String {
        self.assembly
    }

    pub fn emit(&mut self, s: &str) {
        self.assembly.push_str(s);
        self.assembly.push('\n');
    }

    pub fn emit_load_constant(&mut self, val: u16) {
        self.emit(&format!(
            "
            //// load constant ////
            @{val}
            D=A
            ",
        ));
    }

    // pub fn emit_load_memory(&mut self, loc: u16) {
    //     self.emit(&format!(
    //         "
    //         //// load memory ////
    //         @{loc}
    //         D=A
    //         ",
    //     ));
    // }

    pub fn emit_stack_push(&mut self) {
        self.emit(
            "
            //// push to stack ////
            @SP
            A=M
            M=D
            @SP
            M=M+1
            ",
        );
    }

    pub fn emit_stack_pop(&mut self) {
        self.emit(
            "
            //// pop stack ///
            @SP
            AM=M-1
            D=M
            ",
        );
    }

    pub fn emit_unary_op(&mut self, op: &str) {
        self.emit(&format!(
            "
            //// apply unary op to stack head ////
            @SP
            A=M-1
            M={op}M
            ",
        ))
    }

    pub fn emit_binary_op(&mut self, op: &str) {
        self.emit_stack_pop();
        self.emit(&format!(
            "
            //// apply binary op to stack head and D ////
            @SP
            A=M-1
            M={op}
            ",
        ))
    }

    pub fn emit_cmp_op(&mut self, op: &str) {
        let set_to_true_label = self.new_label("SET_TO_TRUE");
        let end_comparison_label = self.new_label("END_COMPARISON");

        self.emit_stack_pop();
        self.emit(&format!(
            "
            //// perform comparison on stack head and D ////
            // if the comparison is true stack is set to = -1 else 0

            // D=x-y
            @SP
            A=M-1
            D=M-D

            // check condition
            @{set_to_true_label}
            D;{op}

            // condition did not trigger, so x=false (x=0)
            @SP
            A=M-1
            M=0
            @{end_comparison_label}
            0;JMP

            // condition triggered, so x=true (x=-1)
            ({set_to_true_label})
            @SP
            A=M-1
            M=-1

            ({end_comparison_label})
            ",
        ))
    }
}

pub fn translate(text: &str) -> String {
    let mut codegen = CodeGenerator::new();
    let commands = parse(text);

    for command in commands {
        match command {
            Command::Operation(op) => match op {
                command::Operation::Add => codegen.emit_binary_op("D+M"),
                command::Operation::Sub => codegen.emit_binary_op("M-D"),
                command::Operation::Neg => codegen.emit_unary_op("-"),
                command::Operation::Eq => codegen.emit_cmp_op("JEQ"),
                command::Operation::Gt => codegen.emit_cmp_op("JGT"),
                command::Operation::Lt => codegen.emit_cmp_op("JLT"),
                command::Operation::And => codegen.emit_binary_op("D&M"),
                command::Operation::Or => codegen.emit_binary_op("D|M"),
                command::Operation::Not => codegen.emit_unary_op("!"),
            },
            Command::Memory(mem) => match mem {
                command::Memory::Push(seg, val) => match seg {
                    command::Segment::Argument => todo!(),
                    command::Segment::Local => todo!(),
                    command::Segment::Static => todo!(),
                    command::Segment::Constant => {
                        codegen.emit_load_constant(val);
                        codegen.emit_stack_push();
                    }
                    command::Segment::This => todo!(),
                    command::Segment::That => todo!(),
                    command::Segment::Pointer => todo!(),
                    command::Segment::Temp => todo!(),
                },
                command::Memory::Pop(_, _) => todo!(),
            },
            Command::Branch(_) => todo!(),
            Command::Function(_) => todo!(),
        }
    }

    codegen.assembly()
}
