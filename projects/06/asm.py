import sys

DEST = {"": "000", "M": "001", "D": "010", "MD": "011", "A": "100", "AM": "101", "AD": "110", "AMD": "1111"}
JUMP = {"": "000", "JGT": "001", "JEQ": "010", "JGE": "011", "JLT": "100", "JNE": "101", "JLE": "110", "JMP": "111"}
COMP = {"0": "0101010", "1": "0111111", "-1": "0111010", "D": "0001100", "A": "0110000", "M": "1110000", "!D": "0001101", "!A": "0110001", "!M": "1110001", "-D": "0001111", "-A": "0110011", "-M": "1110011", "D+1": "0011111", "A+1": "0110111", "M+1": "1110111", "D-1": "0001110", "A-1": "0110010", "M-1": "1110010", "D+A": "0000010", "D+M": "1000010", "D-A": "0010011", "A-D": "0000111", "D-M": "1010011", "M-D": "1000111", "D&A": "0000000", "D&M": "1000000", "D|A": "0010101", "D|M": "1010101"}

labels = {"SP": 0, "LCL": 1, "ARG": 2, "THIS": 3, "THAT": 4, "R0": 0, "R1": 1, "R2": 2, "R3": 3, "R4": 4, "R5": 5, "R6": 6, "R7": 7, "R8": 8, "R9": 9, "R10": 10, "R11": 11, "R12": 12, "R13": 13, "R14": 14, "R15": 15, "SCREEN": 16384, "KBD": 24576}
symbols = {}
instructions = []
for line in open(sys.argv[1]).readlines():
    if line := "".join(line.split("//", 1)[0].split()):
        if line.startswith("("):
            labels[line[1:-1]] = len(instructions)
        else:
            instructions.append(line)

for s in instructions:
    if s.startswith("@"):
        s = s[1:]
        try:
            val = int(s)
        except ValueError:
            (val := labels.get(s)) is not None or (val := symbols.get(s)) is not None
            if val is None:
                val = symbols[s] = len(symbols) + 16
        print(f"0{val:015b}")
    else:
        dest, rest = s.split("=", 1) if "=" in s else ("", s)
        comp, jump = rest.split(";", 1) if ";" in s else (rest, "")
        print(f"111{COMP[comp]}{DEST[dest]}{JUMP[jump]}")
