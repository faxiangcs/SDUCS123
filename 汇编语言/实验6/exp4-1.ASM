data 	segment 
	pgsize 		dw 	?
	buf_size 	db  80
	s_buf 		db	?
	buf 		db	200 dup(?)						; input buffer size
  	cur 		dw 	?
	handle 		dw	?								; file handle
	mess_getname 	db 		0dh, 0ah,"           please input filename: $"
	mess_err1 		db		0ah, 0dh,"           illegal filename! $"
	mess_err2 		db      0ah, 0dh,"			 file not found! $"
	mess_err3 		db 		0ah, 0dh,"			 file read error! $"
	mess_psize		db 	    0ah, 0dh,"			 page size: $ "
	crlf			db      0ah, 0dh,"$"
	mess_star 		db 		0ah, 0dh,"*****************************************"
					db		0ah, 0dh,"$"
data	ends
code 	segment
		assume ds:data ,cs:code
main	proc 	far
start:
		push	ds
		sub 	ax, ax
		push	ax
		mov		ax, data
		mov		ds, ax
		mov		pgsize, 12					; initially display 12 lines per page from the file
		mov		cur, 200					; set the number of characters to read from the file at a time, same as buffer size
		call 	getline						; get the filename, prompt for input
		call 	openf						; open the file, ax==0 means the file does not exist
		or		ax, ax						
		jnz		display						; ax != 0, display the default 12 lines first
		mov 	dx, offset mess_err2
		mov		ah, 09h
		int		21h							; ax == 0, file not found!
		jmp		file_end
display:
		mov		cx, pgsize					; display the default 12 lines first
show_page:
		call	read_block					; read a line from the buffer
		or		ax, ax						
		jnz		next2						; ax == 0 means the file cannot be read
		;
		mov		dx, offset mess_err3		; file read failed
		mov		ah, 09h
		int		21h
		jmp		file_end
next2:	;
		call	show_block					; display the line, bx == 0 means end of file, exit directly
		or		bx, bx						; if 0, then it's the end
		jz		file_end
		or		cx, cx
		jnz		show_page					; default loop 12 times
		mov		dx, offset mess_star		; default 12 lines have been output, print a line of asterisks to separate pages!
		mov		ah, 09h
		int		21h
wait_space:									; wait for space key to output the next page!
		mov		ah, 1
		int		21h
		cmp		al, " "
		jnz		psize						; is the input 'p'?
		jmp		display
psize:
		cmp		al, "p"						; if not 'p', keep checking if it's space!
		jnz		wait_space
		call	change_psize				; change the number of lines per page
here:
		mov		ah, 1
		int		21h
		cmp		al, " "
		jnz		here						; wait for space to continue output after adjustment
		jmp		display
file_end:
		ret
main	endp
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
change_psize	proc	near				; change the number of lines per page
		push	ax
		push	bx
		push	cx
		push	dx
		mov		dx, offset mess_psize		; print prompt message
		mov		ah, 09h
		int		21h
		mov		ah, 01
		int		21h							; input the new number of lines per page
		cmp		al, 0dh						; if input is line feed, it's invalid
		jz		illeg
		sub		al, "0"						
		mov		cl, al
getp:
		mov		ah, 1						; keyboard input and echo, al = input character
		int		21h
		cmp		al, 0dh
		jz		pgot
		sub		al, "0"
		mov		dl, al
		mov		al, cl
		mov		cl, dl						; swap al, cl
		mov		bl, 10
		mul		bl
		add		cl, al
		jmp		getp
pgot:
		mov		dl, 0ah
		mov		ah, 2
		int		21h
		cmp		cx, 0
		jle		illeg
		cmp		cx, 24					; is it beyond the limit 0 -- 24
		jg		illeg
		mov		pgsize, cx
illeg:
		mov		dl, 0ah
		mov		ah, 2
		int		21h						; display output 0ah, carriage return
		pop		dx
		pop		cx
		pop		bx
		pop		ax
		ret
change_psize	endp
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
openf	proc	near						; check if the file is opened
		push	bx
		push	cx
		push	dx
		mov		dx, offset buf
		mov		al, 0
		mov		ah, 3dh					; 3dh opens the file, ds:dx=ASCII string address, al = 0 read, success ax=file handle, failure error code
		int		21h
		mov		handle, ax				
		mov		ax, 1
		jnc		ok
		mov		ax, 0
ok:
		pop		dx
		pop		cx
		pop		bx
		ret
openf	endp
getline	proc	near
		push	ax
		push	bx
		push	cx
		push	dx
		mov		dx, offset mess_getname
		mov		ah, 09h
		int		21h										; input filename prompt
		mov		dx, offset buf_size							;
		mov		ah, 0ah									; ds:dx buffer address, (ds:dx) buffer maximum character count,
		int		21h										; (ds:dx+1)=actual input character count!
		;
		mov		dx, offset crlf								; carriage return, line feed
		mov		ah, 09h
		int		21h
		;
		mov		bl, s_buf								; file name length
		mov		bh, 0
		mov		[buf+bx], 0						       ; append a 0 at the end of the file name
		pop		dx
				pop		cx
		pop		bx
		pop		ax
		ret
getline 	endp
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
read_block	proc	near								; read a line from the buffer
		push	bx
		push	cx
		push	dx
		cmp		cur, 200								; has the buffer been output?
		jnz		back
		;
		mov		cx, 200
		mov		bx, handle								; file handle to bx
		mov		dx, offset buf
		mov		ah, 3fh									; ds:dx=data buffer address, bx=file handle, cx=number of bytes to write
		int		21h										; write successful, ax=number of bytes written, otherwise error code
		mov		cur, 0									; reset pointer
		mov		ax, 1
		jnc		back
		mov		cur, 200
		mov		ax, 0
back:
		pop		dx
		pop		cx
		pop		bx
		ret
read_block	endp

show_block	proc	near							; display the line
		push	ax
		push	dx
		mov		bx, cur
loop1:
		cmp		bx, 200								; has the buffer been displayed?
		jl 		lp
		jmp		exit								; buffer is empty, exit
lp:
		mov		dl, buf[bx]							; display the current character
		cmp     dl, '$'
		jz		exit_eof
		inc		bx									; next
		inc		cur
		mov		ah, 02
		int		21h
		cmp		dl, 0ah								; is it a carriage return and line feed? If so, end of this line!
		jz		exit_in								; decrease line count
		jmp		loop1
exit_eof:
		mov		bx, 0
exit_in:
		dec		cx
exit:
		pop		dx
		pop		ax
		ret
show_block	endp
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
code	ends
end 	start
