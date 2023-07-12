
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

// Sys.vm @ 7: function Sys.init 0 
(Sys.init)

// Sys.vm @ 8: push constant 4000 
@4000
D=A
@0
A=M
M=D
@0
M=M+1

// Sys.vm @ 9: pop pointer 0 
@0
AM=M-1
D=M
@3
M=D

// Sys.vm @ 10: push constant 5000 
@5000
D=A
@0
A=M
M=D
@0
M=M+1

// Sys.vm @ 11: pop pointer 1 
@0
AM=M-1
D=M
@4
M=D

// Sys.vm @ 12: call Sys.main 0 
@RETURN_LABEL_2
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
@Sys.main
0;JMP
(RETURN_LABEL_2)

// Sys.vm @ 13: pop temp 1 
@0
AM=M-1
D=M
@6
M=D

// Sys.vm @ 14: label LOOP 
(LOOP)

// Sys.vm @ 15: goto LOOP 
@LOOP
0;JMP

// Sys.vm @ 25: function Sys.main 5 
(Sys.main)
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
@0
D=A
@0
A=M
M=D
@0
M=M+1

// Sys.vm @ 26: push constant 4001 
@4001
D=A
@0
A=M
M=D
@0
M=M+1

// Sys.vm @ 27: pop pointer 0 
@0
AM=M-1
D=M
@3
M=D

// Sys.vm @ 28: push constant 5001 
@5001
D=A
@0
A=M
M=D
@0
M=M+1

// Sys.vm @ 29: pop pointer 1 
@0
AM=M-1
D=M
@4
M=D

// Sys.vm @ 30: push constant 200 
@200
D=A
@0
A=M
M=D
@0
M=M+1

// Sys.vm @ 31: pop local 1 
@0
AM=M-1
D=M
@13
M=D
@1
D=A
@1
D=D+M
@14
M=D
@13
D=M
@14
A=M
M=D

// Sys.vm @ 32: push constant 40 
@40
D=A
@0
A=M
M=D
@0
M=M+1

// Sys.vm @ 33: pop local 2 
@0
AM=M-1
D=M
@13
M=D
@2
D=A
@1
D=D+M
@14
M=D
@13
D=M
@14
A=M
M=D

// Sys.vm @ 34: push constant 6 
@6
D=A
@0
A=M
M=D
@0
M=M+1

// Sys.vm @ 35: pop local 3 
@0
AM=M-1
D=M
@13
M=D
@3
D=A
@1
D=D+M
@14
M=D
@13
D=M
@14
A=M
M=D

// Sys.vm @ 36: push constant 123 
@123
D=A
@0
A=M
M=D
@0
M=M+1

// Sys.vm @ 37: call Sys.add12 1 
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
@Sys.add12
0;JMP
(RETURN_LABEL_3)

// Sys.vm @ 38: pop temp 0 
@0
AM=M-1
D=M
@5
M=D

// Sys.vm @ 39: push local 0 
@1
A=M
D=M
@0
A=M
M=D
@0
M=M+1

// Sys.vm @ 40: push local 1 
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

// Sys.vm @ 41: push local 2 
@2
D=A
@1
A=D+M
D=M
@0
A=M
M=D
@0
M=M+1

// Sys.vm @ 42: push local 3 
@3
D=A
@1
A=D+M
D=M
@0
A=M
M=D
@0
M=M+1

// Sys.vm @ 43: push local 4 
@4
D=A
@1
A=D+M
D=M
@0
A=M
M=D
@0
M=M+1

// Sys.vm @ 44: add 
@0
AM=M-1
D=M
@0
A=M-1
M=D+M

// Sys.vm @ 45: add 
@0
AM=M-1
D=M
@0
A=M-1
M=D+M

// Sys.vm @ 46: add 
@0
AM=M-1
D=M
@0
A=M-1
M=D+M

// Sys.vm @ 47: add 
@0
AM=M-1
D=M
@0
A=M-1
M=D+M

// Sys.vm @ 48: return 
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

// Sys.vm @ 54: function Sys.add12 0 
(Sys.add12)

// Sys.vm @ 55: push constant 4002 
@4002
D=A
@0
A=M
M=D
@0
M=M+1

// Sys.vm @ 56: pop pointer 0 
@0
AM=M-1
D=M
@3
M=D

// Sys.vm @ 57: push constant 5002 
@5002
D=A
@0
A=M
M=D
@0
M=M+1

// Sys.vm @ 58: pop pointer 1 
@0
AM=M-1
D=M
@4
M=D

// Sys.vm @ 59: push argument 0 
@2
A=M
D=M
@0
A=M
M=D
@0
M=M+1

// Sys.vm @ 60: push constant 12 
@12
D=A
@0
A=M
M=D
@0
M=M+1

// Sys.vm @ 61: add 
@0
AM=M-1
D=M
@0
A=M-1
M=D+M

// Sys.vm @ 62: return 
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

