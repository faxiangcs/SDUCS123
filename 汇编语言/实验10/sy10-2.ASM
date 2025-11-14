DATA			SEGMENT
CRLF 			DB 			0AH,0DH,'$'
DATA			ENDS
;
CODE 			SEGMENT
				ASSUME DS :DATA ,CS :CODE
MAIN	PROC 	FAR
START:
		;起始部分
		PUSH	DS
		SUB		AX,AX
		PUSH	AX
		MOV		AX,DATA
		MOV		DS,AX
		;
		MOV		BL,21H
		MOV		CX,11;11行
LOOPONE:
		CALL  	COUT;输出11行
		LOOP	LOOPONE
		;
		RET
MAIN 	ENDP
;
COUT	PROC	NEAR
		;将CX的内容压入栈内
		PUSH	CX
		
		MOV		CX,20
LOOPTWO:
		;将BL里的内容输出到显示屏上
		MOV		DL,BL
		MOV		AH,02H
		INT		21H
		INC		BL
		MOV		DL,0
		MOV		AH,02H
		INT		21H
		LOOP	LOOPTWO
		;输出回车换行
		LEA		DX,CRLF
		MOV		AH,09H
		INT		21H
		;还原CX里的内容
		POP		CX
		RET
COUT	ENDP
;
CODE 	ENDS
		END 	MAIN
