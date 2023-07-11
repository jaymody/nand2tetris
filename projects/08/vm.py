import glob
import os
import sys

LCL = 1
ARG = 2
THIS = 3
THAT = 4
TEMP = 5
STATIC = 16

_UID = 0


def get_uid() -> int:
    global _UID
    _UID += 1
    return _UID


def get_static_var_label(module_name: str, val: int) -> str:
    return f"{module_name}${val}"


def emit_init_stack_pointer() -> str:
    return """
    @256
    D=A
    @SP
    M=D
    """


def emit_stack_push() -> str:
    return """
    @SP
    A=M
    M=D
    @SP
    M=M+1
    """


def emit_stack_pop() -> str:
    return """
    @SP
    AM=M-1
    D=M
    """


def emit_unary_op(op: str) -> str:
    op = {"not": "!", "neg": "-"}[op]
    return f"""
    @SP
    A=M-1
    M={op}M
    """


def emit_binary_op(op: str) -> str:
    op = {"add": "D+M", "sub": "M-D", "and": "D&M", "or": "D|M"}[op]
    return f"""
    {emit_stack_pop()}
    @SP
    A=M-1
    M={op}
    """


def emit_cmp_op(op: str) -> str:
    op = {"eq": "JEQ", "gt": "JGT", "lt": "JLT"}[op]
    uid = get_uid()
    return (
        # D = head - stack.pop()
        f"""
        {emit_stack_pop()}
        @SP
        A=M-1
        D=M-D
        """
        # check condition
        f"""
        @SET_TO_TRUE_{uid}
        D;{op}
        """
        # if condition did not trigger, set head=false=0
        f"""
        @SP
        A=M-1
        M=0
        @END_COMPARISON_{uid}
        0;JMP
        """
        # if condition triggered, so x=true=-1
        f"""
        (SET_TO_TRUE_{uid})
        @SP
        A=M-1
        M=-1
        (END_COMPARISON_{uid})
        """
    )


def emit_load_from_segment(segment: str, val: int, module_name: str) -> str:
    def emit_load_constant(val: int) -> str:
        return f"""
        @{val}
        D=A
        """

    def emit_load_from_pointer_offset(ptr: int, offset: int) -> str:
        return f"""
        @{offset}
        D=A
        @{ptr}
        A=D+M
        D=M
        """

    def emit_load_from_addr(addr: int) -> str:
        return f"""
        @{addr}
        D=M
        """

    match segment:
        case "argument":
            return emit_load_from_pointer_offset(ARG, val)
        case "local":
            return emit_load_from_pointer_offset(LCL, val)
        case "static":
            return emit_load_from_addr(get_static_var_label(module_name, val))
        case "constant":
            return emit_load_constant(val)
        case "this":
            return emit_load_from_pointer_offset(THIS, val)
        case "that":
            return emit_load_from_pointer_offset(THAT, val)
        case "pointer":
            return emit_load_from_addr(THIS + val)
        case "temp":
            return emit_load_from_addr(TEMP + val)
        case _:
            raise ValueError(f"unrecognized segment = {segment}")


def emit_save_to_segment(segment: str, val: int, module_name: str) -> str:
    def emit_save_to_pointer_offset(ptr: int, offset: int) -> str:
        return (
            # R13 = D
            """
            @R13
            M=D
            """
            # R14 = RAM[ptr] + offset
            f"""
            @{offset}
            D=A
            @{ptr}
            D=D+M
            @R14
            M=D
            """
            # RAM[R14] = R13
            """
            @R13
            D=M
            @R14
            A=M
            M=D
            """
        )

    def emit_save_to_addr(addr: int) -> str:
        return f"""
        @{addr}
        M=D
        """

    match segment:
        case "argument":
            return emit_save_to_pointer_offset(ARG, val)
        case "local":
            return emit_save_to_pointer_offset(LCL, val)
        case "static":
            return emit_save_to_addr(get_static_var_label(module_name, val))
        case "constant":
            raise ValueError("pop constant is not supported")
        case "this":
            return emit_save_to_pointer_offset(THIS, val)
        case "that":
            return emit_save_to_pointer_offset(THAT, val)
        case "pointer":
            return emit_save_to_addr(THIS + val)
        case "temp":
            return emit_save_to_addr(TEMP + val)
        case _:
            raise ValueError(f"unrecognized segment = {segment}")


def emit_label(label: str) -> str:
    return f"""
    ({label})
    """


def emit_goto_label(label: str) -> str:
    return f"""
    @{label}
    0;JMP
    """


def emit_if_goto_label(label: str) -> str:
    return f"""
    {emit_stack_pop()}
    @{label}
    D;JNE
    """


def emit_function(name: str, nlocals: int) -> str:
    """
    The basic logic is as follows:

        1) Emit a label using name as the value, so we can call our
            function with goto name.

        2) Initialize the local block to 0s:

            for i in 0..nlocals
                local[i] = 0

        3) Set the stack pointer to point to the address right after
           the end of the local block:

            &head = &local + nlocals

    You'll notice, if we assume &head = &local when the function is called (which
    it should be and if not we could always set it), then we can implement 2) and 3) by
    simply calling `push constant 0` nlocals times.

    However, we decide not to write special code instead of reusing `push constant`
    since that would result in (2 + 5) * nlocals instructions (2 for setting D=0 and 5
    for pushing to the stack) while this approach only takes 2 * nlocals +
    4 instructions.

    You'll also note, that we could instead implement setting the nlocals block to 0
    using a loop implementation in the assembly itself. For large values of nlocals,
    this would result in a smaller program file since we are emitting a constant number
    of instructions instead of copy/pasting the same 2 instructions nlocals times.
    Despite emitting fewer instructions, this would come at the cost of time complexity,
    since the loop would require executing more instructions.
    """

    set_zero = "\nM=0\nAD=A+1\n" * nlocals

    return f"""
    {emit_label(name)}
    @LCL
    AD=M
    {set_zero}
    @SP
    M=D
    """


def emit_return() -> str:
    """
    The basic logic is as follows:

        1) Save the start of the current stack frame and the return address of the
           parent function into temp registers:

            FRAME = &local      (start of the stack frame)
            RET   = FRAME - 5   (the return address)

        2) Push the value we want to return (the current value at the stack head) to
           the parent functions stack frame head, and set the parents stack frame head
           as the new current stack head. This is done in two steps:

            arg[0] = pop()      (set parent function's stack head t)
            &head  = &arg + 1   (restore stack frame of parent, +1 is for the ret value)

        2) Restore &local, &arg, &this, &that of the parent function:

            &that  = FRAME - 1
            &this  = FRAME - 2
            &arg = FRAME - 3
            &local = FRAME - 4

        4) Finally, we goto the return address to continue execution from our parent
           function.

            goto RET

    Two quick notes:

        a) Why do we store &local in a temp register FRAME? Can't we just use it
           directly, since &local is the last thing we restore?

                Yeah, I guess you could, but this is more readable and clear.

        b) Why do we store the return address in a temp register RET? Can't we just do
           'goto FRAME - 5' at the very end?

                No. The problem is if nargs is 0, then args[0] and FRAME - 5 point to
                the same location. So, in step 2, when we run arg[0] = pop(), we'd be
                overwriting the return address.
    """

    FRAME = 13
    RET = 14

    return (
        # 1) Store stack frame base address and return address in temp registers.
        f"""
        @LCL
        D=M

        @{FRAME}
        M=D

        @5
        A=D-A
        D=M

        @{RET}
        M=D
        """
        # 2) Set arg[0] = pop() and set the stack head to &arg + 1
        """
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
        """
        # 3) Restore &local, &arg, &this, &that of the parent function.
        f"""
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
        """
        # 4) Continue execution of parent function where we left off.
        f"""
        @{RET}
        A=M
        0;JMP
        """
    )


def translate_line(line: str, module_name: str) -> str:
    op, *args = line.split()
    match op:
        case "neg" | "not":
            return emit_unary_op(op)
        case "add" | "sub" | "and" | "or":
            return emit_binary_op(op)
        case "eq" | "gt" | "lt":
            return emit_cmp_op(op)
        case "push":
            segment, val = args[0], int(args[1])
            return f"""
            {emit_load_from_segment(segment, val, module_name)}
            {emit_stack_push()}
            """
        case "pop":
            segment, val = args[0], int(args[1])
            return f"""
            {emit_stack_pop()}
            {emit_save_to_segment(segment, val, module_name)}
            """
        case "label":
            label = args[0]
            return emit_label(label)
        case "goto":
            label = args[0]
            return emit_goto_label(label)
        case "if-goto":
            label = args[0]
            return emit_if_goto_label(label)
        case "function":
            name, nlocals = args[0], int(args[1])
            return emit_function(name, nlocals)
        case "call":
            name, nargs = args[0], int(args[1])
            raise NotImplementedError
        case "return":
            return emit_return()
        case _:
            raise ValueError(f"unrecognized op = {op}")


def translate_file(file: str):
    assembly = ""
    for line in open(file):
        if line := line.split("//", 1)[0].strip():
            assembly += translate_line(line, module_name=os.path.basename(file))
    return assembly


def translate(path: str):
    # get files to translate
    files = glob.glob(os.path.join(path, "*.vm")) if os.path.isdir(path) else [path]

    # init assembly code
    assembly = ""
    assembly += emit_init_stack_pointer()

    # if we are translating a directory and not an individual file, we goto Sys.init
    # which will be our entrypoint (otherwise, the entrypoint is simply the first
    # command of the file we are translating)
    assembly += emit_goto_label("Sys.init") if os.path.isdir(path) else ""

    # get assembly translation for each file
    for file in files:
        assembly += translate_file(file)

    # strip trailing/leading whitespace for each line and remove any empty lines
    assembly = "\n".join(filter(bool, map(lambda s: s.strip(), assembly.splitlines())))

    return assembly


if __name__ == "__main__":
    print(translate(sys.argv[1]))
