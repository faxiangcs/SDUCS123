5.21 COMPARE THREE NUMBERS
DATA SEGMENT
    ARRAY DW 3 DUP (?)     ; 定义一个数组 ARRAY，包含3个字（未初始化）用于存放要比较的数字
DATA ENDS

CODE SEGMENT
    ASSUME CS: CODE, DS: DATA 
START: 
    SUB AX, AX             ; 清空 AX 寄存器
    MOV AX, DATA           ; 加载数据段地址到 AX
    MOV DS, AX             ; 将 AX 的值赋给 DS，设置数据段

BEGIN: 
    LEA SI, ARRAY          ; 将 ARRAY 的地址加载到 SI 寄存器
    MOV DX, 0              ; 将 DX 初始化为0，DX 用于存放相等数字的计数

    MOV AX, [SI]          ; 将第一个数加载到 AX
    MOV BX, [SI+2]        ; 将第二个数加载到 BX

    CMP AX, BX            ; 比较第一个和第二个数是否相等
    JNE NEXT1             ; 如果不相等，跳转到 NEXT1
    INC DX                ; 如果相等，计数器 DX 增加1

NEXT1:  
    CMP [SI+4], AX        ; 比较第三个数与第一个数是否相等
    JNE NEXT2             ; 如果不相等，跳转到 NEXT2
    INC DX                ; 如果相等，计数器 DX 增加1

NEXT2:  
    CMP [SI+4], BX        ; 比较第三个数与第二个数是否相等
    JNE NUM               ; 如果不相等，跳转到 NUM
    INC DX                ; 如果相等，计数器 DX 增加1

NUM: 
    CMP DX, 3             ; 检查相等的数字是否为3个
    JL DISP               ; 如果相等的数量小于3，跳转到 DISP
    DEC DX                ; 如果相等3个，DX 减1（转换为ASCII时用）

DISP: 
    ADD DL, 30H           ; 将计数值转换为ASCII码（'0'的ASCII值是30H）
    MOV AH, 2             ; 设置 AH 为2，准备调用显示字符功能
    INT 21H               ; 调用 DOS 中断，显示字符
    RET                    ; 返回程序
CODE ENDS                ; 结束代码段
