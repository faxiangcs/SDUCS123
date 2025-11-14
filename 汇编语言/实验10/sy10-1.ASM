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
		MOV		BL,10H;DL里记录此时需要输出的ASCII码对应的字符
		MOV		CX,15;15行
LOOPONE:
		;output函数输出每一行的内容
		CALL  	COUT;输出15行（因为每两行之间要回车换行）
		LOOP	LOOPONE
		;
		RET
MAIN 	ENDP
;
COUT	PROC	NEAR
		;将CX的内容压入栈内
		PUSH	CX
		;将此时的CX的内容修改为16（每行有16列）
		MOV		CX,16
LOOPTWO:
		MOV		DL,BL
		MOV		AH,02H
		INT		21H
		;
		INC		BL;BL++
		
		MOV		DL,0
		MOV		AH,02H
		INT		21H
		;
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
