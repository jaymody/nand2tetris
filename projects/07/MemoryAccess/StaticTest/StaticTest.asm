
// init stack pointer
@256
D=A
@0
M=D

// StaticTest.vm @ 6: push constant 111 
@111
D=A
@0
A=M
M=D
@0
M=M+1

// StaticTest.vm @ 7: push constant 333 
@333
D=A
@0
A=M
M=D
@0
M=M+1

// StaticTest.vm @ 8: push constant 888 
@888
D=A
@0
A=M
M=D
@0
M=M+1

// StaticTest.vm @ 9: pop static 8 
@0
AM=M-1
D=M
@StaticTest.vm$8
M=D

// StaticTest.vm @ 10: pop static 3 
@0
AM=M-1
D=M
@StaticTest.vm$3
M=D

// StaticTest.vm @ 11: pop static 1 
@0
AM=M-1
D=M
@StaticTest.vm$1
M=D

// StaticTest.vm @ 12: push static 3 
@StaticTest.vm$3
D=M
@0
A=M
M=D
@0
M=M+1

// StaticTest.vm @ 13: push static 1 
@StaticTest.vm$1
D=M
@0
A=M
M=D
@0
M=M+1

// StaticTest.vm @ 14: sub 
@0
AM=M-1
D=M
@0
A=M-1
M=M-D

// StaticTest.vm @ 15: push static 8 
@StaticTest.vm$8
D=M
@0
A=M
M=D
@0
M=M+1

// StaticTest.vm @ 16: add 
@0
AM=M-1
D=M
@0
A=M-1
M=D+M

