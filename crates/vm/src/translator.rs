use crate::opcode::{OpCode, Segment};

const LCL: u16 = 1;
const ARG: u16 = 2;
const THIS: u16 = 3;
const THAT: u16 = 4;
const TEMP: u16 = 5;
const STATIC: u16 = 16;

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
pub struct Translator {
    assembly: String,
    cmp_counter: u16,
    current_function_name: String,
}

impl Translator {
    /// Get full label from name.
    fn get_label(&mut self, name: &str) -> String {
        format!("{}_{}", self.current_function_name, name)
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
        let cmp_counter = self.cmp_counter;
        self.cmp_counter += 1;

        self.emit_stack_pop();
        self.emit(&format!(
            "
            // D = head - stack.pop()
            @SP
            A=M-1
            D=M-D

            // check condition
            @SET_TO_TRUE_{cmp_counter}
            D;{op}

            // condition did not trigger, so set head=false=0
            @SP
            A=M-1
            M=0
            @END_COMPARISON_{cmp_counter}
            0;JMP

            // condition triggered, so x=true=-1
            (SET_TO_TRUE_{cmp_counter})
            @SP
            A=M-1
            M=-1

            (END_COMPARISON_{cmp_counter})
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

    // Emits the label.
    fn emit_label(&mut self, label: &str) {
        self.emit(&format!(
            "
            ({label})
            ",
        ));
    }

    // Jumps to the label.
    fn emit_goto_label(&mut self, label: &str) {
        self.emit(&format!(
            "
            @{label}
            0;JMP
            ",
        ));
    }

    // Jumps to the label if stack.pop() != 0
    fn emit_if_goto_label(&mut self, label: &str) {
        self.emit_stack_pop();
        self.emit(&format!(
            "
            @{label}
            D;JNE
            ",
        ));
    }

    fn emit_opcode(&mut self, opcode: OpCode) {
        match opcode {
            OpCode::Add => self.emit_binary_op("D+M"),
            OpCode::Sub => self.emit_binary_op("M-D"),
            OpCode::Neg => self.emit_unary_op("-"),
            OpCode::Eq => self.emit_cmp_op("JEQ"),
            OpCode::Gt => self.emit_cmp_op("JGT"),
            OpCode::Lt => self.emit_cmp_op("JLT"),
            OpCode::And => self.emit_binary_op("D&M"),
            OpCode::Or => self.emit_binary_op("D|M"),
            OpCode::Not => self.emit_unary_op("!"),
            OpCode::Push(seg, val) => {
                match seg {
                    Segment::Argument => self.emit_load_from_pointer_offset(ARG, val),
                    Segment::Local => self.emit_load_from_pointer_offset(LCL, val),
                    Segment::Static => self.emit_load_from_addr(STATIC + val),
                    Segment::Constant => self.emit_load_constant(val),
                    Segment::This => self.emit_load_from_pointer_offset(THIS, val),
                    Segment::That => self.emit_load_from_pointer_offset(THAT, val),
                    Segment::Pointer => self.emit_load_from_addr(THIS + val),
                    Segment::Temp => self.emit_load_from_addr(TEMP + val),
                };
                self.emit_stack_push();
            }
            OpCode::Pop(seg, val) => {
                self.emit_stack_pop();
                match seg {
                    Segment::Argument => self.emit_save_to_pointer_offset(ARG, val),
                    Segment::Local => self.emit_save_to_pointer_offset(LCL, val),
                    Segment::Static => self.emit_save_to_addr(STATIC + val),
                    Segment::Constant => (),
                    Segment::This => self.emit_save_to_pointer_offset(THIS, val),
                    Segment::That => self.emit_save_to_pointer_offset(THAT, val),
                    Segment::Pointer => self.emit_save_to_addr(THIS + val),
                    Segment::Temp => self.emit_save_to_addr(TEMP + val),
                }
            }
            OpCode::Label(name) => {
                let label = self.get_label(&name);
                self.emit_label(&label);
            }
            OpCode::Goto(name) => {
                let label = self.get_label(&name);
                self.emit_goto_label(&label);
            }
            OpCode::IfGoto(name) => {
                let label = self.get_label(&name);
                self.emit_if_goto_label(&label);
            }
            OpCode::Function(_, _) => todo!(),
            OpCode::Call(_, _) => todo!(),
            OpCode::Return => todo!(),
        }
    }

    pub fn translate(opcodes: Vec<OpCode>) -> String {
        let mut translator = Translator {
            assembly: String::new(),
            cmp_counter: 0,
            current_function_name: "main".to_string(),
        };

        for opcode in opcodes {
            translator.emit_opcode(opcode);
        }

        translator.assembly
    }
}
