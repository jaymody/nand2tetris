
// init stack pointer
@256
D=A
@0
M=D

// BasicLoop.vm @ 8: push constant 0 
@0
D=A
@0
A=M
M=D
@0
M=M+1

// BasicLoop.vm @ 9: pop local 0 
@0
AM=M-1
D=M
@1
A=M
M=D

// BasicLoop.vm @ 10: label LOOP_START 
(LOOP_START)

// BasicLoop.vm @ 11: push argument 0 
@2
A=M
D=M
@0
A=M
M=D
@0
M=M+1

// BasicLoop.vm @ 12: push local 0 
@1
A=M
D=M
@0
A=M
M=D
@0
M=M+1

// BasicLoop.vm @ 13: add 
@0
AM=M-1
D=M
@0
A=M-1
M=D+M

// BasicLoop.vm @ 14: pop local 0 
@0
AM=M-1
D=M
@1
A=M
M=D

// BasicLoop.vm @ 15: push argument 0 
@2
A=M
D=M
@0
A=M
M=D
@0
M=M+1

// BasicLoop.vm @ 16: push constant 1 
@1
D=A
@0
A=M
M=D
@0
M=M+1

// BasicLoop.vm @ 17: sub 
@0
AM=M-1
D=M
@0
A=M-1
M=M-D

// BasicLoop.vm @ 18: pop argument 0 
@0
AM=M-1
D=M
@2
A=M
M=D

// BasicLoop.vm @ 19: push argument 0 
@2
A=M
D=M
@0
A=M
M=D
@0
M=M+1

// BasicLoop.vm @ 20: if-goto LOOP_START 
@0
AM=M-1
D=M
@LOOP_START
D;JNE

// BasicLoop.vm @ 21: push local 0 
@1
A=M
D=M
@0
A=M
M=D
@0
M=M+1

