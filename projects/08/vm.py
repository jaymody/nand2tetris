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


class Translator:
    ################
    #### BASICS ####
    ################
    def __init__(self, goto_sys_init: bool):
        self.label_id = 0
        self.assembly = ""

        # initialize stack pointer
        self.emit_load_constant(256)
        self.emit_save_to_addr(SP)

        if goto_sys_init:
            self.emit_goto_label("Sys.init")

    def get_unique_label_id(self) -> int:
        self.label_id += 1
        return self.label_id

    def get_static_var_label(self, module_name: str, val: int) -> str:
        return f"{module_name}${val}"

    def emit(self, s):
        self.assembly += s
        self.assembly += "\n"

    ############################
    #### LOAD MEMORY INTO D ####
    ############################
    def emit_load_constant(self, val: int):
        """D = val"""
        self.emit(f"@{val}")
        self.emit("D=A")

    def emit_load_from_addr(self, addr: int):
        """D = RAM[addr]"""
        self.emit(f"@{addr}")
        self.emit("D=M")

    def emit_load_from_pointer(self, ptr: int):
        """D = RAM[RAM[ptr]]"""
        self.emit(f"@{ptr}")
        self.emit("A=M")
        self.emit("D=M")

    def emit_load_from_pointer_offset(self, ptr: int, offset: int):
        """D = RAM[RAM[ptr] + offset]"""
        self.emit_load_constant(offset)
        self.emit(f"@{ptr}")
        self.emit("A=D+M")
        self.emit("D=M")

    ############################
    #### SAVE D INTO MEMORY ####
    ############################
    def emit_save_to_addr(self, addr: int):
        """RAM[addr] = D"""
        self.emit(f"@{addr}")
        self.emit("M=D")

    def emit_save_to_pointer(self, ptr: int):
        """RAM[RAM[ptr]] = D"""
        self.emit(f"@{ptr}")
        self.emit("A=M")
        self.emit("M=D")

    def emit_save_to_pointer_offset(self, ptr: int, offset: int):
        """RAM[RAM[ptr] + offset] = D"""
        # R13 = D
        self.emit("@R13")
        self.emit("M=D")

        # R14 = RAM[ptr] + offset
        self.emit(f"@{offset}")
        self.emit("D=A")
        self.emit(f"@{ptr}")
        self.emit("D=D+M")
        self.emit("@R14")
        self.emit("M=D")

        # RAM[R14] = R13
        self.emit("@R13")
        self.emit("D=M")
        self.emit("@R14")
        self.emit("A=M")
        self.emit("M=D")

    ########################
    #### STACK PUSH/POP ####
    ########################
    def emit_stack_push(self):
        self.emit_save_to_pointer(SP)
        self.emit("@SP")
        self.emit("M=M+1")

    def emit_stack_pop(self):
        self.emit("@SP")
        self.emit("AM=M-1")
        self.emit("D=M")

    ##############################
    #### ARITHMETIC/LOGIC OPS ####
    ##############################
    def emit_unary_op(self, op: str):
        op = {"not": "!", "neg": "-"}[op]
        self.emit("@SP")
        self.emit("A=M-1")
        self.emit(f"M={op}M")

    def emit_binary_op(self, op: str):
        op = {"add": "D+M", "sub": "M-D", "and": "D&M", "or": "D|M"}[op]
        self.emit_stack_pop()
        self.emit("@SP")
        self.emit("A=M-1")
        self.emit(f"M={op}")

    def emit_cmp_op(self, op: str):
        op = {"eq": "JEQ", "gt": "JGT", "lt": "JLT"}[op]
        uid = self.get_unique_label_id()
        true_branch_label = f"TRUE_BRANCH_{uid}"
        end_comparison_label = f"END_COMPARISON_{uid}"

        # D = head - stack.pop()
        self.emit_stack_pop()
        self.emit("@SP")
        self.emit("A=M-1")
        self.emit("D=M-D")

        # check condition
        self.emit(f"@{true_branch_label}")
        self.emit(f"D;{op}")

        # if condition did not trigger, set head=false=0
        self.emit("@SP")
        self.emit("A=M-1")
        self.emit("M=0")
        self.emit_goto_label(end_comparison_label)

        # if condition triggered, set head=true=-1
        self.emit_label(true_branch_label)
        self.emit("@SP")
        self.emit("A=M-1")
        self.emit("M=-1")
        self.emit_label(end_comparison_label)

    ###########################
    #### LOAD FROM SEGMENT ####
    ###########################
    def emit_load_from_segment(self, segment: str, val: int, module_name: str):
        match segment:
            case "argument":
                self.emit_load_from_pointer_offset(ARG, val)
            case "local":
                self.emit_load_from_pointer_offset(LCL, val)
            case "static":
                self.emit_load_from_addr(self.get_static_var_label(module_name, val))
            case "constant":
                self.emit_load_constant(val)
            case "this":
                self.emit_load_from_pointer_offset(THIS, val)
            case "that":
                self.emit_load_from_pointer_offset(THAT, val)
            case "pointer":
                self.emit_load_from_addr(THIS + val)
            case "temp":
                self.emit_load_from_addr(TEMP + val)
            case _:
                raise ValueError(f"unrecognized segment = {segment}")

    #########################
    #### SAVE TO SEGMENT ####
    #########################
    def emit_save_to_segment(self, segment: str, val: int, module_name: str):
        match segment:
            case "argument":
                self.emit_save_to_pointer_offset(ARG, val)
            case "local":
                self.emit_save_to_pointer_offset(LCL, val)
            case "static":
                self.emit_save_to_addr(self.get_static_var_label(module_name, val))
            case "constant":
                raise ValueError("pop constant is not supported")
            case "this":
                self.emit_save_to_pointer_offset(THIS, val)
            case "that":
                self.emit_save_to_pointer_offset(THAT, val)
            case "pointer":
                self.emit_save_to_addr(THIS + val)
            case "temp":
                self.emit_save_to_addr(TEMP + val)
            case _:
                raise ValueError(f"unrecognized segment = {segment}")

    ######################
    #### PROGRAM FLOW ####
    ######################
    def emit_label(self, label: str):
        self.emit(f"({label})")

    def emit_goto_label(self, label: str):
        self.emit(f"@{label}")
        self.emit("0;JMP")

    def emit_if_goto_label(self, label: str):
        self.emit_stack_pop()
        self.emit(f"@{label}")
        self.emit("D;JNE")

    #####################
    #### EMIT OPCODE ####
    #####################
    def emit_op(self, line: str, module_name: str):
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
                raise NotImplementedError
            case "call":
                name, nargs = args[0], int(args[1])
                raise NotImplementedError
            case "return":
                raise NotImplementedError
            case _:
                raise ValueError(f"unrecognized op = {op}")


def translate(path: str):
    files = glob.glob(os.path.join(path, "*.vm")) if os.path.isdir(path) else [path]

    translator = Translator(goto_sys_init=os.path.isdir(path))
    for file in files:
        for line in open(file):
            if line := line.split("//", 1)[0].strip():
                translator.emit_op(line, module_name=os.path.basename(file))

    return translator.assembly


if __name__ == "__main__":
    print(translate(sys.argv[1]))
