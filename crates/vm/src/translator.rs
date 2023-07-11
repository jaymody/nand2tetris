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
use crate::opcode::{OpCode, Segment};

const LCL: u16 = 1;
const ARG: u16 = 2;
const THIS: u16 = 3;
const THAT: u16 = 4;
const TEMP: u16 = 5;
const STATIC: u16 = 16;

static mut UNIQUE_ID: u32 = 0;
fn get_and_inc_unique_label_id_counter() -> u32 {
    unsafe {
        UNIQUE_ID += 1;
        UNIQUE_ID
    }
}

/// &head = 256
/// GOTO Sys.init if goto_sys_init = true
pub fn emit_init(goto_sys_init: bool) -> String {
    let sys_init = if goto_sys_init {
        "
        @Sys.init
        0;JMP
        "
    } else {
        ""
    };

    format!(
        "
        @256
        D=A
        @SP
        M=D
        {sys_init}
        ",
    )
}

/// D = val
fn emit_load_constant(val: u16) -> String {
    format!(
        "
        @{val}
        D=A
        ",
    )
}

/// head = D
/// &head += 1
static EMIT_STACK_PUSH: &str = "
@SP
A=M
M=D
@SP
M=M+1
";

/// &head -= 1
/// D = head
static EMIT_STACK_POP: &str = "
@SP
AM=M-1
D=M
";

/// head = unary_op head
fn emit_unary_op(op: &str) -> String {
    format!(
        "
        @SP
        A=M-1
        M={op}M
        ",
    )
}

/// head = head binary_op stack.pop()
fn emit_binary_op(op: &str) -> String {
    format!(
        "
        {EMIT_STACK_POP}
        @SP
        A=M-1
        M={op}
        ",
    )
}

/// if head cmp_op stack.pop()
///     head = -1 (aka true)
/// else
///     head = 0  (aka false)
fn emit_cmp_op(op: &str) -> String {
    let unique_id = get_and_inc_unique_label_id_counter();
    format!(
        "
        {EMIT_STACK_POP}
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
    )
}

/// D = RAM[addr]
fn emit_load_from_addr(addr: u16) -> String {
    format!(
        "
        @{addr}
        D=M
        ",
    )
}

/// RAM[addr] = D
fn emit_save_to_addr(addr: u16) -> String {
    format!(
        "
        @{addr}
        M=D
        ",
    )
}

/// D = RAM[RAM[ptr] + offset]
///
/// For example, if we ptr = ARG and offset = 2, then effectively we are doing:
/// D = arg2
fn emit_load_from_pointer_offset(ptr: u16, offset: u16) -> String {
    format!(
        "
        @{offset}
        D=A
        @{ptr}
        A=D+M
        D=M
        ",
    )
}

/// RAM[RAM[ptr] + offset] = D
///
/// For example, if we ptr = ARG and offset = 2, then effectively we are doing:
/// arg2 = D
fn emit_save_to_pointer_offset(ptr: u16, offset: u16) -> String {
    format!(
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
    )
}

// Emits the label.
fn emit_label(label: &str) -> String {
    format!(
        "
        ({label})
        ",
    )
}

// Jumps to the label.
fn emit_goto_label(label: &str) -> String {
    format!(
        "
        @{label}
        0;JMP
        ",
    )
}

// Jumps to the label if stack.pop() != 0
fn emit_if_goto_label(label: &str) -> String {
    format!(
        "
        {EMIT_STACK_POP}
        @{label}
        D;JNE
        ",
    )
}

pub fn emit_opcode(opcode: OpCode) -> String {
    match opcode {
        OpCode::Add => emit_binary_op("D+M"),
        OpCode::Sub => emit_binary_op("M-D"),
        OpCode::Neg => emit_unary_op("-"),
        OpCode::Eq => emit_cmp_op("JEQ"),
        OpCode::Gt => emit_cmp_op("JGT"),
        OpCode::Lt => emit_cmp_op("JLT"),
        OpCode::And => emit_binary_op("D&M"),
        OpCode::Or => emit_binary_op("D|M"),
        OpCode::Not => emit_unary_op("!"),
        OpCode::Push(seg, val) => {
            let get_data = match seg {
                Segment::Argument => emit_load_from_pointer_offset(ARG, val),
                Segment::Local => emit_load_from_pointer_offset(LCL, val),
                Segment::Static => emit_load_from_addr(STATIC + val),
                Segment::Constant => emit_load_constant(val),
                Segment::This => emit_load_from_pointer_offset(THIS, val),
                Segment::That => emit_load_from_pointer_offset(THAT, val),
                Segment::Pointer => emit_load_from_addr(THIS + val),
                Segment::Temp => emit_load_from_addr(TEMP + val),
            };
            format!(
                "
                {get_data}
                {EMIT_STACK_PUSH}
                "
            )
        }
        OpCode::Pop(seg, val) => {
            let save_data = match seg {
                Segment::Argument => emit_save_to_pointer_offset(ARG, val),
                Segment::Local => emit_save_to_pointer_offset(LCL, val),
                Segment::Static => emit_save_to_addr(STATIC + val),
                Segment::Constant => panic!("pop to constant not supported"),
                Segment::This => emit_save_to_pointer_offset(THIS, val),
                Segment::That => emit_save_to_pointer_offset(THAT, val),
                Segment::Pointer => emit_save_to_addr(THIS + val),
                Segment::Temp => emit_save_to_addr(TEMP + val),
            };
            format!(
                "
                {EMIT_STACK_POP}
                {save_data}
                "
            )
        }
        OpCode::Label(name) => emit_label(&name),
        OpCode::Goto(name) => emit_goto_label(&name),
        OpCode::IfGoto(name) => emit_if_goto_label(&name),
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

            // NOTE: We don't reuse 'push constant 0' because that would result
            // in (2 + 5) * nlocals instructions (2 for setting D=0
            // and 5 for pushing to the stack) while this approach only
            // takes 2 * nlocals + 4 instructions.
            let set_nlocals_to_zero = "
            M=0
            AD=A+1
            "
            .repeat(nlocals as usize);

            format!(
                "
                // 1 Emit the label
                ({name})

                // 2 Initialize local vars to 0
                @LCL
                A=M
                {set_nlocals_to_zero}

                // 3 Set stack pointer to point to the end of the nlocals block.
                @SP
                M=D
                "
            )
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
            //  b) Why do we store the return address in a temp register RET?
            //     Can't we just do 'goto FRAME - 5' at the very end?
            //
            //          No. The problem is if nargs is 0, then args[0]
            //          and FRAME - 5 point to the same location. So,
            //          in step 2, when we run arg[0] = pop(), we'd be
            //          overwriting the return address.
            //

            const FRAME: u16 = 13;
            const RET: u16 = 14;

            format!(
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
            )
        }
    }
}
