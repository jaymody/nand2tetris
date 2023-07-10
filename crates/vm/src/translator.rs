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
///     &head       = RAM[SP]           (stack head address)
///     head        = RAM[&head]        (stack head value)
///
///     &local      = RAM[LCL]          (local base address)
///     local[N]    = RAM[&local + N]   (local value at offset N)
///
///     &arg        = RAM[ARG]          (argument base address)
///     arg[N]      = RAM[&arg + N]     (argument value at offset N)
///
pub struct Translator {
    // Running assembly code.
    assembly: String,

    // Counter for labels used in the emit_cmp_op function that ensures the
    // labels are unique.
    unique_label_id_counter: u16,

    // Name of the current executing function.
    current_function_name: String,
}

impl Translator {
    pub fn init(sys_init: bool) -> Translator {
        let mut translator = Translator {
            assembly: String::new(),
            unique_label_id_counter: 0,
            current_function_name: "Sys.init".to_string(),
        };

        translator.emit(
            "
            @256
            D=A
            @SP
            M=D
            ",
        );
        if sys_init {
            translator.emit(
                "
                @Sys.init
                0;JMP
                ",
            )
        }

        translator
    }

    pub fn assembly(self) -> String {
        self.assembly
    }

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
        let unique_id = self.unique_label_id_counter;
        self.unique_label_id_counter += 1;

        self.emit_stack_pop();
        self.emit(&format!(
            "
            // D = head - stack.pop()
            @SP
            A=M-1
            D=M-D

            // check condition
            @SET_TO_TRUE_{unique_id}
            D;{op}

            // condition did not trigger, so set head=false=0
            @SP
            A=M-1
            M=0
            @END_COMPARISON_{unique_id}
            0;JMP

            // condition triggered, so x=true=-1
            (SET_TO_TRUE_{unique_id})
            @SP
            A=M-1
            M=-1

            (END_COMPARISON_{unique_id})
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

    pub fn emit_opcode(&mut self, opcode: OpCode) {
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
            OpCode::Function(name, nlocals) => {
                // The basic logic is as follows:
                //
                //  1) Emit a label using name as the value, so we can call our
                //     function with goto name.
                //
                //  2) Initialize the local block to 0s:
                //
                //      for i in 0..nlocals
                //          local[i] = 0
                //
                //  3) Set the stack pointer to point to the address right after
                //     the end of the local block:
                //
                //      &head = &local + nlocals

                // 1) Emit the label.
                self.emit_label(&name);

                // 2) Initialize local vars to 0.
                //
                // NOTE: We do this instead of reusing the logic for
                // 'push constant 0' because that would result in
                // (2 + 5) * nlocals instructions (2 for setting D=0
                // and 5 for pushing to the stack) while this approach only
                // takes 2 * nlocals + 4 instructions.
                self.emit(
                    "
                    @LCL
                    A=M
                    ",
                );
                for _ in 0..nlocals {
                    self.emit(
                        "
                        M=0
                        AD=A+1
                        ",
                    )
                }

                // 3) Set stack pointer to point to the end of the nlocals block.
                self.emit(
                    "
                    @SP
                    M=D
                    ",
                );
            }
            OpCode::Call(_, _) => todo!(),
            OpCode::Return => {
                // The basic logic is as follows:
                //
                // 1) Store the address to the start of the stack frame and the
                //    return address to temp variables.
                //
                //      FRAME  = &local      (start of the stack frame)
                //      RET    = FRAME - 5   (the return address)
                //
                // 2) Store the computed value (at the current stack head) to
                //    the parent functions stack head location (which is &arg)
                //    and reset parent functions stack head (+ 1, because we
                //    just added to it) as our stack head.
                //
                //      arg[0] = pop()      (set parent function's stack head t)
                //      &head  = &arg + 1   (restore stack head of parent function)
                //
                // 3) Restore &local, &arg, &this, &that of the parent function.
                //
                //          &that  = FRAME - 1
                //          &this  = FRAME - 2
                //          &arg   = FRAME - 3
                //          &local = FRAME - 4
                //
                // 4) Finally, we goto the return address to continue execution
                //    from our parent function.
                //
                //          goto RET
                //
                // Two quick notes:
                //
                //  a) Why do we store &local in a temp register FRAME? Can't
                //     we just use it directly, since &local is the last thing
                //     we restore?
                //
                //          Yeah, I guess you could, but this is more readable
                //          and clear.
                //
                //  b) Why we store the return address in a temp register RET?
                //     Can't we just do 'goto FRAME - 5' at the very end?
                //
                //          No. The problem is if nargs is 0, then args[0]
                //          and FRAME - 5 point to the same location. So,
                //          in step 2, when we run arg[0] = pop(), we'd be
                //          overwriting the return address.
                //

                const FRAME: u16 = 13;
                const RET: u16 = 14;

                self.emit(&format!(
                    "
                    // 1) Store stack frame base address and return address in temp registers.
                    @LCL
                    D=M

                    @{FRAME}
                    M=D

                    @5
                    A=D-A
                    D=M

                    @{RET}
                    M=D

                    // 2) Set arg[0] = pop() and set the stack head to &arg + 1
                    @SP
                    A=M-1
                    D=M

                    @ARG
                    A=M
                    M=D

                    @ARG
                    D=M+1

                    @SP
                    M=D

                    // 3) Restore &local, &arg, &this, &that of the parent function.
                    @{FRAME}
                    AM=M-1
                    D=M
                    @THAT
                    M=D

                    @{FRAME}
                    AM=M-1
                    D=M
                    @THIS
                    M=D

                    @{FRAME}
                    AM=M-1
                    D=M
                    @ARG
                    M=D

                    @{FRAME}
                    AM=M-1
                    D=M
                    @LCL
                    M=D

                    // 4) Continue execution of parent function where we left off.
                    @{RET}
                    A=M
                    0;JMP
                    ",
                ));
            }
        }
    }
}
