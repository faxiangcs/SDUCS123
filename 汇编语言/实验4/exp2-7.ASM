;PROGRAM TITLE GOES HERE--SCREMP
;Enter hours & rate,display wage
;*************************************************************
stacksg		segment		para stack 'stack'
			dw		32 dup(?)
stacksg		ends
;****************************************************************8
datasg		segment		para 'data'
	hrspar			label		byte;工作时长表
	maxhlen			db			6
	acthlen			db			?
	hrsfld			db			6 dup(?)
	
	ratepar			label		byte;工资率表
	maxrlen			db			6
	actrlen			db			?
	ratefld			db			6 dup(?)
	messg1			db			'Hours worked?','$'
	messg2			db			'Rate of pay?','$'
	messg3			db			'Wage='
	ascwage			db			14 dup(30h),13,10,'$'
	messg4			db			13,10,'Overflow!',13,10,'$'
	adjust			dw			?
	binval			dw			0
	binhrs			dw			0
  	binrate			dw			0
  	col				db			0
  	decind			db			0
  	mult10			dw			01
  	nodec			dw			0
  	row				db			0
  	shift				dw			?
  	tenwd			dw			10
  	tempdx			dw			?
  	tempax			dw			?
datasg		ends
;**************************************************************************
codesg		segment		para 'code'
;----------------------------------------------------------------------------------------
begin		proc		far
			assume cs:codesg,ds:datasg,ss:stacksg,es:datasg

;set up stack for returns
			push		ds		;save old data segment
			sub			ax,ax	;put zero in AX
			push		ax		;save it on stack
;set DS register to current data segment
			mov			ax,datasg;datarea segment addr
			mov			ds,ax	;into DS register
			mov			es,ax
;MAIN PART OF PROGRAM GOES HERE
			mov			ax,0600h
			call			q10scr;清屏							
			call			q20curs;光标置位							
a20loop:
			call			b10inpt							
			cmp			acthlen,0						
			je			a30								
			call			d10hour	;将工作时间转换为二进制						
			call		e10rate	;将工资率转换为二进制						
			call		f10mult							
			call		g10wage ;将工资转换为ASC
			call		k10disp
			jmp			a20loop
a30:
			mov			ax,0600h						
			call		q10scr
			ret									
begin		endp
;----------------------------------------------------------------------------
;输入工作时间和工资率
;
b10inpt		proc		near
			lea			dx,messg1						
			mov			ah,09h
			int			21h
			lea			dx,hrspar						
			mov			ah,0ah
			int			21h
			cmp			acthlen,0						
			jne			b20
			ret
b20:
			mov			col,25			;set column							
			call		q20curs							
			lea			dx,messg2		;prompt for rate						
			mov			ah,09h
			int			21h
			lea			dx,ratepar		;accept rate					
			mov			ah,0ah
			int			21h
			ret
b10inpt		endp
;-------------------------------------------------------------
;处理时间
;---------
d10hour		proc		near
			mov			nodec,0							
			mov			cl,acthlen						
			sub			ch,ch							
			lea			si,hrsfld-1		;set right pos'n				
			add			si,cx							
			call			m10asbi							
			mov			ax,binval						
			mov			binhrs,ax						
			ret
d10hour		endp
;-----------------------------------------------------------------
;处理工资率
;
e10rate		proc		near
			mov			cl,actrlen						
			sub			ch,ch							
			lea			si,ratefld-1
			add			si,cx							
			call		m10asbi
			mov			ax,binval
			mov			binrate,ax						
			ret
e10rate		endp
;-----------------------------------------------------------------------
;相乘
;
f10mult		proc		near
			mov			cx,07							
			lea			di,ascwage		;建立ASC工资表	
			mov			ax,3030h
			cld
			rep			stosw

			mov			shift,10
			mov			adjust,0
			mov			cx,nodec						
			cmp			cl,06
			ja			f40				;decimals,error							
			dec			cx								
			dec			cx
			jle			f30								
			mov			nodec,02						
			mov			ax,01							
f20:
			mul			tenwd		;calculate shift factor
			loop		f20								
			mov			shift,ax						
			shr			ax,1			;calculate round value					
			mov			adjust,ax					
f30:
			mov			ax,binhrs					
			mul			binrate		;calculate wage					
			add			ax,adjust		;round wage				
			adc			dx,0							
			mov			tempdx,dx	;save dx:ax					
			mov			tempax,ax
;
			cmp			adjust,0
			jz			f50			
;					
			mov			ax,dx		;shift use double precision					
			mov			dx,0			;DIV
			div			shift			; quptient into DX:AX
			mov			tempdx,ax
			mov			ax,tempax
			div			shift
			mov			dx,tempdx
			mov			tempax,ax						
			jmp			f50
f40:
			mov			ax,0							
			mov			dx,0
f50:
			ret
f10mult		endp
;-----------------------------------------------------------------------------
;转成ASCII
;
g10wage		proc		near
			lea			si,ascwage+11					
			mov			byte ptr[si],'.'				
			add			si,nodec						
g30:
			cmp			byte ptr[si],'.'	
			jne			g35
			dec			si							
g35:
			cmp			dx,0							
			jnz			g40							
			cmp			ax,0010
			jb			g50								
g40:
			mov			ax,dx					
			mov			dx,0
			div			tenwd
			mov			tempdx,ax
			mov			ax,tempax
			div			tenwd
			mov			tempax,ax
			or			dl,30h						
			mov			[si],dl		;存储ASC字符					
			dec			si								
			mov			dx,tempdx
			jmp			g30
g50:
			or			al,30h		;存储最后一个ASC		
			mov			[si],al
			ret
g10wage		endp
;-------------------------------------------------------------------
;显示
;
k10disp		proc		near
			mov			col,50							
			call		q20curs							
			mov			cx,10
			lea			si,ascwage
k20:
			cmp			byte ptr[si],30h			
			jne			k30							
			mov			byte ptr[si],20h		
			inc			si								
			loop		k20								
k30:
			lea			dx,messg3						
			mov			ah,09
			int			21h
			cmp			row,20							
			jae			k80								
			inc			row								
			jmp			k90								
k80:
			mov			ax,0601h						
			call		q10scr							
			mov			col,0							
			call		q20curs
k90:		ret
k10disp		endp
;-------------------------------------------------------------------
;ASC转为二进制
m10asbi		proc		near
			mov			mult10,01
			mov			binval,0						
			mov			decind,0
			sub			bx,bx
m20:
			mov			al,[si]							
			cmp			al,'.'							
			jne			m40
			mov			decind,01						
			jmp			m90
m40:
			and			ax,000fh					
			mul			mult10
			jc			overflow						
			add			binval,ax						
			jc			overflow						
			mov			ax,mult10						
			mul			tenwd							
			mov			mult10,ax						
			cmp			decind,0						
			jnz			m90								
			inc			bx								
m90:
			dec			si								
			loop		m20								
			cmp			decind,0
			jz			m100							
			add			nodec,bx						
			jmp			m100							
overflow:
			mov			binval,0						
m100:		ret
m10asbi		endp
;----------------------------------------------------------------------
q10scr		proc		near
			mov			bh,07							
			sub			cx,cx							
			mov			dx,184fh						
			int			10h								
			ret
q10scr		endp
;--------------------------------------------------------------------------------
q20curs		proc		near
			mov			ah,2					
			sub			bh,bh							
			mov			dh,row							
			mov			dl,col
			int			10h
			ret
q20curs		endp
;--------------------------------------------------------------------------
codesg		ends
;****************************************************************************
			end		begin
