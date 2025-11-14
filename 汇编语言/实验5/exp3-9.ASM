TITLE TYPE_EX --Test time for typing exercise
;------------------------------------------------
STACK	SEGMENT	PARA STACK 'STACK'
		DB		256  DUP(0)
TOP		LABEL	WORD
STACK	ENDS
;-----------------------------------------------
DATA	SEGMENT	PARA PUBLIC 'DATA'
BUFFER	DB		16H  DUP(0)
BUFPT1	DW		0
BUFPT2	DW		0
;	bufpt1 = bufpt2,the buffer is empty
KBFLAG	DB		0
PROMPT	DB		'*PLEASE PRACTISE TYPING*',0DH,0AH,'$'
SCANTAB	DB		0,0,'1234567890-=',8,0
		DB		'qwertyuiop[]',0DH,0
		DB		'asdfghjkl;',0,0,0,0
		DB		'zxcvbnm,./',0,0,0
		DB		' ',0,0,0,0,0,0,0,0,0,0,0,0,0
		DB		'789-456+1230.'
EVEN    ;使下一个变量或指令开始于偶数字节地址
OLDCS9	DW		?
OLDIP9	DW		?
;---------------------------------------------------------
STR1	DB		'abcd efgh ijkl mnop qrst uvwx yz.'
		DB		0DH,0AH,'$'
STR2	DB		'christmas is a time of joy and love.'
		DB		0DH,0AH,'$'
STR3	DB		'store window hold togs and gifts.'
		DB		0DH,0AH,'$'
STR4	DB		'people send christmas cards and gifts.'
		DB		0DH,0AH,'$'
STR5	DB		'santa wish all people peace on earth.'
CRLF	DB		0DH,0AH,0AH,'$'
COLON	DB		':','$'
EVEN
SADDR	DW		STR1,STR2,STR3,STR4,STR5
COUNT	DW		0
SEC		DW		0
MIN		DW		0
HOURS	DW		0
SAVE	DW		2 DUP(?)
DATA	ENDS
;----------------------------------------------------------
CODE	SEGMENT
		ASSUME	CS:CODE,DS:DATA,ES:DATA,SS:STACK
MAIN	PROC	FAR
START:
		MOV		AX,STACK	;建立栈
		MOV		SS,AX
		MOV		SP,OFFSET TOP
		
		PUSH		DS
		SUB			AX,AX
		PUSH		AX
		MOV		AX,DATA
		MOV		DS,AX
		MOV		ES,AX
		
		MOV		AH,35H		;保存键盘中断向量
		MOV		AL,09H
		INT			21H
		MOV		OLDCS9,ES	;保存偏移地址
		MOV		OLDIP9,BX	;保存段地址
		
		;设置自编处理程序的中断向量
		PUSH		DS			;设立中断向量
		MOV		DX,SEG KBINT
		MOV		DS,DX
		MOV		DX,OFFSET KBINT
		MOV		AL,09H		;中断类型放入AL
		MOV		AH,25H		;改变中断向量（自动禁止硬件中断）
		INT			21H
		POP			DS
		
		MOV		AH,35H		;保存时间中断向量
		MOV		AL,1CH
		INT			21H
		MOV		SAVE,BX
		MOV		SAVE+2,ES
		
		PUSH		DS			;设立客户中断向量
		MOV		DX,SEG CLINT
		MOV		DS,DX
		MOV		DX,OFFSET CLINT
		MOV		AL,1CH
		MOV		AH,25H
		INT			21H
		POP			DS
		
		;允许键盘和计时器中断
		IN			AL,21H		;清空键盘和计时器
		AND		AL,11111100B
		OUT			21H,AL
FIRST:
		MOV		AH,0
		MOV		AL,3
		INT			10H
		
		MOV		DX,OFFSET PROMPT
		MOV		AH,9
		INT			21H
		
		MOV		SI,0
NEXT:
		MOV		DX,SADDR[SI]
		MOV		AH,09H		;显示句子
		INT			21H
		
		MOV		COUNT,0
		MOV		SEC,0
		MOV		MIN,0
		MOV		HOURS,0
		
		STI
FOREVER:
		CALL		KBGET		;等待输入字符
		TEST		KBFLAG,80H
		JNZ			ENDINT
		PUSH		AX
		CALL		DISCHAR
		POP			AX
		CMP		AL,0DH
		JNZ			FOREVER
		MOV		AL,0AH
		CALL		DISCHAR
		
		CALL		DISTIME
		
		LEA			DX,CRLF
		MOV		AH,09H
		INT			21H
		
		ADD		SI,2
		CMP		SI,5*2
		JNE			NEXT
		JMP			FIRST
ENDINT:
		CLI
		PUSH		DS
		MOV		DX,SAVE
		MOV		AX,SAVE+2
		MOV		DS,AX
		MOV		AL,1CH		;reset interrupt vector
		MOV		AH,25H		;of type 1ch
		INT			21H
		POP			DS
		
		PUSH		DS
		MOV		DX,OLDIP9
		MOV		AX,OLDCS9
		MOV		DS,AX
		MOV		AL,09H		;of type 09h
		MOV		AH,25H
		INT			21H
		POP			DS
		
		STI
		RET						;return to DOS
MAIN	ENDP
;------------------------------------------------------
CLINT	PROC		NEAR
		PUSH		DS
		MOV		BX,DATA		;设置数据段
		MOV		DS,BX
		
		LEA			BX,COUNT
		INC			WORD PTR[BX]
		CMP		WORD PTR[BX],18	;1秒计数值增加18
		JNE			RETURN
		CALL		INCT
ADJ:
		CMP		HOURS,12
		JLE			RETURN
		SUB			HOURS,12
RETURN:
		POP			DS
		STI
		IRET
CLINT	ENDP
;--------------------------------------------
INCT	PROC		NEAR
		MOV		WORD PTR[BX],0
		ADD		BX,2
		INC			WORD PTR[BX]
		CMP		WORD PTR[BX],60
		JNE			EXIT
		CALL		INCT
EXIT:
		RET
INCT	ENDP
;-----------------------------------------------
DISTIME	PROC		NEAR
		MOV		AX,MIN	;显示分钟
		CALL		BINDEC
		
		MOV		BX,0
		MOV		AL,':'	;显示：
		MOV		AH,0EH
		INT			10H		;在光标位置显示字符
		MOV		AX,SEC	;显示秒
		CALL		BINDEC
		
		MOV		BX,0
		MOV		AL,':'
		MOV		AH,0EH
		INT			10H
		
		MOV		BX,COUNT
		MOV		AL,55D
		MUL		BL
		CALL		BINDEC	;显示毫秒
		
		RET
DISTIME	ENDP
;---------------------------------------------
BINDEC	PROC		NEAR
		MOV		CX,100D
		CALL		DECDIV
		MOV		CX,10D
		CALL		DECDIV
		MOV		CX,1
		CALL		DECDIV
		RET
BINDEC	ENDP
;----------------------------------------------
DECDIV	PROC		FAR
		MOV		DX,0
		DIV			CX
		
		MOV		BX,0
		ADD		AL,30H	;转换成ascii码
		MOV		AH,0EH
		INT			10H
		
		MOV		AX,DX
		RET
DECDIV	ENDP
;-----------------------------------------------
KBGET	PROC	NEAR
		PUSH		BX
		CLI
		MOV		BX,BUFPT1
		CMP		BX,BUFPT2
		JNZ			KBGET2	;缓冲区不为空
		CMP		KBFLAG,0
		JNZ			KBGET3
		STI
		POP			BX
		JMP			KBGET
KBGET2:
		MOV		AL,[BUFFER+BX]
		INC			BX
		CMP		BX,16
		JC			KBGET3	;进位则跳转
		MOV		BX,0
KBGET3:
		MOV		BUFPT1,BX
		POP			BX
		RET
KBGET	ENDP
;--------------------------------------------------
KBINT	PROC	FAR
		PUSH	BX
		PUSH	AX
		
		;CPU读取扫描码并发出应答信号
		IN		AL,60H		;读入字符（扫描码）
		PUSH	AX			;保存
		IN		AL,61H		;获得控制端口
		OR		AL,80H		;设标志位
		OUT		61H,AL
		AND	AL,7FH		;重置标志位
		OUT		61H,AL
		
		POP		AX			;恢复扫描编码
		TEST	AL,80H		
		JNZ		KBINT2
		MOV	BX,OFFSET SCANTAB
		XLAT	SCANTAB		;查表转换指令，将DS:[BX+AL]内容送至AX
		CMP	AL,0
		JNZ		KBINT4
		MOV	KBFLAG,80H
		JMP		KBINT2
KBINT4:
		MOV	BX,BUFPT2
		MOV	[BUFFER+BX],AL
		INC		BX
		CMP	BX,16
		JC		KBINT3
		MOV	BX,0
KBINT3:
		CMP	BX,BUFPT1	;缓冲区是否满
		JZ		KBINT2
		MOV	BUFPT2,BX
		;CLI
KBINT2:
		CLI;;;;;;;;;;
		MOV	AL,20H
		OUT		20H,AL
		POP		AX
		POP		BX
		STI
		IRET
KBINT	ENDP
;------------------------------------------------
DISCHAR	PROC	NEAR
		PUSH	BX
		MOV	BX,0
		MOV	AH,0EH
		INT		10H
		POP		BX
		RET
DISCHAR	ENDP
;-------------------------------------------------
CODE	ENDS
		END		START