mod command;
mod parser;

use command::Command;
use parser::parse;

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
                    command::Segment::Argument => todo!(),
                    command::Segment::Local => todo!(),
                    command::Segment::Static => todo!(),
                    command::Segment::Constant => {
                        self.emit_load_constant(val);
                        self.emit_stack_push();
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
