
            @256
            D=A
            @SP
            M=D
            

            (SimpleFunction.test)
            

                    @LCL
                    A=M
                    

                        M=0
                        AD=A+1
                        

                        M=0
                        AD=A+1
                        

                    @SP
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
            

            @1
            D=A
            @1
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
            A=M-1
            M=!M
            

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
            

                    // 1) Store stack frame base address and return address in temp registers.
                    @LCL
                    D=M

                    @13
                    M=D

                    @5
                    A=D-A
                    D=M

                    @14
                    M=D

                    // 2) Set arg[0] = pop() and set the stack head to &arg + 1
                    @SP
                    A=M-1
                    D=M

                    @ARG
                    A=M
                    M=D

                    @ARG
                    D=M+1

                    @SP
                    M=D

                    // 3) Restore &local, &arg, &this, &that of the parent function.
                    @13
                    AM=M-1
                    D=M
                    @THAT
                    M=D

                    @13
                    AM=M-1
                    D=M
                    @THIS
                    M=D

                    @13
                    AM=M-1
                    D=M
                    @ARG
                    M=D

                    @13
                    AM=M-1
                    D=M
                    @LCL
                    M=D

                    // 4) Continue execution of parent function where we left off.
                    @14
                    A=M
                    0;JMP
                    

