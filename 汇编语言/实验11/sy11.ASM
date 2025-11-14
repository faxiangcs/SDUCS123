data 		segment
cnt			db		0;存放最开始输入的记录的条数
num			db		0;记录teltab里当前已有的表项的数目（每次往teltab里加入表项的时候会加一）
temparray	db		12 dup(20h),8 dup(20h),8 dup(20h),13,10,'$';记录信息的临时表项
teltab 	db 		35 dup(12 dup(20h),8 dup(20h),8 dup(20h),13,10,'$');信息表项
;
messone		db		'Input name:','$'
messtwo		db		'Input a telephone number:','$'
messthree		db		'Do you want a telephone number?(Y/N)','$'
messfour		db		13,10,'$'
messfive		db		'name?','$'
messsix       db		'name',16 dup(20h),'tel.',13,10,'$'
;姓名的字符缓存区
namelab		label	BYTE
 maxlen	    db		13
 len		db		0
 names		db		13 dup(0)
;电话号的缓存区
tellab		label	BYTE
 maxlen1	db		9
 len1		db		0
 tels		db		9 dup(0)
;
name0		db		13 dup(0);用于清空namelab缓存区里的names数组
tel0		db		9 dup(0);用于清空tellab缓存区里的tels数组
data		ends
;----------------------------------------------
code 		segment
			assume ds:data,cs:code,es:data  
main		proc	far
start:
			;起始部分
			push	ds
			sub		ax,ax
			push	ax
			mov		ax,data
			mov		ds,ax
			mov 	es,ax
			;第一行输入n(≤20)表示要录入的数据的数量
			;decibin函数使用读入单个字符的方法（01H）来计算输入的数字
			call	decibin
			;把BL里的内容放入cnt变量里
			mov		cnt,bl
			;call	crlf;回车换行
			;如果cnt为0，即没有有效输入就直接退出整个程序
			xor		cx,cx;清空CX寄存器里的内容
			mov		cl,cnt;把cnt变量里的内容放入CL里
			cmp		cl,0;比较CL是否为0
			je		exit;if CL == 0,jmp->ret
here:
			call   	name_input;输出提示messone
			;从键盘上接受输入的字符放入namelab缓存区
			;在把names的内容放入temparray里
			;清空names内容（清空缓存区字符串内容）
			call	putnamein
			;;;;;;
			call   	phone_input;输出提示messone
			;从键盘上接受输入的字符放入tellab缓存区
			;在把tels的内容放入temparray里
			;清空tels内容（清空缓存区字符串内容）
			call	putphonein
			;
			call	name_sort
			loop	here
search:
			call	ask_output;提示输出messthree
			mov 	ah,01h;键盘输入并回显
			int 	21h
			cmp 	al,'N'
			call	crlf
			je		no
    		;
    		lea 	dx,messfive;提示输入名字进行查询
    		mov		ah,09h
    		int 	21h
    		;
    		lea		dx,maxlen
			mov		ah,0ah
			int 	21h
			;
			call	crlf;回车换行
			;
			lea 	dx,messsix
    		mov		ah,09h
    		int 	21h
			;
			call	searchname
			;
			call	clearname
			;
			jmp		search
no:
			call	printline
exit:
			ret
main		endp
;
;回车换行
crlf		proc	near
			;
			lea		dx,messfour
			mov		ah,09h
			int 	21h
			;
			ret
crlf		endp
;
;输出提示messone(cout << "Input name:";)
name_input	proc	near
			;
			lea		dx,messone
			mov		ah,09h
			int 	21h
			;
			ret
name_input	endp
;
;输出提示messtwo(cout << "Input a telephone number:";)
phone_input	proc	near
			;
			lea		dx,messtwo
			mov		ah,09h
			int 	21h
			;
			ret
phone_input	endp
;
;输出提示messthree(cout << "Do you want a telephone number?(Y/N)")
ask_output	proc	near
			;
			lea		dx,messthree
			mov		ah,09h
			int 	21h
			;
			ret
ask_output	endp
;
;
clearname	proc	near
			push	cx
			;
			mov		cl,13
			lea		si,name0
			lea		di,names
			cld
			rep		movsb
			;
			pop		cx
			ret
clearname	endp
;
;接受从键盘上输入的字符,并把名字的字符放到temparray里
putnamein	proc	near
			;保存cx的内容入栈
			push	cx
			;将键盘上的输入存放在缓存区里
			lea		dx,namelab
			mov		ah,0ah
			int 	21h
			;
			xor		cx,cx;clear CX
			mov		cl,len;cx的内容是输入name字符串的长度
			;把names里的内容放入temparray的[0]-[len-1]里
			lea 	si,names
    		lea 	di,temparray
			cld
			rep		movsb
			;把name0数组里的内容放入names数组里（清空names的内容）
			mov		cl,13
			lea		si,name0
			lea		di,names
			cld
			rep		movsb
			;输出回车换行
			call	crlf
			;恢复cx里的内容
			pop		cx
			ret
putnamein	endp
;
;
putphonein	proc	near
			;保存cx的内容入栈
			push	cx
			;将键盘上的输入存放在缓存区里
			lea		dx,tellab
			mov		ah,0ah
			int 	21h
			;
			xor		cx,cx;clear CX
			;把tels里的内容放入temparray的[20]-[20+len1-1]里
			mov		cl,len1
			lea 	si,tels
    		lea 	di,temparray
			add		di,20
			cld
			rep		movsb
			;把tel0数组里的内容放入tels数组里（清空tels的内容）
			mov		cl,9
			lea		si,tel0
			lea		di,tels
			cld
			rep		movsb
			;输出回车换行
			call	crlf
			;恢复cx里的内容
			pop		cx
			ret
putphonein	endp
;
name_sort   proc 	near
			push	cx
			xor		cx,cx
			cmp		num,0
			jnz		sort
			;此时num为0,即数组teltab里没有元素
			;此时把temparray的内容放在数组teltab的第一个位置上
			mov		cl,31
			lea		si,temparray
			lea		di,teltab
			cld
    		repz 	movsb
    		jmp		exitthree
sort:
			;此时num不为0,即数组teltab里有元素
			;需要找到对应的位置然后插入
			xor 	cx,cx
			mov		cl,num
			lea 	si,temparray
    		lea 	di,teltab
loopsort:
    		push 	di
    		push 	cx
    		mov 	cx,12
    		cld
    		repz 	cmpsb
    		ja 		move;如果si>di,则使di指向下一个表项，继续循环
   			pop 	cx
    		pop 	di
    		call 	insert
    		jmp 	exitthree
move:
    		pop 	cx
    		pop 	di
    		add 	di,31
    		lea 	si,temparray
    		loop 	loopsort
    		mov 	cx,31;正常退出循环，说明需要插入在最后
    		cld;;
    		rep 	movsb
exitthree:
    		inc 	num;表项个数加1
    		call	cleartmp
    		pop		cx
    		ret
name_sort	endp
;
insert 		proc 	near
			xor		ah,ah
    		mov 	al,num;num-cx+1是位置，cx是需要移动的表项个数
loopinsert:
			;需要移动cx次
    		push 	ax
    		mov 	bx,31
    		mul 	bx;字节总数31*num
    		lea 	di,teltab
    		add 	di,ax;di目前指向num*31
    		mov 	si,di
    		sub 	si,31;si目前指向(num-1)*31
    		push 	cx
    		mov 	cx,31
    		cld;;
    		rep 	movsb
    		pop 	cx
   			pop 	ax
    		dec 	ax
    		loop 	loopinsert
    		;
    		lea 	si,temparray;插入待插入位置
    		lea 	di,teltab
    		mov 	bx,31
    		mul 	bx
    		add 	di,ax
    		mov 	cx,31
    		cld;;
    		rep 	movsb
    		ret
insert 		endp
;
;清空temparray数组里面的内容
cleartmp	proc	near
			;保存cx的内容入栈
			push	cx
			xor		di,di
			xor		cx,cx
			mov		cl,28;设置循环次数为28
xd:
			;将temparray[0]-[27]的内容全部清空
			mov		al,20h
			mov		temparray[di],al
			inc		di
			loop	xd
			;恢复cx里的内容
			pop		cx
			ret
cleartmp	endp
;
;依次输出表单每一个表项的信息
printline	proc	near
			;保存cx的内容入栈
			push	cx
			;
			xor		si,si;清空si寄存器里的内容
			mov		cl,cnt;cl = cnt（设置循环次数）
print:
			;输出teltab一个表项的内容
			lea		dx,teltab[si]
			mov		ah,09h
			int 	21h
			add		si,31;计算下一个表项开始的位置
			loop	print
			;
			pop		cx
			;恢复cx里的内容
			ret
printline	endp
;
;
searchname proc 	near
			push	cx
			;
    		xor		cx,cx
	   		mov 	cl,cnt;搜寻名字循环次数
    		lea 	si,names
    		lea 	di,teltab
loopfind:
    		push 	di
    		push 	cx
    		xor		cx,cx
    		mov 	cl,len
    		repz 	cmpsb;为0时重复串操作
    		je 		found;找到，则cnt-cx为位置
    		pop 	cx
    		pop 	di
    		add 	di,31;没找到就di+31
    		lea 	si,names
    		loop 	loopfind
found:
			xor		ax,ax
			mov		al,len
			sub		di,ax
			mov		dx,di
			mov		ah,09h
			int 	21h
			;
		    pop 	cx
    		pop 	di
exitfour:
			pop		cx
    		ret
searchname endp
;
decibin		proc	near
;procedure to convert decimal on keybd to binary.
;将keybd上的十进制转换为二进制的过程
;result is left in BX register.
;结果留在 BX 寄存器中
			mov		bx,0
;get digit from keyboard,convert to binary
;从键盘获取数字，转换为二进制
newchar:
			;从键盘上输入一个字符，将其对应字符的ASCII码送入AL中，并在屏幕上显示该字符
			mov		ah,1
			int 	21h
			;
			sub		al,30h;ASCII to number
			jl		exitone;if AL < 0,jmp
			cmp		al,9d;compare AL with 9
			jg		exitone;if AL > 9,jmp
			cbw;将AL的符号位移至AH(扩展)
		;(digit is now in AX)
		;multipy number in BX by 10 decimal.
			xchg	ax,bx;exchange the mem of AX and BX
			mov		cx,10d;CX = 10
			mul		cx;AX = AX * CX
			xchg	ax,bx;exchange the mem of AX and BX
		;add digit in AX to number in BX
			add		bx,ax
			jmp		newchar
exitone:
			ret
decibin		endp
code		ends
			end 	main