;PROGRAM TITLE GOES HERE--DIRECT
;direct(com) Direct table access
;*************************************


datasg segment para 'data'
three db 3	;每三个字节是一个月
mess  db 'month?',13,10,'$'
monin label byte	;为数据段中定义的下一个变量提供不同的名称和大小属性，共同享一个内存位置
;label伪指令自身不分配内存


max db 3	;最多输入字符数
act db ?	;读入缓冲区时，此位置自动存储输入数字的位数
mon db 3 dup(?)		;存输入的内容，最多两个数字一个回车
;


alfmon db '???',13,10,'$'	;用作缓冲区
;建一个月份表
montab db 'JAN','FEB','MAR','APR','MAY','JUN'
       db 'JUL','AUG','SEP','OCT','NOV','DEC'
;
datasg ends
;*************************************
codesg segment para 'code'
       assume cs:codesg,ds:datasg,es:datasg		;关联段与段寄存器

main proc far
  push ds
  sub ax,ax
  push ax
;
  mov ax,datasg
  mov ds,ax
  mov es,ax
;                input month;
;
start:
	lea dx,mess
	mov ah,09
	int 21h		;输出month？
	lea dx,monin
	mov ah,0ah		;从标准输入设备上读入一个字节字符串，遇到回车结束输入
	int 21h
	mov dl,13		;回车->回到当前行的行首
	mov ah,02		;显示输出
	int 21h
	mov dl,10
	mov ah,02
	int 21h
	cmp act,0		;判断输入的数字位数是否为0
	je exit			;结果为0则跳转
;        Convert ASCII to binary
;          ------
	mov ah,30h		;建立月份
	cmp act,2		;输入数字的位数是否为2
	je two			;是则跳转
	mov al,mon		;如果输入一位数字，将ASCII存入al
	jmp conv
two:
	mov al,mon+1	;如果输入两位数字，将低位的ASCII存入al
	mov ah,mon		;将高位的ASCII存入al
conv:
	xor ax,3030h	;30是0的ASCII码，与0相减得数字
	cmp ah,0		;Month 01-09?    是否输入了01,02,03这样的形式
	jz loc			
	sub ah,ah		;ah置0
	add al,10		
;
;
loc: lea si,montab		;月份表的地址
	dec al					;自减操作
	mul three				;al*3=ax,获得输入月份的月份缩写在月份表中的偏移地址
	add si,ax				;
	mov cx,03
	cld						;将标志寄存器Flag的方向标志位DF清零。
	lea di,alfmon
	rep movsb
;
;
	lea dx,alfmon
	mov ah,09
	int 21h
	jmp start
;
exit: ret
main endp
;
codesg ends
;
end main

