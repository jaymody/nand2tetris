
// init stack pointer
@256
D=A
@0
M=D

// SimpleAdd.vm @ 6: push constant 7 
@7
D=A
@0
A=M
M=D
@0
M=M+1

// SimpleAdd.vm @ 7: push constant 8 
@8
D=A
@0
A=M
M=D
@0
M=M+1

// SimpleAdd.vm @ 8: add 
@0
AM=M-1
D=M
@0
A=M-1
M=D+M

