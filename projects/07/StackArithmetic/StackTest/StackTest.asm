
            //// load constant ////
            @256
            D=A
            

            @SP
            M=D
            

            //// load constant ////
            @17
            D=A
            

            //// push to stack ////
            @SP
            A=M
            M=D
            @SP
            M=M+1
            

            //// load constant ////
            @17
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
            

            //// perform comparison on stack head and D ////
            // if the comparison is true stack is set to = -1 else 0

            // D=x-y
            @SP
            A=M-1
            D=M-D

            // check condition
            @SET_TO_TRUE_0
            D;JEQ

            // condition did not trigger, so x=false (x=0)
            @SP
            A=M-1
            M=0
            @END_COMPARISON_1
            0;JMP

            // condition triggered, so x=true (x=-1)
            (SET_TO_TRUE_0)
            @SP
            A=M-1
            M=-1

            (END_COMPARISON_1)
            

            //// load constant ////
            @17
            D=A
            

            //// push to stack ////
            @SP
            A=M
            M=D
            @SP
            M=M+1
            

            //// load constant ////
            @16
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
            

            //// perform comparison on stack head and D ////
            // if the comparison is true stack is set to = -1 else 0

            // D=x-y
            @SP
            A=M-1
            D=M-D

            // check condition
            @SET_TO_TRUE_2
            D;JEQ

            // condition did not trigger, so x=false (x=0)
            @SP
            A=M-1
            M=0
            @END_COMPARISON_3
            0;JMP

            // condition triggered, so x=true (x=-1)
            (SET_TO_TRUE_2)
            @SP
            A=M-1
            M=-1

            (END_COMPARISON_3)
            

            //// load constant ////
            @16
            D=A
            

            //// push to stack ////
            @SP
            A=M
            M=D
            @SP
            M=M+1
            

            //// load constant ////
            @17
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
            

            //// perform comparison on stack head and D ////
            // if the comparison is true stack is set to = -1 else 0

            // D=x-y
            @SP
            A=M-1
            D=M-D

            // check condition
            @SET_TO_TRUE_4
            D;JEQ

            // condition did not trigger, so x=false (x=0)
            @SP
            A=M-1
            M=0
            @END_COMPARISON_5
            0;JMP

            // condition triggered, so x=true (x=-1)
            (SET_TO_TRUE_4)
            @SP
            A=M-1
            M=-1

            (END_COMPARISON_5)
            

            //// load constant ////
            @892
            D=A
            

            //// push to stack ////
            @SP
            A=M
            M=D
            @SP
            M=M+1
            

            //// load constant ////
            @891
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
            

            //// perform comparison on stack head and D ////
            // if the comparison is true stack is set to = -1 else 0

            // D=x-y
            @SP
            A=M-1
            D=M-D

            // check condition
            @SET_TO_TRUE_6
            D;JLT

            // condition did not trigger, so x=false (x=0)
            @SP
            A=M-1
            M=0
            @END_COMPARISON_7
            0;JMP

            // condition triggered, so x=true (x=-1)
            (SET_TO_TRUE_6)
            @SP
            A=M-1
            M=-1

            (END_COMPARISON_7)
            

            //// load constant ////
            @891
            D=A
            

            //// push to stack ////
            @SP
            A=M
            M=D
            @SP
            M=M+1
            

            //// load constant ////
            @892
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
            

            //// perform comparison on stack head and D ////
            // if the comparison is true stack is set to = -1 else 0

            // D=x-y
            @SP
            A=M-1
            D=M-D

            // check condition
            @SET_TO_TRUE_8
            D;JLT

            // condition did not trigger, so x=false (x=0)
            @SP
            A=M-1
            M=0
            @END_COMPARISON_9
            0;JMP

            // condition triggered, so x=true (x=-1)
            (SET_TO_TRUE_8)
            @SP
            A=M-1
            M=-1

            (END_COMPARISON_9)
            

            //// load constant ////
            @891
            D=A
            

            //// push to stack ////
            @SP
            A=M
            M=D
            @SP
            M=M+1
            

            //// load constant ////
            @891
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
            

            //// perform comparison on stack head and D ////
            // if the comparison is true stack is set to = -1 else 0

            // D=x-y
            @SP
            A=M-1
            D=M-D

            // check condition
            @SET_TO_TRUE_10
            D;JLT

            // condition did not trigger, so x=false (x=0)
            @SP
            A=M-1
            M=0
            @END_COMPARISON_11
            0;JMP

            // condition triggered, so x=true (x=-1)
            (SET_TO_TRUE_10)
            @SP
            A=M-1
            M=-1

            (END_COMPARISON_11)
            

            //// load constant ////
            @32767
            D=A
            

            //// push to stack ////
            @SP
            A=M
            M=D
            @SP
            M=M+1
            

            //// load constant ////
            @32766
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
            

            //// perform comparison on stack head and D ////
            // if the comparison is true stack is set to = -1 else 0

            // D=x-y
            @SP
            A=M-1
            D=M-D

            // check condition
            @SET_TO_TRUE_12
            D;JGT

            // condition did not trigger, so x=false (x=0)
            @SP
            A=M-1
            M=0
            @END_COMPARISON_13
            0;JMP

            // condition triggered, so x=true (x=-1)
            (SET_TO_TRUE_12)
            @SP
            A=M-1
            M=-1

            (END_COMPARISON_13)
            

            //// load constant ////
            @32766
            D=A
            

            //// push to stack ////
            @SP
            A=M
            M=D
            @SP
            M=M+1
            

            //// load constant ////
            @32767
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
            

            //// perform comparison on stack head and D ////
            // if the comparison is true stack is set to = -1 else 0

            // D=x-y
            @SP
            A=M-1
            D=M-D

            // check condition
            @SET_TO_TRUE_14
            D;JGT

            // condition did not trigger, so x=false (x=0)
            @SP
            A=M-1
            M=0
            @END_COMPARISON_15
            0;JMP

            // condition triggered, so x=true (x=-1)
            (SET_TO_TRUE_14)
            @SP
            A=M-1
            M=-1

            (END_COMPARISON_15)
            

            //// load constant ////
            @32766
            D=A
            

            //// push to stack ////
            @SP
            A=M
            M=D
            @SP
            M=M+1
            

            //// load constant ////
            @32766
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
            

            //// perform comparison on stack head and D ////
            // if the comparison is true stack is set to = -1 else 0

            // D=x-y
            @SP
            A=M-1
            D=M-D

            // check condition
            @SET_TO_TRUE_16
            D;JGT

            // condition did not trigger, so x=false (x=0)
            @SP
            A=M-1
            M=0
            @END_COMPARISON_17
            0;JMP

            // condition triggered, so x=true (x=-1)
            (SET_TO_TRUE_16)
            @SP
            A=M-1
            M=-1

            (END_COMPARISON_17)
            

            //// load constant ////
            @57
            D=A
            

            //// push to stack ////
            @SP
            A=M
            M=D
            @SP
            M=M+1
            

            //// load constant ////
            @31
            D=A
            

            //// push to stack ////
            @SP
            A=M
            M=D
            @SP
            M=M+1
            

            //// load constant ////
            @53
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
            

            //// load constant ////
            @112
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
            M=M-D
            

            //// apply unary op to stack head ////
            @SP
            A=M-1
            M=-M
            

            //// pop stack ///
            @SP
            AM=M-1
            D=M
            

            //// apply binary op to stack head and D ////
            @SP
            A=M-1
            M=D&M
            

            //// load constant ////
            @82
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
            M=D|M
            

            //// apply unary op to stack head ////
            @SP
            A=M-1
            M=!M
            

