;5-4 COMPARE THE STRING
DATA SEGMENT
    STRING1 DB 'Hello world'
    STRING2 DB 'Hello world'
    YES DB 'MATCH', 0DH, 0AH, '$'    ;注意换行
    NO DB 'NO MATCH', 0DH, 0AH, '$'
DATA ENDS

CODE SEGMENT
    ASSUME CS:CODE, DS:DATA, ES:DATA
START:    ;初始化数据段
    PUSH  DS    ;设置返回DOS 
    SUB  AX, AX 
    PUSH  AX 
    MOV  AX, DATA 
    MOV  DS, AX   ;给DS赋值 
    MOV  ES, AX   ;给ES赋值
BEGIN:
    LEA  SI, STRING1  ;设置串比较指令的初值 
    LEA  DI, STRING2 
    CLD    ;清除方向标志位
    MOV  CX, STRING2 - STRING1 
    REPE  CMPSB   ;串比较 
    JNE  NOMATCH    ;不相等就跳转 
    LEA  DX, YES   ;显示MATCH 
    JMP  DISPLAY 
NOMATCH: 
    LEA  DX, NO   ;显示NO MATCH 
DISPLAY: 
    MOV  AH, 9   ;显示一个字符串的DOS调用 
    INT  21H 
    RET 
CODE  ENDS     ;以上定义代码段 


