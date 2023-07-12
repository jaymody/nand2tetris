
// init stack pointer
@256
D=A
@0
M=D

// PointerTest.vm @ 7: push constant 3030 
@3030
D=A
@0
A=M
M=D
@0
M=M+1

// PointerTest.vm @ 8: pop pointer 0 
@0
AM=M-1
D=M
@3
M=D

// PointerTest.vm @ 9: push constant 3040 
@3040
D=A
@0
A=M
M=D
@0
M=M+1

// PointerTest.vm @ 10: pop pointer 1 
@0
AM=M-1
D=M
@4
M=D

// PointerTest.vm @ 11: push constant 32 
@32
D=A
@0
A=M
M=D
@0
M=M+1

// PointerTest.vm @ 12: pop this 2 
@0
AM=M-1
D=M
@13
M=D
@2
D=A
@3
D=D+M
@14
M=D
@13
D=M
@14
A=M
M=D

// PointerTest.vm @ 13: push constant 46 
@46
D=A
@0
A=M
M=D
@0
M=M+1

// PointerTest.vm @ 14: pop that 6 
@0
AM=M-1
D=M
@13
M=D
@6
D=A
@4
D=D+M
@14
M=D
@13
D=M
@14
A=M
M=D

// PointerTest.vm @ 15: push pointer 0 
@3
D=M
@0
A=M
M=D
@0
M=M+1

// PointerTest.vm @ 16: push pointer 1 
@4
D=M
@0
A=M
M=D
@0
M=M+1

// PointerTest.vm @ 17: add 
@0
AM=M-1
D=M
@0
A=M-1
M=D+M

// PointerTest.vm @ 18: push this 2 
@2
D=A
@3
A=D+M
D=M
@0
A=M
M=D
@0
M=M+1

// PointerTest.vm @ 19: sub 
@0
AM=M-1
D=M
@0
A=M-1
M=M-D

// PointerTest.vm @ 20: push that 6 
@6
D=A
@4
A=D+M
D=M
@0
A=M
M=D
@0
M=M+1

// PointerTest.vm @ 21: add 
@0
AM=M-1
D=M
@0
A=M-1
M=D+M

