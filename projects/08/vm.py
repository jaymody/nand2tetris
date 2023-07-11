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
            raise NotImplementedError
        case "call":
            name, nargs = args[0], int(args[1])
            raise NotImplementedError
        case "return":
            raise NotImplementedError
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
