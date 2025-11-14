;5.9 transfer xxH to binary
DATA SEGMENT
    PROMPT db '请输入一个四位的十六进制数(0-F)$' ; 输入提示信息
    ERRORMSG db '输入错误，请重新输入！$' ; 错误信息
DATA ENDS

CODE SEGMENT
    ASSUME CS:CODE, DS:DATA
START:    ;初始化
    MOV  AX, DATA 
    MOV  DS, AX   ;给DS赋值 
    MOV  ES, AX   ;给ES赋值
BEGIN:  
    MOV BX, 0   ;用于存放四位的16进制数 
    MOV CH, 4 
    MOV CL, 4 
INPUT:  
    SHL  BX, CL   ;将前面输入的数左移4位 
    MOV AH, 1   ;从键盘取数 
    INT  21H 
    CMP AL, 30H   ;<0吗？ 
    JB  INPUT   ;不是‘0～F’的数重新输入 
    CMP AL, 39H   ;是‘0～9’吗？ 
    JA  AF    ;不是，转‘A～F’的处理
    AND AL, 0FH   ;转换为：0000B～1001B 
    JMP  BINARY
AF:  
    AND AL, 1101 1111B ;转换为大写字母,大小写只有第六位不一样 
    CMP AL, 41H   ;<A吗？ 
    JB  INPUT   ;不是‘A～F’的数重新输入 
    CMP AL, 46H   ;>F吗？ 
    JA  INPUT   ;不是‘A～F’的数重新输入 
    AND AL, 0FH   ;以下两步将大写字母转换为：1010B～1111B 
    ADD AL, 9 
BINARY: 
    OR  BL, AL   ;将键盘输入的数进行组合 
    DEL  CH    ;保证循环4次，输入四个字符
    JNZ  INPUT
DISPN:  
    MOV CX, 16   ;将16位二进制数一位位地转换成ASCII码显示 
DISP:  
    MOV DL, 0 
    ROL  BX, 1 ;将 BX 中的值左旋转1位。左旋转意味着高位溢出会回绕到低位
    RCL  DL, 1 ;将 DL 中的值左移1位，并将 BX 中移出的位放入 DL 的最低位
    OR  DL, 30H ;将当前位的数值（0或1）转换为相应的 ASCII 字符
    MOV  AH, 2   ;进行显示 
    INT  21H 
    LOOP DISP  ;和cx寄存器配合使用
STOP:  
    RET 