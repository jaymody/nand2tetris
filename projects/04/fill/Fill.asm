// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Fill.asm

// Runs an infinite loop that listens to the keyboard input.
// When a key is pressed (any key), the program blackens the screen,
// i.e. writes "black" in every pixel;
// the screen should remain fully black as long as the key is pressed.
// When no key is pressed, the program clears the screen, i.e. writes
// "white" in every pixel;
// the screen should remain fully clear as long as no key is pressed.

(LOOP)
    @i // iterator variable
    M=1

    @16384 // top-left screen address
    D=A

    @loc // location of the current word of pixels we'd like to fill
    M=D

    @color // White.
    M=0 // 0 = 00000... in binary, aka all pixels are white

    @24576 // keyboard address
    D=M

    @FILL_LOOP // skip to fill if key is not pressed, else we change the fill color to black
    D;JEQ

    @color // Black.
    M=-1 // -1 = 11111... in binary, aka all pixels are black

    (FILL_LOOP)
        // while i < 8192
        @i
        D=M
        @8192 // number of total screen addresses = nrows*ncols/wordsize = 256*512/16 = 8192
        D=D-A
        @LOOP
        D;JGT

        // fill with color
        @color
        D=M
        @loc
        A=M
        M=D

        // increment i and loc
        @i
        M=M+1
        @loc
        M=M+1

        // loop back
        @FILL_LOOP
        0;JMP
