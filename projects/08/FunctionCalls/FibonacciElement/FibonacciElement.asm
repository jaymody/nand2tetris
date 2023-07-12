
// init stack pointer
@256
D=A
@0
M=D

// call Sys.init
@RETURN_LABEL_1
D=A
@0
A=M
M=D
@0
M=M+1
@1
D=M
@0
A=M
M=D
@0
M=M+1
@2
D=M
@0
A=M
M=D
@0
M=M+1
@3
D=M
@0
A=M
M=D
@0
M=M+1
@4
D=M
@0
A=M
M=D
@0
M=M+1
@0
D=M
@1
M=D
@5
D=A
@0
D=M-D
@2
M=D
@Sys.init
0;JMP
(RETURN_LABEL_1)

// Main.vm @ 10: function Main.fibonacci 0 
(Main.fibonacci)

// Main.vm @ 11: push argument 0 
@2
A=M
D=M
@0
A=M
M=D
@0
M=M+1

// Main.vm @ 12: push constant 2 
@2
D=A
@0
A=M
M=D
@0
M=M+1

// Main.vm @ 13: lt 
@0
AM=M-1
D=M
@0
A=M-1
D=M-D
@TRUE_BRANCH_2
D;JLT
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

// Main.vm @ 14: if-goto IF_TRUE 
@0
AM=M-1
D=M
@IF_TRUE
D;JNE

// Main.vm @ 15: goto IF_FALSE 
@IF_FALSE
0;JMP

// Main.vm @ 16: label IF_TRUE 
(IF_TRUE)

// Main.vm @ 17: push argument 0 
@2
A=M
D=M
@0
A=M
M=D
@0
M=M+1

// Main.vm @ 18: return 
@1
D=M
@13
M=D
@5
D=A
@13
A=M-D
D=M
@14
M=D
@0
AM=M-1
D=M
@2
A=M
M=D
@2
D=M
D=D+1
@0
M=D
@1
D=A
@13
A=M-D
D=M
@4
M=D
@2
D=A
@13
A=M-D
D=M
@3
M=D
@3
D=A
@13
A=M-D
D=M
@2
M=D
@4
D=A
@13
A=M-D
D=M
@1
M=D
@14
D=M
A=D
0;JMP

// Main.vm @ 19: label IF_FALSE 
(IF_FALSE)

// Main.vm @ 20: push argument 0 
@2
A=M
D=M
@0
A=M
M=D
@0
M=M+1

// Main.vm @ 21: push constant 2 
@2
D=A
@0
A=M
M=D
@0
M=M+1

// Main.vm @ 22: sub 
@0
AM=M-1
D=M
@0
A=M-1
M=M-D

// Main.vm @ 23: call Main.fibonacci 1 
@RETURN_LABEL_3
D=A
@0
A=M
M=D
@0
M=M+1
@1
D=M
@0
A=M
M=D
@0
M=M+1
@2
D=M
@0
A=M
M=D
@0
M=M+1
@3
D=M
@0
A=M
M=D
@0
M=M+1
@4
D=M
@0
A=M
M=D
@0
M=M+1
@0
D=M
@1
M=D
@6
D=A
@0
D=M-D
@2
M=D
@Main.fibonacci
0;JMP
(RETURN_LABEL_3)

// Main.vm @ 24: push argument 0 
@2
A=M
D=M
@0
A=M
M=D
@0
M=M+1

// Main.vm @ 25: push constant 1 
@1
D=A
@0
A=M
M=D
@0
M=M+1

// Main.vm @ 26: sub 
@0
AM=M-1
D=M
@0
A=M-1
M=M-D

// Main.vm @ 27: call Main.fibonacci 1 
@RETURN_LABEL_4
D=A
@0
A=M
M=D
@0
M=M+1
@1
D=M
@0
A=M
M=D
@0
M=M+1
@2
D=M
@0
A=M
M=D
@0
M=M+1
@3
D=M
@0
A=M
M=D
@0
M=M+1
@4
D=M
@0
A=M
M=D
@0
M=M+1
@0
D=M
@1
M=D
@6
D=A
@0
D=M-D
@2
M=D
@Main.fibonacci
0;JMP
(RETURN_LABEL_4)

// Main.vm @ 28: add 
@0
AM=M-1
D=M
@0
A=M-1
M=D+M

// Main.vm @ 29: return 
@1
D=M
@13
M=D
@5
D=A
@13
A=M-D
D=M
@14
M=D
@0
AM=M-1
D=M
@2
A=M
M=D
@2
D=M
D=D+1
@0
M=D
@1
D=A
@13
A=M-D
D=M
@4
M=D
@2
D=A
@13
A=M-D
D=M
@3
M=D
@3
D=A
@13
A=M-D
D=M
@2
M=D
@4
D=A
@13
A=M-D
D=M
@1
M=D
@14
D=M
A=D
0;JMP

// Sys.vm @ 10: function Sys.init 0 
(Sys.init)

// Sys.vm @ 11: push constant 4 
@4
D=A
@0
A=M
M=D
@0
M=M+1

// Sys.vm @ 12: call Main.fibonacci 1 
@RETURN_LABEL_5
D=A
@0
A=M
M=D
@0
M=M+1
@1
D=M
@0
A=M
M=D
@0
M=M+1
@2
D=M
@0
A=M
M=D
@0
M=M+1
@3
D=M
@0
A=M
M=D
@0
M=M+1
@4
D=M
@0
A=M
M=D
@0
M=M+1
@0
D=M
@1
M=D
@6
D=A
@0
D=M-D
@2
M=D
@Main.fibonacci
0;JMP
(RETURN_LABEL_5)

// Sys.vm @ 13: label WHILE 
(WHILE)

// Sys.vm @ 14: goto WHILE 
@WHILE
0;JMP

