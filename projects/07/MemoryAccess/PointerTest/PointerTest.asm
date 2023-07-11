
        @256
        D=A
        @SP
        M=D
        
        
                
        @3030
        D=A
        
                
@SP
A=M
M=D
@SP
M=M+1

                
                
@SP
AM=M-1
D=M

                
        @3
        M=D
        
                
                
        @3040
        D=A
        
                
@SP
A=M
M=D
@SP
M=M+1

                
                
@SP
AM=M-1
D=M

                
        @4
        M=D
        
                
                
        @32
        D=A
        
                
@SP
A=M
M=D
@SP
M=M+1

                
                
@SP
AM=M-1
D=M

                
        // R13 = D
        @R13
        M=D

        // R14 = RAM[ptr] + offset
        @2
        D=A
        @3
        D=D+M
        @R14
        M=D

        // RAM[R14] = R13
        @R13
        D=M
        @R14
        A=M
        M=D
        
                
                
        @46
        D=A
        
                
@SP
A=M
M=D
@SP
M=M+1

                
                
@SP
AM=M-1
D=M

                
        // R13 = D
        @R13
        M=D

        // R14 = RAM[ptr] + offset
        @6
        D=A
        @4
        D=D+M
        @R14
        M=D

        // RAM[R14] = R13
        @R13
        D=M
        @R14
        A=M
        M=D
        
                
                
        @3
        D=M
        
                
@SP
A=M
M=D
@SP
M=M+1

                
                
        @4
        D=M
        
                
@SP
A=M
M=D
@SP
M=M+1

                
        
@SP
AM=M-1
D=M

        @SP
        A=M-1
        M=D+M
        
                
        @2
        D=A
        @3
        A=D+M
        D=M
        
                
@SP
A=M
M=D
@SP
M=M+1

                
        
@SP
AM=M-1
D=M

        @SP
        A=M-1
        M=M-D
        
                
        @6
        D=A
        @4
        A=D+M
        D=M
        
                
@SP
A=M
M=D
@SP
M=M+1

                
        
@SP
AM=M-1
D=M

        @SP
        A=M-1
        M=D+M
        
