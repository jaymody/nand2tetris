
            @17
            D=A
            

            @SP
            A=M
            M=D
            @SP
            M=M+1
            

            @17
            D=A
            

            @SP
            A=M
            M=D
            @SP
            M=M+1
            

            @SP
            AM=M-1
            D=M
            

            // D = head - stack.pop()
            @SP
            A=M-1
            D=M-D

            // check condition
            @SET_TO_TRUE_0
            D;JEQ

            // condition did not trigger, so set head=false=0
            @SP
            A=M-1
            M=0
            @END_COMPARISON_1
            0;JMP

            // condition triggered, so x=true=-1
            (SET_TO_TRUE_0)
            @SP
            A=M-1
            M=-1

            (END_COMPARISON_1)
            

            @17
            D=A
            

            @SP
            A=M
            M=D
            @SP
            M=M+1
            

            @16
            D=A
            

            @SP
            A=M
            M=D
            @SP
            M=M+1
            

            @SP
            AM=M-1
            D=M
            

            // D = head - stack.pop()
            @SP
            A=M-1
            D=M-D

            // check condition
            @SET_TO_TRUE_2
            D;JEQ

            // condition did not trigger, so set head=false=0
            @SP
            A=M-1
            M=0
            @END_COMPARISON_3
            0;JMP

            // condition triggered, so x=true=-1
            (SET_TO_TRUE_2)
            @SP
            A=M-1
            M=-1

            (END_COMPARISON_3)
            

            @16
            D=A
            

            @SP
            A=M
            M=D
            @SP
            M=M+1
            

            @17
            D=A
            

            @SP
            A=M
            M=D
            @SP
            M=M+1
            

            @SP
            AM=M-1
            D=M
            

            // D = head - stack.pop()
            @SP
            A=M-1
            D=M-D

            // check condition
            @SET_TO_TRUE_4
            D;JEQ

            // condition did not trigger, so set head=false=0
            @SP
            A=M-1
            M=0
            @END_COMPARISON_5
            0;JMP

            // condition triggered, so x=true=-1
            (SET_TO_TRUE_4)
            @SP
            A=M-1
            M=-1

            (END_COMPARISON_5)
            

            @892
            D=A
            

            @SP
            A=M
            M=D
            @SP
            M=M+1
            

            @891
            D=A
            

            @SP
            A=M
            M=D
            @SP
            M=M+1
            

            @SP
            AM=M-1
            D=M
            

            // D = head - stack.pop()
            @SP
            A=M-1
            D=M-D

            // check condition
            @SET_TO_TRUE_6
            D;JLT

            // condition did not trigger, so set head=false=0
            @SP
            A=M-1
            M=0
            @END_COMPARISON_7
            0;JMP

            // condition triggered, so x=true=-1
            (SET_TO_TRUE_6)
            @SP
            A=M-1
            M=-1

            (END_COMPARISON_7)
            

            @891
            D=A
            

            @SP
            A=M
            M=D
            @SP
            M=M+1
            

            @892
            D=A
            

            @SP
            A=M
            M=D
            @SP
            M=M+1
            

            @SP
            AM=M-1
            D=M
            

            // D = head - stack.pop()
            @SP
            A=M-1
            D=M-D

            // check condition
            @SET_TO_TRUE_8
            D;JLT

            // condition did not trigger, so set head=false=0
            @SP
            A=M-1
            M=0
            @END_COMPARISON_9
            0;JMP

            // condition triggered, so x=true=-1
            (SET_TO_TRUE_8)
            @SP
            A=M-1
            M=-1

            (END_COMPARISON_9)
            

            @891
            D=A
            

            @SP
            A=M
            M=D
            @SP
            M=M+1
            

            @891
            D=A
            

            @SP
            A=M
            M=D
            @SP
            M=M+1
            

            @SP
            AM=M-1
            D=M
            

            // D = head - stack.pop()
            @SP
            A=M-1
            D=M-D

            // check condition
            @SET_TO_TRUE_10
            D;JLT

            // condition did not trigger, so set head=false=0
            @SP
            A=M-1
            M=0
            @END_COMPARISON_11
            0;JMP

            // condition triggered, so x=true=-1
            (SET_TO_TRUE_10)
            @SP
            A=M-1
            M=-1

            (END_COMPARISON_11)
            

            @32767
            D=A
            

            @SP
            A=M
            M=D
            @SP
            M=M+1
            

            @32766
            D=A
            

            @SP
            A=M
            M=D
            @SP
            M=M+1
            

            @SP
            AM=M-1
            D=M
            

            // D = head - stack.pop()
            @SP
            A=M-1
            D=M-D

            // check condition
            @SET_TO_TRUE_12
            D;JGT

            // condition did not trigger, so set head=false=0
            @SP
            A=M-1
            M=0
            @END_COMPARISON_13
            0;JMP

            // condition triggered, so x=true=-1
            (SET_TO_TRUE_12)
            @SP
            A=M-1
            M=-1

            (END_COMPARISON_13)
            

            @32766
            D=A
            

            @SP
            A=M
            M=D
            @SP
            M=M+1
            

            @32767
            D=A
            

            @SP
            A=M
            M=D
            @SP
            M=M+1
            

            @SP
            AM=M-1
            D=M
            

            // D = head - stack.pop()
            @SP
            A=M-1
            D=M-D

            // check condition
            @SET_TO_TRUE_14
            D;JGT

            // condition did not trigger, so set head=false=0
            @SP
            A=M-1
            M=0
            @END_COMPARISON_15
            0;JMP

            // condition triggered, so x=true=-1
            (SET_TO_TRUE_14)
            @SP
            A=M-1
            M=-1

            (END_COMPARISON_15)
            

            @32766
            D=A
            

            @SP
            A=M
            M=D
            @SP
            M=M+1
            

            @32766
            D=A
            

            @SP
            A=M
            M=D
            @SP
            M=M+1
            

            @SP
            AM=M-1
            D=M
            

            // D = head - stack.pop()
            @SP
            A=M-1
            D=M-D

            // check condition
            @SET_TO_TRUE_16
            D;JGT

            // condition did not trigger, so set head=false=0
            @SP
            A=M-1
            M=0
            @END_COMPARISON_17
            0;JMP

            // condition triggered, so x=true=-1
            (SET_TO_TRUE_16)
            @SP
            A=M-1
            M=-1

            (END_COMPARISON_17)
            

            @57
            D=A
            

            @SP
            A=M
            M=D
            @SP
            M=M+1
            

            @31
            D=A
            

            @SP
            A=M
            M=D
            @SP
            M=M+1
            

            @53
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
            

            @112
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
            A=M-1
            M=-M
            

            @SP
            AM=M-1
            D=M
            

            @SP
            A=M-1
            M=D&M
            

            @82
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
            M=D|M
            

            @SP
            A=M-1
            M=!M
            

