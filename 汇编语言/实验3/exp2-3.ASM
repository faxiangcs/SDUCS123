;PROGRAM TITLE GOES HERE--result
;*********************************************************
datarea		segment			;define data segment
	grade	dw		56,69,84,82,73,88,99,63,100,80
	s5		dw		0
	s6		dw		0
	s7		dw		0
	s8		dw		0
	s9		dw		0
	s10		dw		0
datarea		ends
;**********************************************************
prognam		segment				;define code segment
;-------------------------------------------------------------
main		proc		far		;main part of program
			assume cs:prognam,ds:datarea
start:
;set up stack for return
			push		ds		;save old data segment
			sub			ax,ax	;put 0 in AX
			push		ax		;save it on stack
;set DS register to current data segment
			mov			ax,datarea	
			mov			ds,ax	;datarea segment addr
			mov			s5,0		;初始化计数器 into DS register
;MAIN PART OF PROGRAM GOES HERE
			mov			s6,0		;initialize counter
			mov			s7,0
			mov			s8,0
			mov			s9,0
			mov			s10,0
			mov			cx,10		;initialize loop count value
			mov			bx,offset grade	;initialize first addr
compare:
			mov			ax,[bx]	;get a result
			cmp			ax,60	;<60?
			jl			five
			cmp			ax,70	;<70?
			jl			six
			cmp			ax,80	;<80?
			jl			seven
			cmp			ax,90	;<90?
			jl			eight
			cmp			ax,100	;=100?
			jne			nine
			inc			s10
			jmp			short change_addr
nine:	
			inc			s9
			jmp			short change_addr
eight:
			inc			s8
			jmp			short change_addr
seven:
			inc			s7
			jmp			short change_addr
six:
			inc			s6
			jmp			short change_addr
five:
			inc			s5
change_addr:
			add 		bx,2
			loop		compare
			ret					;return to DOS
main		endp				;end of main part of program
;--------------------------------------------------------
prognam		ends
;********************************************************
			end		start			;end assembly