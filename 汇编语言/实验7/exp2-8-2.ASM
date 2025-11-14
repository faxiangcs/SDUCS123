DATAREA 		SEGMENT
MESSAGE1		DB			'N = ?',0AH,0DH,'$'
MESSAGE2		DB			'What is the name of spindle X ?'
				DB			0AH,0DH,'$'
MESSAGE3		DB			'What is the name of spindle Y ?'
				DB			0AH,0DH,'$'
MESSAGE4		DB			'What is the name of spindle Z ?'
				DB			0AH,0DH,'$'
FLAG			DW			0
CONSTANT		DW			10000,1000,100,10,1
MESS_GETNAME 	DB 			'PLEASE INPUT FILENAME:',0DH, 0AH,'$'
MESS_GETNAME1 	DB 			'output.txt',00h
buf_size		db			80
s_size			db			?
buf				db			80 dup(?)
buffer1			db			100 dup(?)
handle			dw			?
handle1			dw			?
MESS_ERR2 		DB      	'FILE NOT FOUND !',0DH, 0AH,'$'
superbuf		dw			?
bufcrlf			db			0dh,0ah
bufnumber		db			?
DATAREA			ENDS
;***********************************************************
PROGNAM 		SEGMENT;define code segment
;-----------------------------------------------------------
MAIN			PROC		FAR
				ASSUME		CS:PROGNAM,DS:DATAREA
START:
	;set up stack for return
				PUSH		DS
				SUB			AX,AX
				PUSH		AX
	;set DS register to current data segment
				MOV			AX,DATAREA
				MOV			DS,AX
	;MAIN PART OF PROGRAM GOES HERE
				call		getline
				call		openf
				or			ax,ax
				jnz			here
				lea			dx,MESS_ERR2
				mov			ah,09h
				int			21h
				jmp			EXITT
here:
				call     	readf
				;输出MESSAGE1的内容
				LEA			DX,MESSAGE1
				MOV			AH,09H
				INT 		21H
				;执行DECIBIN函数,得到N的值（BX = N）
				CALL		DECIBIN
				;输出回车换行
				CALL		CRLF
				;先比较BX（N）是不是0
				CMP			BX,0
				JZ			EXITT;if BX = 0,jmp
				;输出MESSAGE2的内容
				LEA			DX,MESSAGE2
				MOV			AH,09H
				INT			21H
				;从键盘上输入一个字符，将其对应字符的ASCII码送入AL中，并在屏幕上显示该字符
				;MOV			AH,01H
				;INT			21H
				mov			al,[buffer1 + 2]
				MOV			AH,0
				;CX保存输入的X的ASCII码
				MOV			CX,AX
				CALL		CRLF
				;输出MESSAGE3的内容
				LEA			DX,MESSAGE3
				MOV			AH,09H
				INT			21H
				;从键盘上输入一个字符，将其对应字符的ASCII码送入AL中，并在屏幕上显示该字符
				mov			al,[buffer1 + 4]
				;MOV			AH,01H
				;INT			21H
				MOV			AH,0
				;SI保存输入的Y的ASCII码
				MOV			SI,AX
				CALL		CRLF
				;输出MESSAGE2的内容
				LEA			DX,MESSAGE4
				MOV			AH,09H
				INT			21H
				;从键盘上输入一个字符，将其对应字符的ASCII码送入AL中，并在屏幕上显示该字符
				mov			al,[buffer1 + 6]
				;MOV			AH,01H
				;INT			21H
				MOV			AH,0
				;DI保存输入的Y的ASCII码
				MOV			DI,AX
				CALL		CRLF
				;执行汉诺塔函数
				;mov			bx,handle
				;mov			ah,3eh
				;int			21h
				;
				call		openfout
				CALL		HANOI
				mov 		ah,3eh
   				mov 		bx,handle
    			int 		21h
    			mov 		ah,3eh
    			mov 		bx,handle1
    			int 		21h
	;
EXITT:
				RET
	;
MAIN			ENDP
;-----------------------------------------------------------
HANOI			PROC		NEAR
;Solves tower of HANOI puzzle
;Argment: (BX) = N,(CX) = X,(SI) = Y,(DI) = Z.
				CMP			BX,1
				JE			BASIS;if BX = 1,jmp basis
				CALL 		SAVE
				;把上面N-1个盘子从X移动到Y，通过Z过渡
				DEC			BX
				XCHG		SI,DI
				CALL		HANOI
				CALL		RESTOR
				CALL		PRINT;把最底下一个盘子从X移动到Z（输出这个过程）
				;把剩余的N-1个盘子从Y移动到Z，通过X过渡
				DEC			BX
				XCHG		CX,SI
				CALL		HANOI
				JMP			RETURN
BASIS:
				CALL        PRINT
RETURN:
				RET
HANOI			ENDP
;-----------------------------------------------------------
PRINT			PROC		NEAR
;PRINT XNZ		;显示输出，输出DL的内容
				MOV			DX,CX
				MOV			AH,02H
				INT     	21H
				mov			superbuf,DX
				call		writef
				CALL		BINIDEC
				MOV			DX,DI
				MOV			AH,02H
				INT			21H
				mov			superbuf,DX
				call		writef
				CALL 		CRLF
				call		writefcrlf
				RET
PRINT			ENDP
;-----------------------------------------------------------
SAVE			PROC		NEAR
;PUSH N,Y,X,N FORM STACK
				POP			BP
				PUSH		BX
				PUSH		CX
				PUSH		SI
				PUSH		DI
				PUSH		BP
				RET
SAVE			ENDP
;-----------------------------------------------------------
RESTOR			PROC		NEAR
;POP Z,Y,X,N FORM STACK
				POP			BP
				POP			DI
				POP			SI
				POP			CX
				POP			BX
				PUSH		BP
				RET
RESTOR			ENDP
;-----------------------------------------------------------
DECIBIN			PROC		NEAR
;procedure to convert decimal on keybd to binary.
;将keybd上的十进制转换为二进制的过程
;result is left in BX register.
;结果留在 BX 寄存器中
				MOV			BX,0
				mov			si,0
;get digit from keyboard,convert to binary
;从键盘获取数字，转换为二进制
NEWCHAR:
				;从键盘上输入一个字符，将其对应字符的ASCII码送入AL中，并在屏幕上显示该字符
				;MOV			AH,1
				;INT 		21H
				
				mov			al,[buffer1 + si]
				SUB			AL,30H;ASCII to number
				JL			EXIT1;if AL < 0,jmp
				CMP			AL,9D;compare AL with 9
				JG			EXIT1;if AL > 9,jmp
				CBW;将AL的符号位移至AH(扩展)
		;(digit is now in AX)
		;multipy number in BX by 10 decimal.
				XCHG		AX,BX;exchange the mem of AX and BX
				MOV			CX,10D;CX = 10
				MUL			CX;AX = AX * CX
				XCHG		AX,BX;exchange the mem of AX and BX
		;add digit in AX to number in BX
				ADD			BX,AX
				inc			si
				JMP			NEWCHAR
EXIT1:
				xor			si,si
				RET
DECIBIN			ENDP
;-----------------------------------------------------------
BINIDEC			PROC		NEAR
;procedure to convert binary number in BX to decimal
;将BX中的二进制数转换为十进制数的过程
;on console screen
;在控制台屏幕上
				;保护寄存器的内容
				PUSH		BX
				PUSH		CX
				PUSH		SI
				PUSH		DI
				MOV			FLAG,0;FLAG(DW) = 0
				MOV			CX,5;CX = 5
				LEA			SI,CONSTANT
DEC_DIV:
				MOV			AX,BX;AX = BX
				MOV			DX,0;DX = 0
				DIV			WORD PTR[SI];从CONSTANT处取出一个word的数据进行乘法运算，商放在AX里，余数放在DX里
				MOV			BX,DX;BX = DX
				MOV			DL,AL;DL = AL
	;
				CMP			FLAG,0
				JNZ			PRINT1;if FLAG != 0,jmp print1
				CMP			DL,0
				JE			SKIP
				MOV			FLAG,1
	;print the contents of DL on screen
PRINT1:
				ADD			DL,30H;DL = DL + 30H
				;输出DL里的内容
				MOV			AH,02H
				INT 		21H
				mov			bufnumber,dl
				call		writefnum
SKIP:			;SI指向一个数据的地址
				ADD      	SI,2
				LOOP		DEC_DIV
				;恢复寄存器的内容
				POP			DI
				POP			SI
				POP			CX
				POP			BX
				RET
BINIDEC			ENDP
;-----------------------------------------------------------
CRLF			PROC		NEAR
;print carriage return and linefeed
				MOV			DL,0AH
				MOV			AH,02H
				INT 		21H
	;
				MOV			DL,0DH
				MOV			AH,02H
				INT 		21H
	;
				RET
CRLF 			ENDP
;-----------------------------------------------------------
getline			proc		near
				push		ax
				push		bx
				push		cx
				push		dx
				lea			dx,MESS_GETNAME
				mov			ah,09h
				int 		21h
				;
				lea			dx,buf_size
				mov			ah,0ah
				int 		21h
				;
				call       CRLF
				;
				mov			bl,s_size
				mov			bh,0
				mov			[buf+bx],0
				;
				pop			dx
				pop			cx
				pop			bx
				pop			ax
				ret
getline			endp
openf			proc		near
				push		bx
				push		cx
				push		dx
				lea			dx,buf
				mov			al,0
				mov			ah,3dh
				int 		21h
				mov			handle,ax
				mov			ax,1
				jnc			ok
				mov			ax,0
ok:
				pop			dx
				pop			cx
				pop			bx
				ret
openf			endp
openfout		proc		near
				push		bx
				push		cx
				push		dx
				lea			dx,MESS_GETNAME1
				mov			al,0
				mov			cx,00
				mov			ah,3ch
				int 		21h
				mov			handle1,ax
				pop			dx
				pop			cx
				pop			bx
				ret
openfout			endp
readf			proc		near
				push		bx
				push		cx
				push		dx
				;
				mov			cx,100
				mov			bx,handle
				lea			dx,buffer1
				mov			ah,3fh
				int 		21h
				;
				pop			dx
				pop			cx
				pop			bx
				ret
readf			endp
writef			proc		near
				push		bx
				push		cx
				push		dx
				;
				mov			cx,1
				mov			bx,handle1
				lea			dx,superbuf
				mov			ah,40h
				int 		21h
				;
				pop			dx
				pop			cx
				pop			bx
				ret
writef			endp
writefcrlf		proc		near
				push		bx
				push		cx
				push		dx
				;
				mov			cx,2
				mov			bx,handle1
				lea			dx,bufcrlf
				mov			ah,40h
				int 		21h
				;
				pop			dx
				pop			cx
				pop			bx
				ret
writefcrlf		endp
writefnum		proc		near
				push		bx
				push		cx
				push		dx
				;
				mov			cx,1
				mov			bx,handle1
				lea			dx,bufnumber
				mov			ah,40h
				int 		21h
				;
				pop			dx
				pop			cx
				pop			bx
				ret
writefnum		endp
PROGNAM			ENDS

				END			START