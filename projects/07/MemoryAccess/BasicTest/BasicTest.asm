
// init stack pointer
@256
D=A
@0
M=D

// BasicTest.vm @ 6: push constant 10 
@10
D=A
@0
A=M
M=D
@0
M=M+1

// BasicTest.vm @ 7: pop local 0 
@0
AM=M-1
D=M
@1
A=M
M=D

// BasicTest.vm @ 8: push constant 21 
@21
D=A
@0
A=M
M=D
@0
M=M+1

// BasicTest.vm @ 9: push constant 22 
@22
D=A
@0
A=M
M=D
@0
M=M+1

// BasicTest.vm @ 10: pop argument 2 
@0
AM=M-1
D=M
@13
M=D
@2
D=A
@2
D=D+M
@14
M=D
@13
D=M
@14
A=M
M=D

// BasicTest.vm @ 11: pop argument 1 
@0
AM=M-1
D=M
@13
M=D
@1
D=A
@2
D=D+M
@14
M=D
@13
D=M
@14
A=M
M=D

// BasicTest.vm @ 12: push constant 36 
@36
D=A
@0
A=M
M=D
@0
M=M+1

// BasicTest.vm @ 13: pop this 6 
@0
AM=M-1
D=M
@13
M=D
@6
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

// BasicTest.vm @ 14: push constant 42 
@42
D=A
@0
A=M
M=D
@0
M=M+1

// BasicTest.vm @ 15: push constant 45 
@45
D=A
@0
A=M
M=D
@0
M=M+1

// BasicTest.vm @ 16: pop that 5 
@0
AM=M-1
D=M
@13
M=D
@5
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

// BasicTest.vm @ 17: pop that 2 
@0
AM=M-1
D=M
@13
M=D
@2
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

// BasicTest.vm @ 18: push constant 510 
@510
D=A
@0
A=M
M=D
@0
M=M+1

// BasicTest.vm @ 19: pop temp 6 
@0
AM=M-1
D=M
@11
M=D

// BasicTest.vm @ 20: push local 0 
@1
A=M
D=M
@0
A=M
M=D
@0
M=M+1

// BasicTest.vm @ 21: push that 5 
@5
D=A
@4
A=D+M
D=M
@0
A=M
M=D
@0
M=M+1

// BasicTest.vm @ 22: add 
@0
AM=M-1
D=M
@0
A=M-1
M=D+M

// BasicTest.vm @ 23: push argument 1 
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

// BasicTest.vm @ 24: sub 
@0
AM=M-1
D=M
@0
A=M-1
M=M-D

// BasicTest.vm @ 25: push this 6 
@6
D=A
@3
A=D+M
D=M
@0
A=M
M=D
@0
M=M+1

// BasicTest.vm @ 26: push this 6 
@6
D=A
@3
A=D+M
D=M
@0
A=M
M=D
@0
M=M+1

// BasicTest.vm @ 27: add 
@0
AM=M-1
D=M
@0
A=M-1
M=D+M

// BasicTest.vm @ 28: sub 
@0
AM=M-1
D=M
@0
A=M-1
M=M-D

// BasicTest.vm @ 29: push temp 6 
@11
D=M
@0
A=M
M=D
@0
M=M+1

// BasicTest.vm @ 30: add 
@0
AM=M-1
D=M
@0
A=M-1
M=D+M

