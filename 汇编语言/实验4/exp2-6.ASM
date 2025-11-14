;PROGRAM TITLE GOES HERE--Rank
;**********************************************************
datarea segment						;定义数据段
	grade		dw		50 dup(?)	;存放成绩
	rank			dw		50 dup(?)	;存放排名
	count		dw		?			 ;成绩个数
	mess1		db		'Grade?$'
	mess2		db		13,10,'	Input Error!',13,10,'$'
	mess3 		db		'Rank:$'
datarea ends
;***********************************************************
prognam	  segment					;定义程序段
;-----------------------------------------------------------
main	proc 	far					;mainp part of program
		assume	cs:prognam,ds:datarea
start:
;set up stack for return
		push	ds					;save old data segment
		sub		ax,ax				;put zero in AX
		push	ax					;save it on stack
;对于当前数据段建立DS寄存器
		mov		ax,datarea			;datarea segment addr
		mov		ds,ax				;into DS register
;MAIN PART OF PROGRAM GOES HERE
		call	input
		call 	rankp
		call	output
		ret
main	endp
;-------------------------------------------------------------------------
input	proc	near
		lea		dx,mess1
		mov		ah,09
		int		21h
;
		mov		si,0
		mov		count,0
enter:
		call	        decibin
		inc		count				;count++
		cmp		dl,','					;is it','?
		je		store
		cmp		dl,13				;is it 'return'?
		je		exit2
		jne		error
store:
		mov		grade[si],bx			;保存成绩
		add		si,2					;of students(跳到grade数组下一个位置
		jmp		enter
error:
		lea		dx,mess2
		mov		ah,09
		int		21h
exit2:
		mov		grade[si],bx
		call		crlf					;打印回车换行
		ret
input	endp
;--------------------------------------------------------------
rankp	proc		near
		mov		di,count
		mov		bx,0
loop1:
		mov		ax,grade[bx]			;成绩放入ax
		mov		word ptr rank[bx],0	;初始排名为0
		mov		cx,count				;总的成绩个数
		lea		si,grade
next:
		cmp		ax,[si]
		jg		no_count			;ax>[si]
		inc		word ptr rank[bx]
no_count:
		add		si,2
		loop		next					;循环count次
		add		bx,2
		dec		di					;还需要计算排名的人数
		jne		loop1
		ret							;return to DOS
rankp	endp
;---------------------------------------------------------------
output	proc		near
		lea		dx,mess3
		mov		ah,09
		int		21h
;
		mov		si,0
		mov		di,count				;还需要输出的成绩个数
next1:
		mov 	bx,rank[si]
		call 		binidec				;display the rank
		mov		dl,','					;of students
		mov		ah,02				;输出','
		int		21h
		add		si,2
		dec		di
		jnz		next1
		call		crlf					
		ret
output	endp
;----------------------------------------------------------------------
decibin		proc		near
;键盘输入的十进制转换成二进制
;结果留在BX寄存器中
			mov		bx,0				;清空bx寄存器
;从键盘获取十进制，转换成二进制
newchar:
			mov		ah,1				;键盘输入,AL=输入字符
			int		21h				;call DOS
			mov		dl,al
			sub		al,30h			;ASCII to binary
			jl		exit1			;jump if<0
			cmp		al,9d			;is it >9d?
			jg		exit1			;yes,not dec digit
			cbw						;byte in AL to word in AX
;现在数字在ax里面
;数字乘以10放入bx
			xchg	ax,bx			;交换ax,bx
			mov		cx,10d			;把十进制10放到cx
			mul		cx				;cx*ax->dx:ax
			xchg	ax,bx			;交换ax,bx
；add digit in AX to number in BX
			add		bx,ax			;add digit to number
			jmp		newchar			;get next digit
exit1:		ret						;return from decibin
decibin		endp					;end of decibin proc
;---------------------------------------------------------------------
binidec		proc		near
;把bx中的二进制转换为十进制
; 在控制台上显示
			push	bx
			push	cx
			push	si
			push	di
			mov		cx,100d			;divide by 100
			call	dec_div
			mov		cx,10d			;divide by 10
			call	dec_div
			mov		cx,1d			;divide by 1
			call	dec_div
			pop		di
			pop		si
			pop		cx
			pop		bx
			ret						;return from binidec
binidec		endp
;--------------------------------------------------------------------
dec_div		proc	        near
;子例程将bx中的nunber除以cx中的数字
; print quotient on screen
			mov		ax,bx			;number high half
			mov		dx,0				;zero out low half
			div		cx				;AX ← DX:AX / 源; DX ← DX:AX % 源
			mov		bx,dx			;remainder into bx
			mov		dl,al				;quotient into DL
;打印dl
			add		dl,30h			;convert to ASCII
			mov		ah,02h			;display funtion
			int		21h				;call DOS
			ret						;return from dec_div
dec_div		endp
;-----------------------------------------------------------------------
crlf			proc		near
;打印回车和换行
			mov		dl,0ah			;换行
			mov		ah,02h
			int		21h
;
			mov		dl,0dh			;回车
			mov		ah,02h
			int		21h
			
			ret
crlf		endp
;-----------------------------------------------------------------------
prognam		ends
;***********************************************************************
			end		start
			