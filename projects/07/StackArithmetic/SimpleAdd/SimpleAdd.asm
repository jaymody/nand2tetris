
            //// load constant ////
            @256
            D=A
            

            @SP
            M=D
            

            //// load constant ////
            @7
            D=A
            

            //// push to stack ////
            @SP
            A=M
            M=D
            @SP
            M=M+1
            

            //// load constant ////
            @8
            D=A
            

            //// push to stack ////
            @SP
            A=M
            M=D
            @SP
            M=M+1
            

            //// pop stack ///
            @SP
            AM=M-1
            D=M
            

            //// apply binary op to stack head and D ////
            @SP
            A=M-1
            M=D+M
            

