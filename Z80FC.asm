        ORG 32768          ;0   Start of machine code
                           ;The first number in each comment are T states each instruction takes
        LD HL, 0           ;10 Reset counter (HL = 0)
        LD D, 0            ;7 Store last MIC state
        LD B,155           ;  timer : 1 second~ 350877 Tcycles
        LD C,255           ;  timer :       
        
MainLoopDelay:

        NOP                ;4 This NOP's exist to compensate T states in lines 41,42,43.
                           ; If rising edge, jumps sonner does not execute those lines
        NOP                ;4
        NOP                ;4
        NOP                ;4                        

MainLoop:

        DEC C             ;4   timing block START
        JP Z, decB        ;10
        JP continue       ;10 
decB:
        LD C, 255         ;7
        DEC B             ;4
        JP Z, retBlock    ;10    timing block END

continue:
        
        IN A, (0xFE)       ;11 Read MIC port (bit 3 = EAR)
        AND 8              ;7 Mask out everything but bit 3
        LD E, A            ;4 Save current MIC value
        LD A, D            ;4 Load previous MIC
        CPL                ;4 Invert bits
        LD D, E            ;4 Update last MIC state
        AND E              ;4 Detect rising edge
        JP Z, MainLoopDelay;10 NO rising edge  
        
        INC HL             ;6 Count a rising edge
        LD D, E            ;4 Update last MIC state
        JP MainLoop        ;10

retBlock:

        LD (60000), HL     ;16 Store result at address 60000 
        RET                ;10
        
