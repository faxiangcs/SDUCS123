DATA		SEGMENT
COUNT		DB			3 DUP(?);COUNT数组
BUFSIZE		DB			101
SSIZE		DB			?
BUF			DB			101 dup(?)
BIGNUM		DB			0;大写字母的个数
MESS1		DB			0DH,0AH,'$';回车换行
SAMNUM		DB			0;小写字母的个数
NUMSUM		DB			0;数字的个数
CHARNUM		DB			0;其他字符的个数
DATA		ENDS
;
CODE 			SEGMENT
				ASSUME DS :DATA ,CS :CODE
MAIN	PROC 	FAR
START:
		PUSH	DS
		SUB		AX,AX
		PUSH	AX
		;
		MOV		AX,DATA
		MOV		DS,AX
		;0AH号调用,读取输入的字符串
		LEA		DX,BUFSIZE
		MOV		AH,0AH
		INT 	21H
		;CL记录读入的字符串的个数（不包括返回值）
		MOV		CH,0
		MOV		CL,SSIZE
		;
		XOR		SI,SI;清空SI寄存器，SI用来当BUF数组的index
XH:
NUMBER:
		;判断数字
		CMP		BUF[SI],'0'
		CMP		BUF[SI],'9'
		JA		BIG;如果不是数字先跳转到大写字母部分
		INC		NUMSUM;否则NUMSUM++
		INC		SI
		DEC		CX
		CMP		CX,0;比较CX和0的大小
		JE		CIN;如果CX为0跳转到CIN
		JMP		XH;否则跳回XH
BIG:
		;判断大写
		CMP		BUF[SI],'A'
		JB		UNKNOW
		CMP		BUF[SI],'Z'
		JA		SAML;如果不是大写字母先跳转到小写字母部分
		INC		BIGNUM;否则BIGNUM++
		INC		SI
		DEC		CX
		CMP		CX,0
		JE		CIN
		JMP		XH
SAML:
		;判断小写
		CMP		BUF[SI],'a'
		JB		UNKNOW
		CMP		BUF[SI],'z'
		JA		UNKNOW;如果不是小写字母先跳转到UNKNOW
		INC		SAMNUM;否则SAMNUM++
		INC		SI
		DEC		CX
		CMP		CX,0
		JE		CIN
		JMP		XH
		
CIN:;把小写字母、大写字母还要数字的个数写入count数组里
		;count[0] = SAMNUM
		XOR		SI,SI
		MOV		AL,SAMNUM
		MOV		COUNT[SI],AL
		INC		SI
		;count[1] = BIGNUM
		MOV		AL,BIGNUM
		MOV		COUNT[SI],AL
		INC		SI
		;count[2] = NUMSUM
		MOV		AL,NUMSUM
		MOV		COUNT[SI],AL
CUN:
		LEA		DX,MESS1
		MOV		AH,09H
		INT 	21H
		CALL	JS1;输出小写字母的个数
		;
		CALL	JS2;输出大写字母的个数
		;
		LEA		DX,MESS1
		MOV		AH,09H
		INT 	21H
		;
		CALL	JS3;输出数字的个数
		;
UNKNOW:
		RET
MAIN 	ENDP
;
JS1		PROC	NEAR
		;把每一位对应的数值转换成相应的ASCII
		MOV		AX,0
		MOV		BX,0
		MOV		BL,10
		MOV		AL,SAMNUM
		DIV		BL
		MOV		BH,AH
		CMP		AL,0
		JZ		HERE1
		ADD		AL,30H
		MOV		DL,AL
		MOV		AH,02H
		INT 	21H
HERE1:
		ADD		BH,30H
		MOV		DL,BH
		MOV		AH,02H
		INT 	21H
		LEA		DX,MESS1
		MOV		AH,09H
		INT 	21H
		RET
JS1		ENDP
;
;
JS2		PROC	NEAR
		MOV		AX,0
		MOV		BX,0
		MOV		BL,10
		MOV		AL,BIGNUM
		DIV		BL
		MOV		BH,AH
		CMP		AL,0
		JZ		HERE2
		ADD		AL,30H
		MOV		DL,AL
		MOV		AH,02H
		INT 	21H
HERE2:
		ADD		BH,30H
		MOV		DL,BH
		MOV		AH,02H
		INT 	21H
		RET
JS2		ENDP
;
;
JS3		PROC	NEAR
		MOV		AX,0
		MOV		BX,0
		MOV		BL,10
		MOV		AL,NUMSUM
		DIV		BL
		MOV		BH,AH
		CMP		AL,0
		JZ		HERE3
		ADD		AL,30H
		MOV		DL,AL
		MOV		AH,02H
		INT 	21H
HERE3:
		ADD		BH,30H
		MOV		DL,BH
		MOV		AH,02H
		INT 	21H
		RET
JS3		ENDP
;
CODE 	ENDS
		END 	MAIN
		