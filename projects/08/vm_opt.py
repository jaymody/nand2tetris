import collections
import glob
import os
import sys

SP = 0
LCL = 1
ARG = 2
THIS = 3
THAT = 4
TEMP = 5
STATIC = 16

stack = []


def add_debug_stack(f):
    def inner(*args, **kwargs):
        stack.append(f.__name__)
        f(*args, **kwargs)
        stack.pop()

    return inner


class Translator:
    ################
    #### BASICS ####
    ################
    def __init__(self, call_sys_init: bool):
        self.label_id = 0
        self.assembly = ""
        self.stats = collections.defaultdict(list)

        # go to initialization code
        self.emit_goto_label("START")

        # define routines
        self.define_return()
        self.define_cmp_op("eq")
        self.define_cmp_op("lt")
        self.define_cmp_op("gt")

        # initialization code
        self.emit_label("START")

        # initialize stack pointer
        self.emit("\n// init stack pointer")
        self.emit_load_constant(256)
        self.emit_save_to_addr(SP)

        if call_sys_init:
            self.emit("\n// call Sys.init")
            self.emit_call("Sys.init", 0)

    def get_unique_label_id(self) -> int:
        self.label_id += 1
        return self.label_id

    def get_static_var_label(self, module_name: str, val: int) -> str:
        return f"{module_name}${val}"

    def emit(self, s):
        self.assembly += f"{s} // {'.'.join(stack)}"
        self.assembly += "\n"

    ############################
    #### LOAD MEMORY INTO D ####
    ############################
    @add_debug_stack
    def emit_load_constant(self, val: int):
        """D = val"""

        self.emit(f"@{val}")
        self.emit("D=A")

    @add_debug_stack
    def emit_load_from_addr(self, addr: int):
        """D = RAM[addr]"""

        self.emit(f"@{addr}")
        self.emit("D=M")

    @add_debug_stack
    def emit_load_from_pointer(self, ptr: int, offset: int = 0):
        """D = RAM[RAM[ptr] + offset]"""

        if abs(offset) <= 2:
            self.emit(f"@{ptr}")
            self.emit("A=M" if offset == 0 else ("A=M+1" if offset > 0 else "A=M-1"))
            for _ in range(abs(offset) - 1):
                self.emit("A=A+1" if offset > 0 else "A=A-1")
            self.emit("D=M")
        else:
            self.emit_load_constant(abs(offset))
            self.emit(f"@{ptr}")
            self.emit("A=D+M" if offset > 0 else "A=M-D")
            self.emit("D=M")

    ############################
    #### SAVE D INTO MEMORY ####
    ############################
    @add_debug_stack
    def emit_save_to_addr(self, addr: int):
        """RAM[addr] = D"""

        self.emit(f"@{addr}")
        self.emit("M=D")

    @add_debug_stack
    def emit_save_to_pointer(self, ptr: int, offset: int = 0):
        """RAM[RAM[ptr] + offset] = D"""

        if abs(offset) <= 8:
            self.emit(f"@{ptr}")
            self.emit("A=M" if offset == 0 else ("A=M+1" if offset > 0 else "A=M-1"))
            for _ in range(abs(offset) - 1):
                self.emit("A=A+1" if offset > 0 else "A=A-1")
            self.emit("M=D")
        else:
            VAL = 13  # temp register 13
            ADDR = 14  # temp register 14

            # VAL = D
            self.emit_save_to_addr(VAL)

            # ADDR = RAM[ptr] + offset
            self.emit_load_constant(abs(offset))
            self.emit(f"@{ptr}")
            self.emit("D=D+M" if offset > 0 else "D=M-D")
            self.emit_save_to_addr(ADDR)

            # RAM[ADDR] = VAL
            self.emit_load_from_addr(VAL)
            self.emit_save_to_pointer(ADDR)

    ########################
    #### STACK PUSH/POP ####
    ########################
    @add_debug_stack
    def emit_stack_push(self):
        """
        head   = D
        &head += 1
        """
        self.emit(f"@{SP}")
        self.emit("AM=M+1")
        self.emit("A=A-1")
        self.emit("M=D")

    @add_debug_stack
    def emit_stack_pop(self):
        """
        &head -= 1
        D = head
        """
        self.emit(f"@{SP}")
        self.emit("AM=M-1")
        self.emit("D=M")

    ##############################
    #### ARITHMETIC/LOGIC OPS ####
    ##############################
    @add_debug_stack
    def emit_unary_op(self, op: str):
        """
        x = pop()
        push(op x)
        """

        op = {"not": "!", "neg": "-"}[op]
        self.emit(f"@{SP}")
        self.emit("A=M-1")
        self.emit(f"M={op}M")

    @add_debug_stack
    def emit_binary_op(self, op: str):
        """
        y = pop()
        x = pop()
        push(x op y)
        """

        op = {"add": "D+M", "sub": "M-D", "and": "D&M", "or": "D|M"}[op]
        self.emit_stack_pop()
        self.emit(f"@{SP}")
        self.emit("A=M-1")
        self.emit(f"M={op}")

    def define_cmp_op(self, op: str):
        """
        y = pop()
        x = pop()

        if x op y:
            push(-1)
        else:
            push(0)

        For example, if op is JGT, then -1 (true) is pushed to the stack if x > y else
        0 (false) is pushed to the stack.
        """

        self.emit_label(f"SUBROUTINE_{op}")

        op = {"eq": "JEQ", "gt": "JGT", "lt": "JLT"}[op]
        true_branch_label = f"TRUE_BRANCH_{op}"
        RET = 13

        # D = head - stack.pop()
        self.emit_stack_pop()
        self.emit(f"@{SP}")
        self.emit("A=M-1")
        self.emit("D=M-D")

        # check condition
        self.emit(f"@{true_branch_label}")
        self.emit(f"D;{op}")

        # if condition did not trigger, set head=false=0
        self.emit(f"@{SP}")
        self.emit("A=M-1")
        self.emit("M=0")

        self.emit(f"@{RET}")
        self.emit("A=M")
        self.emit("0;JMP")

        # if condition triggered, set head=true=-1
        self.emit_label(true_branch_label)
        self.emit(f"@{SP}")
        self.emit("A=M-1")
        self.emit("M=-1")

        self.emit(f"@{RET}")
        self.emit("A=M")
        self.emit("0;JMP")

    @add_debug_stack
    def emit_cmp_op(self, op: str):
        label = f"RETURN_TO_{self.get_unique_label_id()}"
        RET = 13

        self.emit_load_constant(label)
        self.emit_save_to_addr(RET)

        self.emit_goto_label(f"SUBROUTINE_{op}")

        self.emit_label(label)

    ###########################
    #### LOAD FROM SEGMENT ####
    ###########################
    @add_debug_stack
    def emit_load_from_segment(self, segment: str, val: int, module_name: str):
        """D = segment[val]"""

        match segment:
            case "argument":
                self.emit_load_from_pointer(ARG, val)
            case "local":
                self.emit_load_from_pointer(LCL, val)
            case "static":
                self.emit_load_from_addr(self.get_static_var_label(module_name, val))
            case "constant":
                self.emit_load_constant(val)
            case "this":
                self.emit_load_from_pointer(THIS, val)
            case "that":
                self.emit_load_from_pointer(THAT, val)
            case "pointer":
                self.emit_load_from_addr(THIS + val)
            case "temp":
                self.emit_load_from_addr(TEMP + val)
            case _:
                raise ValueError(f"unrecognized segment = {segment}")

    #########################
    #### SAVE TO SEGMENT ####
    #########################
    @add_debug_stack
    def emit_save_to_segment(self, segment: str, val: int, module_name: str):
        """segment[val] = D"""

        match segment:
            case "argument":
                self.emit_save_to_pointer(ARG, val)
            case "local":
                self.emit_save_to_pointer(LCL, val)
            case "static":
                self.emit_save_to_addr(self.get_static_var_label(module_name, val))
            case "constant":
                raise ValueError("pop constant is not supported")
            case "this":
                self.emit_save_to_pointer(THIS, val)
            case "that":
                self.emit_save_to_pointer(THAT, val)
            case "pointer":
                self.emit_save_to_addr(THIS + val)
            case "temp":
                self.emit_save_to_addr(TEMP + val)
            case _:
                raise ValueError(f"unrecognized segment = {segment}")

    ######################
    #### PROGRAM FLOW ####
    ######################
    @add_debug_stack
    def emit_label(self, label: str):
        """emit label"""
        self.emit(f"({label})")

    @add_debug_stack
    def emit_goto_label(self, label: str):
        """goto label"""
        self.emit(f"@{label}")
        self.emit("0;JMP")

    @add_debug_stack
    def emit_if_goto_label(self, label: str):
        """if D != 0 then goto label"""
        self.emit_stack_pop()
        self.emit(f"@{label}")
        self.emit("D;JNE")

    ###################
    #### FUNCTIONS ####
    ###################
    @add_debug_stack
    def emit_function(self, name, nlocals):
        self.emit_label(name)
        for _ in range(nlocals):
            self.emit_load_constant(0)
            self.emit_stack_push()

    @add_debug_stack
    def emit_call(self, name, nargs):
        return_label = f"RETURN_LABEL_{self.get_unique_label_id()}"

        # 1) Push the return addr, &local, &arg, &this, and &that to the stack.
        self.emit(f"@{return_label}")
        self.emit("D=A")
        self.emit_stack_push()

        self.emit_load_from_addr(LCL)
        self.emit_stack_push()

        self.emit_load_from_addr(ARG)
        self.emit_stack_push()

        self.emit_load_from_addr(THIS)
        self.emit_stack_push()

        self.emit_load_from_addr(THAT)
        self.emit_stack_push()

        # 2) Set the pointers &local and &arg to point to their new locations.
        self.emit_load_from_addr(SP)
        self.emit_save_to_addr(LCL)

        self.emit_load_constant(nargs + 5)
        self.emit(f"@{SP}")
        self.emit("D=M-D")
        self.emit_save_to_addr(ARG)

        # 3) Call the function.
        self.emit_goto_label(name)

        # 4) Emit return label.
        self.emit_label(return_label)

    def define_return(self):
        FRAME = 13  # temp register 13
        RET = 14  # temp register 14

        self.emit_label("SUBROUTINE_RETURN")

        # 1) Save stack frame and parent return addr to temp registers.
        # FRAME = &local
        self.emit_load_from_addr(LCL)
        self.emit_save_to_addr(FRAME)

        # RET = &local - 5
        self.emit_load_from_pointer(FRAME, -5)
        self.emit_save_to_addr(RET)

        # 2) Reset stack head to parent with the return value pushed onto the stack.
        # arg[0] = pop()
        self.emit_stack_pop()
        self.emit_save_to_pointer(ARG)

        # &head  = &arg + 1
        self.emit_load_from_addr(ARG)
        self.emit("D=D+1")
        self.emit_save_to_addr(SP)

        # 3) Restore &local, &arg, &this, &that.
        self.emit_load_from_pointer(FRAME, -1)
        self.emit_save_to_addr(THAT)

        self.emit_load_from_pointer(FRAME, -2)
        self.emit_save_to_addr(THIS)

        self.emit_load_from_pointer(FRAME, -3)
        self.emit_save_to_addr(ARG)

        self.emit_load_from_pointer(FRAME, -4)
        self.emit_save_to_addr(LCL)

        # 4) Goto RET
        self.emit_load_from_addr(RET)
        self.emit("A=D")
        self.emit("0;JMP")

    @add_debug_stack
    def emit_return(self):
        self.emit_goto_label("SUBROUTINE_RETURN")

    #####################
    #### EMIT OPCODE ####
    #####################
    def emit_op(self, line: str, module_name: str):
        before_asm_count = self.assembly.count("\n")

        self.emit(f"// {line}")

        op, *args = line.split()

        match op:
            case "neg" | "not":
                self.emit_unary_op(op)
            case "add" | "sub" | "and" | "or":
                self.emit_binary_op(op)
            case "eq" | "gt" | "lt":
                self.emit_cmp_op(op)
            case "push":
                segment, val = args[0], int(args[1])
                self.emit_load_from_segment(segment, val, module_name)
                self.emit_stack_push()
            case "pop":
                segment, val = args[0], int(args[1])
                self.emit_stack_pop()
                self.emit_save_to_segment(segment, val, module_name)
            case "label":
                label = args[0]
                self.emit_label(label)
            case "goto":
                label = args[0]
                self.emit_goto_label(label)
            case "if-goto":
                label = args[0]
                self.emit_if_goto_label(label)
            case "function":
                name, nlocals = args[0], int(args[1])
                self.emit_function(name, nlocals)
            case "call":
                name, nargs = args[0], int(args[1])
                self.emit_call(name, nargs)
            case "return":
                self.emit_return()
            case _:
                raise ValueError(f"unrecognized op = {op}")

        self.stats[op].append(self.assembly.count("\n") - before_asm_count)


def add_line_numbers(assembly: str) -> str:
    line_num = 0
    output = []
    for line in assembly.splitlines():
        if line := line.strip():
            if not (line.startswith("(") or line.startswith("//")):
                line = f"{line} // line_num: {line_num}"
                line_num += 1
            output.append(line)
    return "\n".join(output)


def translate(path: str, print_stats: bool = True):
    files = glob.glob(os.path.join(path, "*.vm")) if os.path.isdir(path) else [path]

    translator = Translator(call_sys_init=os.path.isdir(path))
    for file in files:
        for line_num, line in enumerate(open(file)):
            if line := line.split("//", 1)[0].strip():
                module_name = os.path.basename(file)
                translator.emit_op(line, module_name)

    if print_stats:
        total_lc = translator.assembly.count("\n")
        header = f"{'op':>16} | {'freq':>16} | {'total asm lines':>16} | {'% of asm lines':>16} |"
        print(header, file=sys.stderr)
        print("-" * len(header), file=sys.stderr)
        for k, v in sorted(translator.stats.items(), key=lambda x: sum(x[1]), reverse=True):
            print(f"{k:>16} | {len(v):>16} | {sum(v):>16} | {sum(v)/total_lc:>16.3f} |", file=sys.stderr)
        print(f"\ntotal asm line count = {total_lc}", file=sys.stderr)

    return add_line_numbers(translator.assembly)


if __name__ == "__main__":
    print(translate(sys.argv[1]))
