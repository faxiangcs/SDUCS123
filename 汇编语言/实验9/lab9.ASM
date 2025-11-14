DATA            SEGMENT
COUNTER           DB            4 DUP(?);COUNT数组
MAX_SIZE          DB            101
TRUE_SIZE         DB            ?
BUFFER            DB            101 dup(?)
NUM_LITTLE        DB            0;小写字母的个数
NUM_BIG           DB            0;大写字母的个数
NUM_NUMBER        DB            0;数字的个数
NUM_OTHER         DB            0;其他的个数
HUICHE            DB            0DH,0AH,'$';回车换行
FLAG              DB            0;判断特殊字符是不是被处理过
DATA            ENDS
;
STACK SEGMENT
    DB 100 DUP(?)
STACK ENDS
;
CODE             SEGMENT
                ASSUME DS :DATA ,CS :CODE,SS:STACK
MAIN    PROC     FAR
START:
        PUSH       DS;设置返回DOS
        SUB        AX,AX
        PUSH       AX
        MOV        AX,DATA;传送数据段段地址
        MOV        DS,AX
        LEA        DX,MAX_SIZE
        MOV        AH,0AH;读取输入的字符串
        INT     21H
        MOV        CH,0
        MOV        CL,TRUE_SIZE;CL记录读入的字符串的个数
        XOR        SI,SI;SI=0，并清空其标志位，SI作为BUFFER数组索引
IF_NUMBERS:;判断是否是数字
		CMP        BUFFER[SI],'0'
		JB         IF_BIG
        CMP        BUFFER[SI],'9'
        JA         IF_BIG;如果不是数字先跳转到大写字母部分
        INC        NUM_NUMBER;否则NUMBBER++，SI++，CX--
        INC        SI
        DEC        CX
        CMP        CX,0
        JE         WRITE_BACK;如果CX为0跳转到写入数字、大小写字母个数部分
        JMP        IF_NUMBERS;否则跳回IF_NUMBERS，遍历BUFFER数组的下一个元素
IF_BIG:;判断字母是否是大写
        CMP        BUFFER[SI],'A'
        JB         OTHERS
        CMP        BUFFER[SI],'Z'
        JA         IF_LITTLE
        INC        NUM_BIG
        INC        SI
        DEC        CX
        CMP        CX,0
        JE         WRITE_BACK
        JMP        IF_NUMBERS
IF_LITTLE:;判断字母是否是小写
        CMP        BUFFER[SI],'a'
        JB        OTHERS
        CMP        BUFFER[SI],'z'
        JA        OTHERS
        INC        NUM_LITTLE
        INC        SI
        DEC        CX
        CMP        CX,0
        JE         WRITE_BACK
        JMP        IF_NUMBERS
OTHERS:
		INC        NUM_OTHER
        INC        SI
        DEC        CX
        CMP        CX,0
        JE         WRITE_BACK;如果CX为0跳转到写入数字、大小写字母个数部分
        JMP        IF_NUMBERS;否则跳回IF_NUMBERS，遍历BUFFER数组的下一个元素
WRITE_BACK:;把小大写字母、数字的个数写入count数组里
        XOR        SI,SI
        MOV        AL,NUM_LITTLE
        MOV        COUNTER[SI],AL;COUNTER[0] = LITTLE
        INC        SI
        MOV        AL,NUM_BIG
        MOV        COUNTER[SI],AL
        INC        SI
        MOV        AL,NUM_NUMBER
        MOV        COUNTER[SI],AL
		INC        SI
        MOV        AL,NUM_OTHER
        MOV        COUNTER[SI],AL
CACULATE:
        LEA        DX,HUICHE
        MOV        AH,09H;输出换行回车
        INT     21H
        CALL    OUTPUT_LITTLE;输出小写字母的个数
        LEA        DX,HUICHE
        MOV        AH,09H;输出换行回车
        INT     21H
        CALL    OUTPUT_BIG;输出大写字母的个数
        LEA        DX,HUICHE
        MOV        AH,09H
        INT     21H
        CALL    OUTPUT_NUMBBERS;输出数字的个数
		LEA        DX,HUICHE
        MOV        AH,09H
        INT     21H
		CALL    OUTPUT_OHTER;输出其他的个数
OTHER:
        RET
MAIN     ENDP
;
OUTPUT_LITTLE        PROC    ;输出小写字母的个数
        MOV        AX,0
        MOV        BX,0
        MOV        BL,10
        MOV        AL,NUM_LITTLE
        DIV        BL
        MOV        BH,AH;用BH保存余数
        CMP        AL,0
        JZ         YU_1;如果商为0则跳转
        ADD        AL,'0';加上'0'转换成相应的ASCII码
        MOV        DL,AL
        MOV        AH,02H;写字符 写商
        INT     21H
YU_1:
        ADD        BH,'0';加上'0'转换成相应的ASCII码
        MOV        DL,BH
        MOV        AH,02H;写字符 写余数
        INT     21H
        RET
OUTPUT_LITTLE        ENDP
;
OUTPUT_BIG        PROC    ;输出大写字母的个数
        MOV        AX,0
        MOV        BX,0
        MOV        BL,10
        MOV        AL,NUM_BIG
        DIV        BL
        MOV        BH,AH
        CMP        AL,0
        JZ         YU_2
        ADD        AL,'0'
        MOV        DL,AL
        MOV        AH,02H
        INT     21H
YU_2:
        ADD        BH,'0'
        MOV        DL,BH
        MOV        AH,02H
        INT     21H
        RET
OUTPUT_BIG        ENDP
;
OUTPUT_NUMBBERS        PROC    ;输出数字的个数
        MOV        AX,0
        MOV        BX,0
        MOV        BL,10
        MOV        AL,NUM_NUMBER
        DIV        BL
        MOV        BH,AH
        CMP        AL,0
        JZ         YU_3
        ADD        AL,'0'
        MOV        DL,AL
        MOV        AH,02H
        INT     21H
YU_3:
        ADD        BH,'0'
        MOV        DL,BH
        MOV        AH,02H
        INT     21H
        RET
OUTPUT_NUMBBERS        ENDP

OUTPUT_OHTER        PROC    ;输出数字的个数
        MOV        AX,0
        MOV        BX,0
        MOV        BL,10
        MOV        AL,NUM_OTHER
		;SUB        AL,NUM_BIG
		;SUB        AL,NUM_LITTLE
		;SUB        AL,NUM_NUMBER
        DIV        BL
        MOV        BH,AH
        CMP        AL,0
        JZ         YU_4
        ADD        AL,'0'
        MOV        DL,AL
        MOV        AH,02H
        INT     21H
YU_4:
        ADD        BH,'0'
        MOV        DL,BH
        MOV        AH,02H
        INT     21H
        RET
OUTPUT_OHTER        ENDP
	
CODE     ENDS
        END     MAIN
        