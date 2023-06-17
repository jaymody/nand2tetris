mod command;
mod parser;

use command::Command;
use parser::parse;

const LCL: u16 = 1;
const ARG: u16 = 2;
const THIS: u16 = 3;
const THAT: u16 = 4;
const TEMP: u16 = 5;
const STATIC: u16 = 16;

struct Translator {
    assembly: String,
    label_counter: u16,
}

/// Translates VM to Assembly.
///
/// For the purposes of documentation:
///
///     D                           (the data register)
///     RAM[addr]                   (the value at address addr in RAM)
///
///     &head   = RAM[SP]           (stack head address)
///     head    = RAM[&head]        (stack head value)
///
///     &local  = RAM[LCL]          (local base address)
///     localN  = RAM[&local + N]   (local value at offset N)
///
///     &arg    = RAM[ARG]          (argument base address)
///     argN    = RAM[&arg + N]     (argument value at offset N)
///
impl Translator {
    /// Creates a new unique label prepended with prefix.
    fn new_label(&mut self, prefix: &str) -> String {
        self.label_counter += 1;
        format!("{prefix}_{}", self.label_counter - 1)
    }

    /// Write a string to the assembly code.
    fn emit(&mut self, s: &str) {
        self.assembly.push_str(s);
        self.assembly.push('\n');
    }

    /// D = val
    fn emit_load_constant(&mut self, val: u16) {
        self.emit(&format!(
            "
            @{val}
            D=A
            ",
        ));
    }

    /// head = D
    /// &head += 1
    fn emit_stack_push(&mut self) {
        self.emit(
            "
            @SP
            A=M
            M=D
            @SP
            M=M+1
            ",
        );
    }

    /// &head -= 1
    /// D = head
    fn emit_stack_pop(&mut self) {
        self.emit(
            "
            @SP
            AM=M-1
            D=M
            ",
        );
    }

    /// head = unary_op head
    fn emit_unary_op(&mut self, op: &str) {
        self.emit(&format!(
            "
            @SP
            A=M-1
            M={op}M
            ",
        ))
    }

    /// head = head binary_op stack.pop()
    fn emit_binary_op(&mut self, op: &str) {
        self.emit_stack_pop();
        self.emit(&format!(
            "
            @SP
            A=M-1
            M={op}
            ",
        ))
    }

    /// if head cmp_op stack.pop()
    ///     head = -1 (aka true)
    /// else
    ///     head = 0  (aka false)
    fn emit_cmp_op(&mut self, op: &str) {
        let set_to_true_label = self.new_label("SET_TO_TRUE");
        let end_comparison_label = self.new_label("END_COMPARISON");

        self.emit_stack_pop();
        self.emit(&format!(
            "
            // D = head - stack.pop()
            @SP
            A=M-1
            D=M-D

            // check condition
            @{set_to_true_label}
            D;{op}

            // condition did not trigger, so set head=false=0
            @SP
            A=M-1
            M=0
            @{end_comparison_label}
            0;JMP

            // condition triggered, so x=true=-1
            ({set_to_true_label})
            @SP
            A=M-1
            M=-1

            ({end_comparison_label})
            ",
        ))
    }

    /// D = RAM[addr]
    fn emit_load_from_addr(&mut self, addr: u16) {
        self.emit(&format!(
            "
            @{addr}
            D=M
            ",
        ))
    }

    /// RAM[addr] = D
    fn emit_save_to_addr(&mut self, addr: u16) {
        self.emit(&format!(
            "
            @{addr}
            M=D
            ",
        ))
    }

    /// D = RAM[RAM[ptr] + offset]
    ///
    /// For example, if we ptr = ARG and offset = 2, then effectively we are doing:
    /// D = arg2
    fn emit_load_from_pointer_offset(&mut self, ptr: u16, offset: u16) {
        self.emit(&format!(
            "
            @{offset}
            D=A
            @{ptr}
            A=D+M
            D=M
            ",
        ))
    }

    /// RAM[RAM[ptr] + offset] = D
    ///
    /// For example, if we ptr = ARG and offset = 2, then effectively we are doing:
    /// arg2 = D
    fn emit_save_to_pointer_offset(&mut self, ptr: u16, offset: u16) {
        self.emit(&format!(
            "
            // R13 = D
            @R13
            M=D

            // R14 = RAM[ptr] + offset
            @{offset}
            D=A
            @{ptr}
            D=D+M
            @R14
            M=D

            // RAM[R14] = R13
            @R13
            D=M
            @R14
            A=M
            M=D
            ",
        ))
    }

    fn emit_command(&mut self, command: Command) {
        match command {
            Command::Operation(op) => match op {
                command::Operation::Add => self.emit_binary_op("D+M"),
                command::Operation::Sub => self.emit_binary_op("M-D"),
                command::Operation::Neg => self.emit_unary_op("-"),
                command::Operation::Eq => self.emit_cmp_op("JEQ"),
                command::Operation::Gt => self.emit_cmp_op("JGT"),
                command::Operation::Lt => self.emit_cmp_op("JLT"),
                command::Operation::And => self.emit_binary_op("D&M"),
                command::Operation::Or => self.emit_binary_op("D|M"),
                command::Operation::Not => self.emit_unary_op("!"),
            },
            Command::Memory(mem) => match mem {
                command::Memory::Push(seg, val) => match seg {
                    command::Segment::Argument => {
                        self.emit_load_from_pointer_offset(ARG, val);
                        self.emit_stack_push();
                    }
                    command::Segment::Local => {
                        self.emit_load_from_pointer_offset(LCL, val);
                        self.emit_stack_push();
                    }
                    command::Segment::Static => {
                        self.emit_load_from_addr(STATIC + val);
                        self.emit_stack_push();
                    }
                    command::Segment::Constant => {
                        self.emit_load_constant(val);
                        self.emit_stack_push();
                    }
                    command::Segment::This => {
                        self.emit_load_from_pointer_offset(THIS, val);
                        self.emit_stack_push();
                    }
                    command::Segment::That => {
                        self.emit_load_from_pointer_offset(THAT, val);
                        self.emit_stack_push();
                    }
                    command::Segment::Pointer => {
                        self.emit_load_from_addr(THIS + val);
                        self.emit_stack_push();
                    }
                    command::Segment::Temp => {
                        self.emit_load_from_addr(TEMP + val);
                        self.emit_stack_push();
                    }
                },
                command::Memory::Pop(seg, val) => match seg {
                    command::Segment::Argument => {
                        self.emit_stack_pop();
                        self.emit_save_to_pointer_offset(ARG, val);
                    }
                    command::Segment::Local => {
                        self.emit_stack_pop();
                        self.emit_save_to_pointer_offset(LCL, val);
                    }
                    command::Segment::Static => {
                        self.emit_stack_pop();
                        self.emit_save_to_addr(STATIC + val);
                    }
                    command::Segment::Constant => {}
                    command::Segment::This => {
                        self.emit_stack_pop();
                        self.emit_save_to_pointer_offset(THIS, val);
                    }
                    command::Segment::That => {
                        self.emit_stack_pop();
                        self.emit_save_to_pointer_offset(THAT, val);
                    }
                    command::Segment::Pointer => {
                        self.emit_stack_pop();
                        self.emit_save_to_addr(THIS + val);
                    }
                    command::Segment::Temp => {
                        self.emit_stack_pop();
                        self.emit_save_to_addr(TEMP + val);
                    }
                },
            },
            Command::Branch(_) => todo!(),
            Command::Function(_) => todo!(),
        }
    }
}

pub fn translate(text: &str) -> String {
    let commands = parse(text);
    let mut translator = Translator {
        assembly: String::new(),
        label_counter: 0,
    };
    for command in commands {
        translator.emit_command(command);
    }
    translator.assembly
}
