
        @256
        D=A
        @SP
        M=D
        
        
                    
        @10
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
        @0
        D=A
        @1
        D=D+M
        @R14
        M=D

        // RAM[R14] = R13
        @R13
        D=M
        @R14
        A=M
        M=D
        
                    
                    
        @21
        D=A
        
                    
@SP
A=M
M=D
@SP
M=M+1

                    
                    
        @22
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
        @2
        D=D+M
        @R14
        M=D

        // RAM[R14] = R13
        @R13
        D=M
        @R14
        A=M
        M=D
        
                    
                    
@SP
AM=M-1
D=M

                    
        // R13 = D
        @R13
        M=D

        // R14 = RAM[ptr] + offset
        @1
        D=A
        @2
        D=D+M
        @R14
        M=D

        // RAM[R14] = R13
        @R13
        D=M
        @R14
        A=M
        M=D
        
                    
                    
        @36
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
        
                    
                    
        @42
        D=A
        
                    
@SP
A=M
M=D
@SP
M=M+1

                    
                    
        @45
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
        @5
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
        
                    
                    
@SP
AM=M-1
D=M

                    
        // R13 = D
        @R13
        M=D

        // R14 = RAM[ptr] + offset
        @2
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
        
                    
                    
        @510
        D=A
        
                    
@SP
A=M
M=D
@SP
M=M+1

                    
                    
@SP
AM=M-1
D=M

                    
        @11
        M=D
        
                    
                    
        @0
        D=A
        @1
        A=D+M
        D=M
        
                    
@SP
A=M
M=D
@SP
M=M+1

                    
                    
        @5
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
        
                    
        @1
        D=A
        @2
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
        @3
        A=D+M
        D=M
        
                    
@SP
A=M
M=D
@SP
M=M+1

                    
                    
        @6
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
        M=D+M
        
        
@SP
AM=M-1
D=M

        @SP
        A=M-1
        M=M-D
        
                    
        @11
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
        
