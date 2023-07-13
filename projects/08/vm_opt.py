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


class Translator:
    ################
    #### BASICS ####
    ################
    def __init__(self, call_sys_init: bool):
        self.label_id = 0
        self.assembly = ""
        self.stats = collections.defaultdict(list)

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

    def emit_load_from_pointer(self, ptr: int, offset: int = 0):
        """D = RAM[RAM[ptr] + offset]"""

        if offset == 0:
            self.emit(f"@{ptr}")
            self.emit("A=M")
            self.emit("D=M")
        else:
            self.emit_load_constant(abs(offset))
            self.emit(f"@{ptr}")
            self.emit("A=D+M" if offset > 0 else "A=M-D")
            self.emit("D=M")

    ############################
    #### SAVE D INTO MEMORY ####
    ############################
    def emit_save_to_addr(self, addr: int):
        """RAM[addr] = D"""

        self.emit(f"@{addr}")
        self.emit("M=D")

    def emit_save_to_pointer(self, ptr: int, offset: int = 0):
        """RAM[RAM[ptr] + offset] = D"""

        if offset == 0:
            self.emit(f"@{ptr}")
            self.emit("A=M")
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
    def emit_stack_push(self):
        """
        head   = D
        &head += 1
        """
        self.emit_save_to_pointer(SP)
        self.emit(f"@{SP}")
        self.emit("M=M+1")

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
    def emit_unary_op(self, op: str):
        """
        x = pop()
        push(op x)
        """

        op = {"not": "!", "neg": "-"}[op]
        self.emit(f"@{SP}")
        self.emit("A=M-1")
        self.emit(f"M={op}M")

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

    def emit_cmp_op(self, op: str):
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

        op = {"eq": "JEQ", "gt": "JGT", "lt": "JLT"}[op]
        uid = self.get_unique_label_id()
        true_branch_label = f"TRUE_BRANCH_{uid}"
        end_comparison_label = f"END_COMPARISON_{uid}"

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
        self.emit_goto_label(end_comparison_label)

        # if condition triggered, set head=true=-1
        self.emit_label(true_branch_label)
        self.emit(f"@{SP}")
        self.emit("A=M-1")
        self.emit("M=-1")
        self.emit_label(end_comparison_label)

    ###########################
    #### LOAD FROM SEGMENT ####
    ###########################
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
    def emit_label(self, label: str):
        """emit label"""
        self.emit(f"({label})")

    def emit_goto_label(self, label: str):
        """goto label"""
        self.emit(f"@{label}")
        self.emit("0;JMP")

    def emit_if_goto_label(self, label: str):
        """if D != 0 then goto label"""
        self.emit_stack_pop()
        self.emit(f"@{label}")
        self.emit("D;JNE")

    ###################
    #### FUNCTIONS ####
    ###################
    def emit_function(self, name, nlocals):
        """The logic is as follows:

        1) Emit the label to indicate the entrypoint for the function.
        2) Initialize the local memory segment for the function by pushing 0 to the
           stack nlocals times.

        Before the function code executes the stack should look something like this:

        &arg -------------> arg[0]
                            arg[1]
                            ...
                            arg[nargs]
                            parent return addr
                            parent &local
                            parent &arg
                            parent &this
                            parent &that
        &local &head ----->

        After the function is called the stack should look something like this:

        &arg -------------> arg[0]
                            arg[1]
                            ...
                            arg[nargs]
                            parent return addr
                            parent &local
                            parent &arg
                            parent &this
                            parent &that
        &local -----------> local[0] = 0
                            local[1] = 0
                            ...
                            local[nlocals] = 0
        &head ------------>
        """
        self.emit_label(name)
        for _ in range(nlocals):
            self.emit_load_constant(0)
            self.emit_stack_push()

    def emit_call(self, name, nargs):
        """The logic is as follows:

        1) Push the return addr, &local, &arg, &this, and &that to the stack.

        2) Set the pointers &local and &arg to point to their new locations:

            &local = &head
            &arg   = &head - 5 - nargs

        3) Goto name (i.e. call the function).

        4) Emit the return address label to indicate where we should continue executing
           from after the child function returns.


        Before the emit call code is executed, the stack looks like this:

                            ...
                            arg[0]
                            arg[1]
                            ...
                            arg[nargs]
        &head ------------>

        After the emit call code is executed, the stack looks like this:

                            ...
        &arg -------------> arg[0]
                            arg[1]
                            ...
                            arg[nargs]
                            return addr
                            &local of this function
                            &arg of this function
                            &this of this function
                            &that of this function
        &local &head ----->

        """
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

    def emit_return(self):
        """The logic is as follows:

        1) Save &local and the return address to a register:

            FRAME = &local
            RET   = RAM[FRAME - 5]

        2) We return the stack head to where it was before we called the current
           function (which would be where &arg is pointing), but with the return value
           pushed onto the stack:

            arg[0] = pop()
            &head  = &arg + 1

        3) Restore &local, &arg, &this, &that:

            &that  =  RAM[FRAME - 1]
            &this  =  RAM[FRAME - 2]
            &arg   =  RAM[FRAME - 3]
            &local =  RAM[FRAME - 4]

        4) Finally, we continue execution of the parent function via the return address:

            goto RET


        Two quick notes:

            a) Why do we store &local in a temp register FRAME? Can't
               we just use it directly, since &local is the last thing
               we restore?

                    Yeah, I guess you could, but this is more readable
                    and clear.

            b) Why do we store the return address in a temp register RET?
               Can't we just do 'goto FRAME - 5' at the very end?

                    No. The problem is if nargs is 0, then args[0]
                    and FRAME - 5 point to the same location. So,
                    in step 2, when we run arg[0] = pop(), we'd be
                    overwriting the return address.



        Before the return code executes, the stack should look like this:

                            ...
        &arg -------------> arg[0]
                            arg[1]
                            ...
                            arg[nargs]
                            parent return addr
                            parent &local
                            parent &arg
                            parent &this
                            parent &that
        &local -----------> local[0] = 0
                            local[1] = 0
                            ...
                            local[nlocals] = 0
                            <some value>
                            <some value>
                            ...
                            <some value>
                            value to return
        &head ------------>


        Afterwards, it should look something like this:

                            ...
        &head ------------> value to return

        &head is pointing to where arg[0] used to be. &local, &arg, &this, &that, are
        restored to that of the parent, and the program jumps to the parent return
        address.
        """
        FRAME = 13  # temp register 13
        RET = 14  # temp register 14

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

    #####################
    #### EMIT OPCODE ####
    #####################
    def emit_op(self, line: str, module_name: str):
        op, *args = line.split()

        before_asm_count = self.assembly.count("\n")

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

    return translator.assembly


if __name__ == "__main__":
    print(translate(sys.argv[1]))
