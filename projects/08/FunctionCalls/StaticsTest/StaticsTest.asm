
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

// Class1.vm @ 6: function Class1.set 0 
(Class1.set)

// Class1.vm @ 7: push argument 0 
@2
A=M
D=M
@0
A=M
M=D
@0
M=M+1

// Class1.vm @ 8: pop static 0 
@0
AM=M-1
D=M
@Class1.vm$0
M=D

// Class1.vm @ 9: push argument 1 
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

// Class1.vm @ 10: pop static 1 
@0
AM=M-1
D=M
@Class1.vm$1
M=D

// Class1.vm @ 11: push constant 0 
@0
D=A
@0
A=M
M=D
@0
M=M+1

// Class1.vm @ 12: return 
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

// Class1.vm @ 15: function Class1.get 0 
(Class1.get)

// Class1.vm @ 16: push static 0 
@Class1.vm$0
D=M
@0
A=M
M=D
@0
M=M+1

// Class1.vm @ 17: push static 1 
@Class1.vm$1
D=M
@0
A=M
M=D
@0
M=M+1

// Class1.vm @ 18: sub 
@0
AM=M-1
D=M
@0
A=M-1
M=M-D

// Class1.vm @ 19: return 
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

// Sys.vm @ 7: function Sys.init 0 
(Sys.init)

// Sys.vm @ 8: push constant 6 
@6
D=A
@0
A=M
M=D
@0
M=M+1

// Sys.vm @ 9: push constant 8 
@8
D=A
@0
A=M
M=D
@0
M=M+1

// Sys.vm @ 10: call Class1.set 2 
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
@7
D=A
@0
D=M-D
@2
M=D
@Class1.set
0;JMP
(RETURN_LABEL_2)

// Sys.vm @ 11: pop temp 0 
@0
AM=M-1
D=M
@5
M=D

// Sys.vm @ 12: push constant 23 
@23
D=A
@0
A=M
M=D
@0
M=M+1

// Sys.vm @ 13: push constant 15 
@15
D=A
@0
A=M
M=D
@0
M=M+1

// Sys.vm @ 14: call Class2.set 2 
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
@7
D=A
@0
D=M-D
@2
M=D
@Class2.set
0;JMP
(RETURN_LABEL_3)

// Sys.vm @ 15: pop temp 0 
@0
AM=M-1
D=M
@5
M=D

// Sys.vm @ 16: call Class1.get 0 
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
@5
D=A
@0
D=M-D
@2
M=D
@Class1.get
0;JMP
(RETURN_LABEL_4)

// Sys.vm @ 17: call Class2.get 0 
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
@5
D=A
@0
D=M-D
@2
M=D
@Class2.get
0;JMP
(RETURN_LABEL_5)

// Sys.vm @ 18: label WHILE 
(WHILE)

// Sys.vm @ 19: goto WHILE 
@WHILE
0;JMP

// Class2.vm @ 6: function Class2.set 0 
(Class2.set)

// Class2.vm @ 7: push argument 0 
@2
A=M
D=M
@0
A=M
M=D
@0
M=M+1

// Class2.vm @ 8: pop static 0 
@0
AM=M-1
D=M
@Class2.vm$0
M=D

// Class2.vm @ 9: push argument 1 
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

// Class2.vm @ 10: pop static 1 
@0
AM=M-1
D=M
@Class2.vm$1
M=D

// Class2.vm @ 11: push constant 0 
@0
D=A
@0
A=M
M=D
@0
M=M+1

// Class2.vm @ 12: return 
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

// Class2.vm @ 15: function Class2.get 0 
(Class2.get)

// Class2.vm @ 16: push static 0 
@Class2.vm$0
D=M
@0
A=M
M=D
@0
M=M+1

// Class2.vm @ 17: push static 1 
@Class2.vm$1
D=M
@0
A=M
M=D
@0
M=M+1

// Class2.vm @ 18: sub 
@0
AM=M-1
D=M
@0
A=M-1
M=M-D

// Class2.vm @ 19: return 
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

