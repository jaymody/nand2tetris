
        @256
        D=A
        @SP
        M=D
        
        
                    
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

                    
        @4
        M=D
        
                    
                    
        @0
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
        
                    
                    
        @1
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
        @1
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
        
                    
                    
        @0
        D=A
        @2
        A=D+M
        D=M
        
                    
@SP
A=M
M=D
@SP
M=M+1

                    
                    
        @2
        D=A
        
                    
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
        
                    
@SP
AM=M-1
D=M

                    
        // R13 = D
        @R13
        M=D

        // R14 = RAM[ptr] + offset
        @0
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
        
                    
        (MAIN_LOOP_START)
        
                    
        @0
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

        @COMPUTE_ELEMENT
        D;JNE
        
        @END_PROGRAM
        0;JMP
        
        (COMPUTE_ELEMENT)
        
                    
        @0
        D=A
        @4
        A=D+M
        D=M
        
                    
@SP
A=M
M=D
@SP
M=M+1

                    
                    
        @1
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
        
                    
                    
        @4
        D=M
        
                    
@SP
A=M
M=D
@SP
M=M+1

                    
                    
        @1
        D=A
        
                    
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

                    
        @4
        M=D
        
                    
                    
        @0
        D=A
        @2
        A=D+M
        D=M
        
                    
@SP
A=M
M=D
@SP
M=M+1

                    
                    
        @1
        D=A
        
                    
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
        
                    
@SP
AM=M-1
D=M

                    
        // R13 = D
        @R13
        M=D

        // R14 = RAM[ptr] + offset
        @0
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
        
                    
        @MAIN_LOOP_START
        0;JMP
        
        (END_PROGRAM)
        
