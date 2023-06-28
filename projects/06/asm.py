import sys

DEST = {"": "000", "M": "001", "D": "010", "MD": "011", "A": "100", "AM": "101", "AD": "110", "AMD": "1111"}
JUMP = {"": "000", "JGT": "001", "JEQ": "010", "JGE": "011", "JLT": "100", "JNE": "101", "JLE": "110", "JMP": "111"}
COMP = {"0": "0101010", "1": "0111111", "-1": "0111010", "D": "0001100", "A": "0110000", "M": "1110000", "!D": "0001101", "!A": "0110001", "!M": "1110001", "-D": "0001111", "-A": "0110011", "-M": "1110011", "D+1": "0011111", "A+1": "0110111", "M+1": "1110111", "D-1": "0001110", "A-1": "0110010", "M-1": "1110010", "D+A": "0000010", "D+M": "1000010", "D-A": "0010011", "A-D": "0000111", "D-M": "1010011", "M-D": "1000111", "D&A": "0000000", "D&M": "1000000", "D|A": "0010101", "D|M": "1010101"}
RESERVED_SYMBOLS = {"SP": 0, "LCL": 1, "ARG": 2, "THIS": 3, "THAT": 4, "R0": 0, "R1": 1, "R2": 2, "R3": 3, "R4": 4, "R5": 5, "R6": 6, "R7": 7, "R8": 8, "R9": 9, "R10": 10, "R11": 11, "R12": 12, "R13": 13, "R14": 14, "R15": 15, "SCREEN": 16384, "KBD": 24576}

labels = {}
instructions = []
for line in open(sys.argv[1]).readlines():
    line = line.split("//", maxsplit=1)[0]  # remove comments
    line = "".join(line.split())  # remove whitespace
    if line:  # only process if the line is not empty
        if line.startswith("("):
            labels[line[1:-1]] = len(instructions)
        elif line.startswith("@"):  # for A instruction, we populate as a list
            instructions.append([line[1:]])  # list is used to indicate an A instruction
        else:  # for C instructions, we process it right away into the hack instruction
            dest, rest = line.split("=", maxsplit=1) if "=" in line else ("", line)
            comp, jump = rest.split(";", maxsplit=1) if ";" in line else (rest, "")
            instructions.append(f"111{COMP[comp]}{DEST[dest]}{JUMP[jump]}")

symbols = {}
for i, instruction in enumerate(instructions):
    if isinstance(instruction, list):
        s = instruction[0]
        try:
            val = int(s)
        except ValueError:
            val = RESERVED_SYMBOLS.get(s)
            if val is None:
                val = labels.get(s)
            if val is None:
                val = symbols.get(s)
            if val is None:
                val = symbols[s] = len(symbols) + 16
        print(f"0{val:015b}")
    else:
        print(instruction)
