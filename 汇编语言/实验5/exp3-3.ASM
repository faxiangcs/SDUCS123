TITLE DRAW -- Program to draw on screen with
;	cursor arrows,character write to video memory
;----------------------------------
READ_C		EQU		0H		;读字符编码
KEY_ROM	EQU		16H		;ROM键盘路径
UP			EQU		48H		;scan code for up arrow
DOWN		EQU		50H		;scan code for down arrow
RIGHT		EQU		4DH		;scan code for right arrow
LEFT	EQU		4BH				;scan code for left arrow
BLOCK		EQU		0DBH	;solid graphics character
;ESC			EQU		1BH		;escape key
;********************************
VIDEO	SEGMENT AT 0B800H	;将段地址指定在
WD_BUFF	LABEL	WORD
V_BUFF	DB		25*80*2 DUP(?)
VIDEO	ENDS
;******************************************
PROGRAM	SEGMENT
;-------------------------------------------
MAIN	PROC	FAR
		ASSUME 	CS:PROGRAM,ES:VIDEO
START:
		PUSH		DS
		SUB			AX,AX
		PUSH		AX
;set ES to extra segment
		MOV		AX,VIDEO
		MOV		ES,AX
;清除屏幕
		MOV		CX,80*25
		MOV		BX,0		;缓冲区开始
CLEAR:
		MOV		ES:[WD_BUFF+BX],0700H
		INC			BX		;incr pointer
		INC			BX		;twice
		LOOP		CLEAR	;do again
;screen pointer will be in CX register
;行（0-24D）在CH
;列（0-79D）在CL
;将屏幕指针移到屏幕中心
		MOV		CH,12D
		MOV		CL,40D
;从键盘获取字符
GET_CHAR:
		MOV		AH,READ_C
		INT			KEY_ROM		;调用键盘I/O ROM
		CMP		AL,27			;is it escape?
		JZ			EXIT
		MOV		AL,AH			;put scan code in AL
		CMP		AL,UP			;is it UP arrow?
		JNZ			NOT_UP
		DEC			CH
NOT_UP:
		CMP		AL,DOWN		;is it DOWN arrow?
		JNZ			NOT_DOWN		
		INC			CH
NOT_DOWN:
		CMP		AL,RIGHT		;is it RIGHT arrow?
		JNZ			NOT_RIGHT
		INC			CL
NOT_RIGHT:
		CMP		AL,LEFT			;is it LEFT arrow?
		JNZ			LITE_IT
		DEC			CL
LITE_IT:
		MOV		AL,160D		;每行写入AL的字节
		MUL		CH			;结果在AX
		MOV		BL,CL		;#of columns in BL
		ROL			BL,1			;times 2 to get bytes
		MOV		BH,0		;clear top part of BX
		ADD		BX,AX		;add AX to it
;address offset in BX . Put block char here
		MOV		AL,BLOCK
		MOV		ES:[V_BUFF+BX],AL
		JMP			GET_CHAR
EXIT:	RET
MAIN	ENDP
;------------------------------------------------
PROGRAM	ENDS
;*****************************************************
		END		START