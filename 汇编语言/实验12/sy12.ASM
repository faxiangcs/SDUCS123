DATA 		SEGMENT
MUSPINLV   	DW	262, 294, 330, 262; 频率决定音高
			DW 	262, 294, 330, 262
			DW 	330, 349, 392
			DW	330, 349, 392;
			DW	392, 440, 392, 349, 330, 262
			DW	392, 440, 392, 349, 330, 262
			DW	294, 196, 262
			DW	294, 196, 262
			;
MUSJIEPAI   	DW 	2500, 2500, 2500, 2500; 节拍决定音长 
			DW	2500, 2500, 2500, 2500 
			DW	2500, 2500, 5000, 2500
			DW	2500, 5000, 1200, 1200
			DW	1200, 1200, 2500, 2500
			DW	1200, 1200, 1200, 1200
			DW	2500, 2500, 2500, 2500
			DW	5000, 2500, 2500, 5000
			;
MESSONE		DB	' ','$'
			;
MES			DB 31H, 32H, 33H, 31H, 31H, 32H, 33H, 31H, 33H, 34H, 35H, 33H, 34H, 35H, 35H, 36H
			DB 35H, 34H, 33H, 31H, 35H, 36H, 35H, 34H, 33H, 31H, 32H, 35H, 31H, 32H, 35H, 31H, '$'
DATA		ENDS

CODESG 		SEGMENT
MAIN    	PROC   		FAR
			ASSUME 		CS : CODESG, DS : DATA
			ORG    		100H; 链接器将之后的程序放在0100H的开始位置
; ---------------------------------------------------- 
START:
			
			PUSH 		DS
			SUB  		AX, AX
			PUSH 		AX
			
			MOV  		AX, DATA
			MOV  		DS, AX
			;
			LEA  		DI, MUSPINLV	; 频率
			LEA  		BX, MUSJIEPAI	; 节拍
			LEA  		SI, MES			; 音符
			MOV  		CX, 32D
NEWPART:
			CALL 		SOUND
			ADD  		DI, 2
			ADD  		BX, 2
			ADD  		SI, 1
			MOV  		CX, 0FFFFH
SILENT:
			LOOP 		SILENT
			LOOP 		NEWPART
			MOV  		AL, 48H
			OUT  		61H, AL
			MOV  		AH, 4CH
			INT  		21H
			RET
MAIN 		ENDP

SOUND 		PROC 		NEAR
			PUSH		CX
			;
			MOV  		AH, 02H; 利用中断21H的02功能调用，显示音符简谱
			MOV  		DX, [SI]
			INT  		21H
			;
			LEA			DX,MESSONE
			MOV			AH,09H
			INT 		21H
			;
			IN  		AL, 61H
			AND 		AL, 11111100B
SING:
			XOR 		AL, 2; 将PB1置1，打开扬声器
			OUT  		61H, AL
			;
			CALL 		WIDNTH
			MOV  		CX, DX
WAITS:
			LOOP 		WAITS; 循环延迟，由此控制开关电路所产生脉冲的频率
			DEC  		WORD PTR[BX]; 实现相应节拍的声音
			JNZ  		SING
			;
			AND 		AL, 11111100B; 关闭扬声器
			OUT  		61H, AL
			;
			POP			CX
			RET; 一轮实现了一个音的输出
SOUND 		ENDP


WIDNTH 		PROC 		NEAR; 控制脉宽的计数值
			PUSH 		AX
			;
			MOV  		AX, 2801
			PUSH 		BX; 保存的是节拍
			MOV  		BX, 50
			MUL  		BX
			DIV  		WORD PTR[DI]; 除以了相应的频率
			MOV  		DX, AX;(dx) = 1/(2*freq)
			POP  		BX
			;
			POP  		AX
			RET
WIDNTH 		ENDP

CODESG 		ENDS

END 		START

