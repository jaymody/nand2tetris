
// init stack pointer
@256
D=A
@0
M=D

// StackTest.vm @ 7: push constant 17 
@17
D=A
@0
A=M
M=D
@0
M=M+1

// StackTest.vm @ 8: push constant 17 
@17
D=A
@0
A=M
M=D
@0
M=M+1

// StackTest.vm @ 9: eq 
@0
AM=M-1
D=M
@0
A=M-1
D=M-D
@TRUE_BRANCH_1
D;JEQ
@0
A=M-1
M=0
@END_COMPARISON_1
0;JMP
(TRUE_BRANCH_1)
@0
A=M-1
M=-1
(END_COMPARISON_1)

// StackTest.vm @ 10: push constant 17 
@17
D=A
@0
A=M
M=D
@0
M=M+1

// StackTest.vm @ 11: push constant 16 
@16
D=A
@0
A=M
M=D
@0
M=M+1

// StackTest.vm @ 12: eq 
@0
AM=M-1
D=M
@0
A=M-1
D=M-D
@TRUE_BRANCH_2
D;JEQ
@0
A=M-1
M=0
@END_COMPARISON_2
0;JMP
(TRUE_BRANCH_2)
@0
A=M-1
M=-1
(END_COMPARISON_2)

// StackTest.vm @ 13: push constant 16 
@16
D=A
@0
A=M
M=D
@0
M=M+1

// StackTest.vm @ 14: push constant 17 
@17
D=A
@0
A=M
M=D
@0
M=M+1

// StackTest.vm @ 15: eq 
@0
AM=M-1
D=M
@0
A=M-1
D=M-D
@TRUE_BRANCH_3
D;JEQ
@0
A=M-1
M=0
@END_COMPARISON_3
0;JMP
(TRUE_BRANCH_3)
@0
A=M-1
M=-1
(END_COMPARISON_3)

// StackTest.vm @ 16: push constant 892 
@892
D=A
@0
A=M
M=D
@0
M=M+1

// StackTest.vm @ 17: push constant 891 
@891
D=A
@0
A=M
M=D
@0
M=M+1

// StackTest.vm @ 18: lt 
@0
AM=M-1
D=M
@0
A=M-1
D=M-D
@TRUE_BRANCH_4
D;JLT
@0
A=M-1
M=0
@END_COMPARISON_4
0;JMP
(TRUE_BRANCH_4)
@0
A=M-1
M=-1
(END_COMPARISON_4)

// StackTest.vm @ 19: push constant 891 
@891
D=A
@0
A=M
M=D
@0
M=M+1

// StackTest.vm @ 20: push constant 892 
@892
D=A
@0
A=M
M=D
@0
M=M+1

// StackTest.vm @ 21: lt 
@0
AM=M-1
D=M
@0
A=M-1
D=M-D
@TRUE_BRANCH_5
D;JLT
@0
A=M-1
M=0
@END_COMPARISON_5
0;JMP
(TRUE_BRANCH_5)
@0
A=M-1
M=-1
(END_COMPARISON_5)

// StackTest.vm @ 22: push constant 891 
@891
D=A
@0
A=M
M=D
@0
M=M+1

// StackTest.vm @ 23: push constant 891 
@891
D=A
@0
A=M
M=D
@0
M=M+1

// StackTest.vm @ 24: lt 
@0
AM=M-1
D=M
@0
A=M-1
D=M-D
@TRUE_BRANCH_6
D;JLT
@0
A=M-1
M=0
@END_COMPARISON_6
0;JMP
(TRUE_BRANCH_6)
@0
A=M-1
M=-1
(END_COMPARISON_6)

// StackTest.vm @ 25: push constant 32767 
@32767
D=A
@0
A=M
M=D
@0
M=M+1

// StackTest.vm @ 26: push constant 32766 
@32766
D=A
@0
A=M
M=D
@0
M=M+1

// StackTest.vm @ 27: gt 
@0
AM=M-1
D=M
@0
A=M-1
D=M-D
@TRUE_BRANCH_7
D;JGT
@0
A=M-1
M=0
@END_COMPARISON_7
0;JMP
(TRUE_BRANCH_7)
@0
A=M-1
M=-1
(END_COMPARISON_7)

// StackTest.vm @ 28: push constant 32766 
@32766
D=A
@0
A=M
M=D
@0
M=M+1

// StackTest.vm @ 29: push constant 32767 
@32767
D=A
@0
A=M
M=D
@0
M=M+1

// StackTest.vm @ 30: gt 
@0
AM=M-1
D=M
@0
A=M-1
D=M-D
@TRUE_BRANCH_8
D;JGT
@0
A=M-1
M=0
@END_COMPARISON_8
0;JMP
(TRUE_BRANCH_8)
@0
A=M-1
M=-1
(END_COMPARISON_8)

// StackTest.vm @ 31: push constant 32766 
@32766
D=A
@0
A=M
M=D
@0
M=M+1

// StackTest.vm @ 32: push constant 32766 
@32766
D=A
@0
A=M
M=D
@0
M=M+1

// StackTest.vm @ 33: gt 
@0
AM=M-1
D=M
@0
A=M-1
D=M-D
@TRUE_BRANCH_9
D;JGT
@0
A=M-1
M=0
@END_COMPARISON_9
0;JMP
(TRUE_BRANCH_9)
@0
A=M-1
M=-1
(END_COMPARISON_9)

// StackTest.vm @ 34: push constant 57 
@57
D=A
@0
A=M
M=D
@0
M=M+1

// StackTest.vm @ 35: push constant 31 
@31
D=A
@0
A=M
M=D
@0
M=M+1

// StackTest.vm @ 36: push constant 53 
@53
D=A
@0
A=M
M=D
@0
M=M+1

// StackTest.vm @ 37: add 
@0
AM=M-1
D=M
@0
A=M-1
M=D+M

// StackTest.vm @ 38: push constant 112 
@112
D=A
@0
A=M
M=D
@0
M=M+1

// StackTest.vm @ 39: sub 
@0
AM=M-1
D=M
@0
A=M-1
M=M-D

// StackTest.vm @ 40: neg 
@0
A=M-1
M=-M

// StackTest.vm @ 41: and 
@0
AM=M-1
D=M
@0
A=M-1
M=D&M

// StackTest.vm @ 42: push constant 82 
@82
D=A
@0
A=M
M=D
@0
M=M+1

// StackTest.vm @ 43: or 
@0
AM=M-1
D=M
@0
A=M-1
M=D|M

// StackTest.vm @ 44: not 
@0
A=M-1
M=!M

