
    @256
    D=A
    @SP
    M=D
    
            
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
    @SET_TO_TRUE_1
    D;JEQ

    // condition did not trigger, so set head=false=0
    @SP
    A=M-1
    M=0
    @END_COMPARISON_1
    0;JMP

    // condition triggered, so x=true=-1
    (SET_TO_TRUE_1)
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
    @END_COMPARISON_2
    0;JMP

    // condition triggered, so x=true=-1
    (SET_TO_TRUE_2)
    @SP
    A=M-1
    M=-1

    (END_COMPARISON_2)
    
            
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
    @SET_TO_TRUE_3
    D;JEQ

    // condition did not trigger, so set head=false=0
    @SP
    A=M-1
    M=0
    @END_COMPARISON_3
    0;JMP

    // condition triggered, so x=true=-1
    (SET_TO_TRUE_3)
    @SP
    A=M-1
    M=-1

    (END_COMPARISON_3)
    
            
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
    @SET_TO_TRUE_4
    D;JLT

    // condition did not trigger, so set head=false=0
    @SP
    A=M-1
    M=0
    @END_COMPARISON_4
    0;JMP

    // condition triggered, so x=true=-1
    (SET_TO_TRUE_4)
    @SP
    A=M-1
    M=-1

    (END_COMPARISON_4)
    
            
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
    @SET_TO_TRUE_5
    D;JLT

    // condition did not trigger, so set head=false=0
    @SP
    A=M-1
    M=0
    @END_COMPARISON_5
    0;JMP

    // condition triggered, so x=true=-1
    (SET_TO_TRUE_5)
    @SP
    A=M-1
    M=-1

    (END_COMPARISON_5)
    
            
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
    @SET_TO_TRUE_6
    D;JLT

    // condition did not trigger, so set head=false=0
    @SP
    A=M-1
    M=0
    @END_COMPARISON_6
    0;JMP

    // condition triggered, so x=true=-1
    (SET_TO_TRUE_6)
    @SP
    A=M-1
    M=-1

    (END_COMPARISON_6)
    
            
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
    @SET_TO_TRUE_7
    D;JGT

    // condition did not trigger, so set head=false=0
    @SP
    A=M-1
    M=0
    @END_COMPARISON_7
    0;JMP

    // condition triggered, so x=true=-1
    (SET_TO_TRUE_7)
    @SP
    A=M-1
    M=-1

    (END_COMPARISON_7)
    
            
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
    @SET_TO_TRUE_8
    D;JGT

    // condition did not trigger, so set head=false=0
    @SP
    A=M-1
    M=0
    @END_COMPARISON_8
    0;JMP

    // condition triggered, so x=true=-1
    (SET_TO_TRUE_8)
    @SP
    A=M-1
    M=-1

    (END_COMPARISON_8)
    
            
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
    @SET_TO_TRUE_9
    D;JGT

    // condition did not trigger, so set head=false=0
    @SP
    A=M-1
    M=0
    @END_COMPARISON_9
    0;JMP

    // condition triggered, so x=true=-1
    (SET_TO_TRUE_9)
    @SP
    A=M-1
    M=-1

    (END_COMPARISON_9)
    
            
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
    
