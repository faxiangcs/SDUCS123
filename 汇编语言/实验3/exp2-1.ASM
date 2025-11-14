;PROGRAM TLTLE GOES HERE--tabsrch
;Table search 
;*********************************************
datasg	segment	para	'data'
mess1	db		'stock nember?',13,10,'$'
;
stoknin	label	byte
	max		db		3
	act		db		?
	stokn	db		3 dup(?)
;
stoktab	db		'05',' Excavators '
		db		'08',' Lifters    '
		db		'09',' Presses    '
		db		'12',' Valves     ' 
		db		'23',' Processors '
		db		'27',' Pumps      '
;
descrn	db		14 dup(20h),13,10,'$'

mess	db		'Not in table!','$'
datasg 	ends
;***************************************************
codesg 	segment	para'code'
		assume	cs:codesg,ds:datasg,es:datasg
;---------------------------------------------------
main	proc  	far
		push	ds		;save old data segment
		sub		ax,ax	;put zero in AX
		push	ax		;save it in stack
		
		mov		ax,datasg    ;data segment addr
		mov		ds,ax    ; into DS register
		mov		es,ax    ; into ES register	
;MAIN PART OF PROGRAM GOES HERE
start:
		lea		dx,mess1        ;Prompt for stock number
		mov		ah,09		;输出stock nem
		int		21h
		lea		dx,stoknin
		mov		ah,0ah		;保存输入的两位字符到stokn
		int		21h
		cmp		act,0		;没有输入任何字符
		je		exit
		mov		al,stokn	;Get stock#
		mov		ah,stokn+1	;低位字符放到ah
		mov		cx,06		;No. of rntries
		lea		si,stoktab	;Init'ze table address
a20:
		cmp		ax,WORD ptr[si]	;和05比较
		je		a30				;Equal - exit
		add		si,14			;Not equal - incresement
		loop	a20
		lea		dx,mess			;不在表中，输出Not in table！
		mov		ah,09
		int		21h
		jmp		exit
a30:
		mov		cx,07			;Length of descr'n
		lea		di,descrn			;Addr of descr'n
		rep		movsw
;
		lea		dx,descrn
		mov		ah,09
		int		21h
		jmp		start
		
exit:
		ret				;return to DOS
main 	endp
;------------------------------------------------------------
codesg	ends			;end of code segment
;************************************************************
		end		main	;end assembly