
// init stack pointer
@256
D=A
@0
M=D

// SimpleFunction.vm @ 6: function SimpleFunction.test 2 
(SimpleFunction.test)
@0
D=A
@0
A=M
M=D
@0
M=M+1
@0
D=A
@0
A=M
M=D
@0
M=M+1

// SimpleFunction.vm @ 7: push local 0 
@1
A=M
D=M
@0
A=M
M=D
@0
M=M+1

// SimpleFunction.vm @ 8: push local 1 
@1
D=A
@1
A=D+M
D=M
@0
A=M
M=D
@0
M=M+1

// SimpleFunction.vm @ 9: add 
@0
AM=M-1
D=M
@0
A=M-1
M=D+M

// SimpleFunction.vm @ 10: not 
@0
A=M-1
M=!M

// SimpleFunction.vm @ 11: push argument 0 
@2
A=M
D=M
@0
A=M
M=D
@0
M=M+1

// SimpleFunction.vm @ 12: add 
@0
AM=M-1
D=M
@0
A=M-1
M=D+M

// SimpleFunction.vm @ 13: push argument 1 
@1
D=A
@2
A=D+M
D=M
@0
A=M
M=D
@0
M=M+1

// SimpleFunction.vm @ 14: sub 
@0
AM=M-1
D=M
@0
A=M-1
M=M-D

// SimpleFunction.vm @ 15: return 
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

