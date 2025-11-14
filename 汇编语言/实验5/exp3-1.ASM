TITLE GUN-Makes machine gun sound
;				fires fixed number of shots
;*********************************************************
PROGRAM	SEGMENT	;define code segment
;---------------------------------------------------------
MAIN	PROC	FAR    	;main part of program
		ASSUME	CS:PROGRAM
		ORG		100H		;程序加载到内存的初始偏移量为100H
START:
		MOV		CX,50D		;设置枪声数量
NEW_SHOT:
		PUSH	CX			;save count
		CALL	SHOOT		;sound of shot
		MOV	CX,4000H	;设置静默延迟
		
SILENT:
		LOOP	SILENT		;silent day
		POP		CX			;get shots count back
		LOOP	NEW_SHOT	;loop till shots done
		MOV	AL,48H		;返回DOS前输出端口的复位操作两条指令
		OUT		61H,AL		;reset output port
		INT		20H			;return to dos
MAIN	ENDP
;---------------------------------------
;SUBROUNTINE TO MAKE BRIEF NOISE
SHOOT	PROC	NEAR
		MOV	DX,140H		;初始化等待值
		MOV	BX,20H		;设置计数值
		IN		AL,61H		;获得端口61
		AND	AL,11111100B;关断定时器通道2的门控
SOUND:
		XOR		AL,2		;翻转指定位,触发61H端口第1位
		OUT		61H,AL	;get port 61
		ADD	DX,9248H;add random pattern
		MOV	CL,3		;循环位数
		ROR		DX,CL	;rotate it
		MOV	CX,DX	;DX是控制脉宽的计数值
		AND	CX,1FFH	;mask off upper 7 bits
		OR		CX,10	;ensure not too short
WAITT:
		LOOP	WAITT		;延时循环
;made noise long enough?
		DEC		BX		;done enough?
		JNZ		SOUND	;jump if not yet
;关闭扬声器 	
		AND	AL,11111100B
		OUT		61H,AL	;关闭bits 0,1 	
		RET
SHOOT	ENDP
;------------------------------------------------
PROGRAM	ENDS
;***********************************************
		END		START