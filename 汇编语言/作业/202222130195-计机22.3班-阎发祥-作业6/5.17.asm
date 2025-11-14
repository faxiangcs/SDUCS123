;5.17 transfer xxH to ASCII
DATA SEGMENT
    MEM DB 4 DUP (?)       ; 定义一个字节数组 MEM，用于存储4个ASCII字符
    N DW 2A49H             ; 定义一个字（2字节）的十六进制数 N
DATA ENDS

CODE SEGMENT
    ASSUME CS: CODE, DS: DATA 
START:  
    SUB AX, AX             ; 清空 AX 寄存器
    MOV AX, DATA           ; 将数据段的地址加载到 AX
    MOV DS, AX             ; 将 AX 的值赋给 DS，设置数据段
BEGIN:  
    MOV CH, 4              ; 循环计数器，设置为4，表示将转换4位
    MOV CL, 4              ; 设置 CL 为4，表示每次右移4位
    MOV AX, N              ; 将十六进制数 N 加载到 AX 中
    LEA BX, MEM            ; 将 MEM 数组的地址加载到 BX 中
ROTATE: 
    MOV DL, AL             ; 从 AL 中获取最低四位，准备进行ASCII转换
    AND DL, 0FH            ; 取出 AL 的最低四位（0-15）
    ADD DL, 30H            ; 将数值转换为对应的ASCII字符（'0'-'9' 或 'A'-'F'）
    CMP DL, 3AH            ; 检查 DL 是否小于 '3A'，即检查是否在0-9范围内
    JL NEXT                ; 如果小于 '3A'，跳转到 NEXT
    ADD DL, 07H            ; 如果大于 '9'，则转换为 'A'-'F'
NEXT:  
    MOV [BX], DL           ; 将转换后的ASCII字符存储到 MEM 数组中
    INC BX                 ; BX 指向下一个存储位置
    ROR AX, CL             ; 将 AX 右旋转4位，以准备转换下一位
    DEC CH                 ; 循环计数器减1
    JNZ ROTATE             ; 如果 CH 不为0，则继续循环 ROTATE
    RET                    ; 返回程序
CODE ENDS                 ; 结束代码段

