
// init stack pointer
@256
D=A
@0
M=D

// FibonacciSeries.vm @ 10: push argument 1 
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

// FibonacciSeries.vm @ 11: pop pointer 1 
@0
AM=M-1
D=M
@4
M=D

// FibonacciSeries.vm @ 13: push constant 0 
@0
D=A
@0
A=M
M=D
@0
M=M+1

// FibonacciSeries.vm @ 14: pop that 0 
@0
AM=M-1
D=M
@4
A=M
M=D

// FibonacciSeries.vm @ 15: push constant 1 
@1
D=A
@0
A=M
M=D
@0
M=M+1

// FibonacciSeries.vm @ 16: pop that 1 
@0
AM=M-1
D=M
@13
M=D
@1
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

// FibonacciSeries.vm @ 18: push argument 0 
@2
A=M
D=M
@0
A=M
M=D
@0
M=M+1

// FibonacciSeries.vm @ 19: push constant 2 
@2
D=A
@0
A=M
M=D
@0
M=M+1

// FibonacciSeries.vm @ 20: sub 
@0
AM=M-1
D=M
@0
A=M-1
M=M-D

// FibonacciSeries.vm @ 21: pop argument 0 
@0
AM=M-1
D=M
@2
A=M
M=D

// FibonacciSeries.vm @ 23: label MAIN_LOOP_START 
(MAIN_LOOP_START)

// FibonacciSeries.vm @ 25: push argument 0 
@2
A=M
D=M
@0
A=M
M=D
@0
M=M+1

// FibonacciSeries.vm @ 26: if-goto COMPUTE_ELEMENT 
@0
AM=M-1
D=M
@COMPUTE_ELEMENT
D;JNE

// FibonacciSeries.vm @ 27: goto END_PROGRAM 
@END_PROGRAM
0;JMP

// FibonacciSeries.vm @ 29: label COMPUTE_ELEMENT 
(COMPUTE_ELEMENT)

// FibonacciSeries.vm @ 31: push that 0 
@4
A=M
D=M
@0
A=M
M=D
@0
M=M+1

// FibonacciSeries.vm @ 32: push that 1 
@1
D=A
@4
A=D+M
D=M
@0
A=M
M=D
@0
M=M+1

// FibonacciSeries.vm @ 33: add 
@0
AM=M-1
D=M
@0
A=M-1
M=D+M

// FibonacciSeries.vm @ 34: pop that 2 
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

// FibonacciSeries.vm @ 36: push pointer 1 
@4
D=M
@0
A=M
M=D
@0
M=M+1

// FibonacciSeries.vm @ 37: push constant 1 
@1
D=A
@0
A=M
M=D
@0
M=M+1

// FibonacciSeries.vm @ 38: add 
@0
AM=M-1
D=M
@0
A=M-1
M=D+M

// FibonacciSeries.vm @ 39: pop pointer 1 
@0
AM=M-1
D=M
@4
M=D

// FibonacciSeries.vm @ 41: push argument 0 
@2
A=M
D=M
@0
A=M
M=D
@0
M=M+1

// FibonacciSeries.vm @ 42: push constant 1 
@1
D=A
@0
A=M
M=D
@0
M=M+1

// FibonacciSeries.vm @ 43: sub 
@0
AM=M-1
D=M
@0
A=M-1
M=M-D

// FibonacciSeries.vm @ 44: pop argument 0 
@0
AM=M-1
D=M
@2
A=M
M=D

// FibonacciSeries.vm @ 46: goto MAIN_LOOP_START 
@MAIN_LOOP_START
0;JMP

// FibonacciSeries.vm @ 48: label END_PROGRAM 
(END_PROGRAM)

