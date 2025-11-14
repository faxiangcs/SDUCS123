DATAREA         SEGMENT
MESSAGE1        DB          'N = ?',0AH,0DH,'$'
MESSAGE2        DB          'What is the name of spindle X ?'
                DB          0AH,0DH,'$'
MESSAGE3        DB          'What is the name of spindle Y ?'
                DB          0AH,0DH,'$'
MESSAGE4        DB          'What is the name of spindle Z ?'
                DB          0AH,0DH,'$'
FLAG            DW          0
CONSTANT        DW          10000,1000,100,10,1
MESS_GETNAME    DB          'PLEASE INPUT FILENAME:',0DH, 0AH,'$'
DATAREA         ENDS
;***********************************************************
PROGNAM         SEGMENT ; Define code segment
;-----------------------------------------------------------
MAIN            PROC        FAR
                ASSUME      CS:PROGNAM,DS:DATAREA
START:
    ; Set up stack for return
                PUSH        DS
                SUB         AX,AX
                PUSH        AX
    ; Set DS register to current data segment
                MOV         AX,DATAREA
                MOV         DS,AX
    ; MAIN PART OF PROGRAM GOES HERE
                ; Display the content of MESSAGE1
                LEA         DX,MESSAGE1
                MOV         AH,09H
                INT         21H
                ; Execute the DECIBIN function to get the value of N (BX = N)
                CALL        DECIBIN
                ; Output carriage return and line feed
                CALL        CRLF
                ; First compare BX (N) to 0
                CMP         BX,0
                JZ          EXITT ; If BX = 0, jump
                ; Display the content of MESSAGE2
                LEA         DX,MESSAGE2
                MOV         AH,09H
                INT         21H
                ; Input a character from the keyboard, save its ASCII code in AL, and display it on the screen
                MOV         AH,01H
                INT         21H
                MOV         AH,0
                ; Save the ASCII code of X in CX
                MOV         CX,AX
                CALL        CRLF
                ; Display the content of MESSAGE3
                LEA         DX,MESSAGE3
                MOV         AH,09H
                INT         21H
                ; Input a character from the keyboard, save its ASCII code in AL, and display it on the screen
                MOV         AH,01H
                INT         21H
                MOV         AH,0
                ; Save the ASCII code of Y in SI
                MOV         SI,AX
                CALL        CRLF
                ; Display the content of MESSAGE4
                LEA         DX,MESSAGE4
                MOV         AH,09H
                INT         21H
                ; Input a character from the keyboard, save its ASCII code in AL, and display it on the screen
                MOV         AH,01H
                INT         21H
                MOV         AH,0
                ; Save the ASCII code of Z in DI
                MOV         DI,AX
                CALL        CRLF
                ; Execute the Tower of Hanoi function
                CALL        HANOI
    ;
EXITT:
                RET
    ;
MAIN            ENDP
;-----------------------------------------------------------
HANOI           PROC        NEAR
; Solves Tower of Hanoi puzzle
; Arguments: (BX) = N, (CX) = X, (SI) = Y, (DI) = Z
                CMP         BX,1
                JE          BASIS ; If BX = 1, jump to BASIS
                CALL        SAVE
                ; Move the top N-1 disks from X to Y via Z
                DEC         BX
                XCHG        SI,DI
                CALL        HANOI
                CALL        RESTOR
                CALL        PRINT ; Move the bottom disk from X to Z (output this process)
                ; Move the remaining N-1 disks from Y to Z via X
                DEC         BX
                XCHG        CX,SI
                CALL        HANOI
                JMP         RETURN
BASIS:
                CALL        PRINT
RETURN:
                RET
HANOI           ENDP
;-----------------------------------------------------------
PRINT           PROC        NEAR
; PRINT XNZ      ; Display output, print the content of DL
                MOV         DX,CX
                MOV         AH,02H
                INT         21H
                CALL        BINIDEC
                MOV         DX,DI
                MOV         AH,02H
                INT         21H
                CALL        CRLF
                RET
PRINT           ENDP
;-----------------------------------------------------------
SAVE            PROC        NEAR
; Push N, Y, X, Z onto the stack
                POP         BP
                PUSH        BX
                PUSH        CX
                PUSH        SI
                PUSH        DI
                PUSH        BP
                RET
SAVE            ENDP
;-----------------------------------------------------------
RESTOR          PROC        NEAR
; Pop Z, Y, X, N from the stack
                POP         BP
                POP         DI
                POP         SI
                POP         CX
                POP         BX
                PUSH        BP
                RET
RESTOR          ENDP
;-----------------------------------------------------------
DECIBIN         PROC        NEAR
; Procedure to convert decimal input from the keyboard to binary.
; Result is left in the BX register.
                MOV         BX,0
; Get digits from the keyboard and convert them to binary
NEWCHAR:
                ; Input a character from the keyboard, save its ASCII code in AL, and display it
                MOV         AH,1
                INT         21H
                SUB         AL,30H ; Convert ASCII to a number
                JL          EXIT1 ; If AL < 0, jump
                CMP         AL,9D ; Compare AL with 9
                JG          EXIT1 ; If AL > 9, jump
                CBW         ; Extend the sign bit of AL into AH
                ; Multiply the number in BX by 10
                XCHG        AX,BX
                MOV         CX,10D
                MUL         CX
                XCHG        AX,BX
                ; Add the digit in AX to the number in BX
                ADD         BX,AX
                JMP         NEWCHAR
EXIT1:
                RET
DECIBIN         ENDP
;-----------------------------------------------------------
BINIDEC         PROC        NEAR
; Procedure to convert a binary number in BX to a decimal number
; Display the result on the console screen
                ; Save the content of registers
                PUSH        BX
                PUSH        CX
                PUSH        SI
                PUSH        DI
                MOV         FLAG,0 ; FLAG (DW) = 0
                MOV         CX,5 ; CX = 5
                LEA         SI,CONSTANT
DEC_DIV:
                MOV         AX,BX ; AX = BX
                MOV         DX,0 ; DX = 0
                DIV         WORD PTR[SI] ; Divide by a word from CONSTANT
                MOV         BX,DX ; BX = DX
                MOV         DL,AL ; DL = AL
    ;
                CMP         FLAG,0
                JNZ         PRINT1 ; If FLAG != 0, jump to PRINT1
                CMP         DL,0
                JE          SKIP
                MOV         FLAG,1
    ; Print the content of DL on the screen
PRINT1:
                ADD         DL,30H ; DL = DL + 30H
                ; Print the content of DL
                MOV         AH,02H
                INT         21H
SKIP:           ; SI points to the next data
                ADD         SI,2
                LOOP        DEC_DIV
                ; Restore the content of registers
                POP         DI
                POP         SI
                POP         CX
                POP         BX
                RET
BINIDEC         ENDP
;-----------------------------------------------------------
CRLF            PROC        NEAR
; Print carriage return and line feed
                MOV         DL,0AH
                MOV         AH,02H
                INT         21H
    ;
                MOV         DL,0DH
                MOV         AH,02H
                INT         21H
    ;
                RET
CRLF            ENDP
;-----------------------------------------------------------
PROGNAM         ENDS
;-----------------------------------------------------------
                END         START
