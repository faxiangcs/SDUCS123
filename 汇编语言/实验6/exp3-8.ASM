TITLE WSPP --- Program of word process function
;	for insert,left and right
;-----------------------------
dseg	segment
kbd_buf	db		96 dup(' ')	; define data segment
cntl	db		16 dup(' ')	; number of rows
bufpt	dw		0			; buffer head pointer
buftl	dw		0			; buffer tail pointer
colpt	db		0			; cursor column position
rowpt	db		0
rowmx	dw		0			; maximum row number
dseg	ends
curs	macro	row,col  	; cursor position macro definition
		mov		dh,row
		mov		dl,col
		mov		bh,0
		mov		ah,2
		int		10h
		endm
;---------------------------------------------
cseg	segment
main	proc	far
		assume	cs:cseg,ds:dseg,es:dseg
start:
		push	ds		; save to return to DOS
		sub		ax,ax
		push	ax
		mov		ax,dseg
		mov		ds,ax
		mov		es,ax
		; initialize pointers
		mov		buftl,0
		mov		colpt,0
		mov		rowpt,0
		mov		bufpt,0
		mov		rowmx,0
		mov		cx,length cntl ; return number of elements
		mov		al,0
		lea		di,cntl
		cld
		rep		stosb		; store AL value into DI, loop count determined by CX
		
		mov		ah,6		; clear screen
		mov		al,0
		mov		cx,0
		mov		dh,24
		mov		dl,79
		mov		bh,07
		int		10h
		curs	0,0	; place cursor at (0,0)
read_k:
		mov		ah,0	; read character from kbd
		int		16h		; call ROM routine
		cmp		al,1bh
		jnz		arrow
		ret
arrow:
		cmp		ah,4bh		; move left?
		jz		left
		cmp		ah,4dh
		jz		right
;-----------------------------------------
inst:	jmp		ins_k
left:	jmp		left_k
right:	jmp		right_k
;-------------------------------------------
ins_k:
		mov		bx,bufpt	; insert a character
		mov		cx,buftl
		cmp		bx,cx
		je		km
		lea		di,kbd_buf	; shift all characters in buffer one byte to the right
		add		di,cx
		mov		si,di
		dec		si
		sub		cx,bx
		std
		rep		movsb		; used for string transfer, from DS[SI] to ES[DI]
km:
		mov		kbd_buf[bx],al	; put character into buffer
		inc		bufpt			; increment head pointer
		inc		buftl			; increment tail pointer
		cmp		al,0dh		; carriage return?
		jnz		kn
		lea		si,cntl		; shift count values for each row
		add		si,rowmx
		inc		si
		mov		di,si
		inc		di
		mov		cx,rowmx
		sub		cl,rowpt
		std
		rep		movsb
		
		mov		bl,rowpt	; modify current and next row count values
		xor		bh,bh		; current row
		mov		cl,colpt	; next row
		mov		ch,cntl[bx]
		sub		ch,colpt
		mov		cntl[bx],cl
		mov		cntl[bx+1],ch
		
		mov		ax,rowmx	; clear display row
		mov		bh,07
		mov		ch,rowpt
		mov		dh,24
		mov		cl,0
		mov		dl,79
		mov		ah,6
		int		10h
		
		inc		rowpt		; point to next row
		inc		rowmx
		mov		colpt,0
		jmp		short kp
; normal insertion
kn:
		mov		bl,rowpt
		xor		bh,bh
		inc		cntl[bx]	; increment current row count
		inc		colpt		; point to next column
kp:
		call	dispbf		; output the content of the buffer
		curs	rowpt,colpt	; position the cursor
		jmp		read_k
left_k:
		cmp		colpt,0		; is it column 0?
		jnz		k2
		cmp		rowpt,0
		jz		lret
		dec		rowpt
		mov		al,rowpt
		lea		bx,cntl
		xlat	cntl
		mov		colpt,al	; point to the end of this row
		jmp		k3
; decrement column count
k2:		dec		colpt
k3:
		dec		bufpt
		curs	rowpt,colpt
lret:	jmp		read_k
right_k:
		mov		bx,bufpt
		cmp		bx,buftl
		je		rret
		inc		colpt
		cmp		kbd_buf[bx],0dh ; carriage return?
		jnz		k4
		inc		rowpt
		mov		colpt,0
k4:
		inc		bufpt
		curs	rowpt,colpt
rret:	jmp		read_k
;--------------------------------------------
; display buffer content
dispbf	proc	near
		mov		bx,0
		mov		cx,96
		curs	0,0
disp:
		mov		al,kbd_buf[bx]
		push	bx
		mov		bx,0700
		mov		ah,0eh
		int		10h
		pop		bx
		cmp		al,0dh
		jnz		kk
		mov		al,0ah
		mov		ah,0eh
		int		10h
kk:
		inc		bx
		loop	disp
		ret
dispbf	endp
;--------------------------------------
main	endp
;---------------------------------------
cseg	ends
		end		start