
hello.o：     文件格式 elf64-x86-64


Disassembly of section .text:

0000000000000000 <main>:
   0:	f3 0f 1e fa          	endbr64 
   4:	55                   	push   %rbp
   5:	53                   	push   %rbx
   6:	48 83 ec 08          	sub    $0x8,%rsp
   a:	83 ff 05             	cmp    $0x5,%edi
   d:	75 4d                	jne    5c <main+0x5c>
   f:	48 89 f3             	mov    %rsi,%rbx
  12:	bd 00 00 00 00       	mov    $0x0,%ebp
  17:	83 fd 09             	cmp    $0x9,%ebp
  1a:	7f 54                	jg     70 <main+0x70>
  1c:	48 8b 4b 10          	mov    0x10(%rbx),%rcx
  20:	48 8b 53 08          	mov    0x8(%rbx),%rdx
  24:	4c 8b 43 18          	mov    0x18(%rbx),%r8
  28:	be 00 00 00 00       	mov    $0x0,%esi
			29: R_X86_64_32	.rodata.str1.1
  2d:	bf 01 00 00 00       	mov    $0x1,%edi
  32:	b8 00 00 00 00       	mov    $0x0,%eax
  37:	e8 00 00 00 00       	callq  3c <main+0x3c>
			38: R_X86_64_PLT32	__printf_chk-0x4
  3c:	48 8b 7b 20          	mov    0x20(%rbx),%rdi
  40:	ba 0a 00 00 00       	mov    $0xa,%edx
  45:	be 00 00 00 00       	mov    $0x0,%esi
  4a:	e8 00 00 00 00       	callq  4f <main+0x4f>
			4b: R_X86_64_PLT32	strtol-0x4
  4f:	48 89 c7             	mov    %rax,%rdi
  52:	e8 00 00 00 00       	callq  57 <main+0x57>
			53: R_X86_64_PLT32	sleep-0x4
  57:	83 c5 01             	add    $0x1,%ebp
  5a:	eb bb                	jmp    17 <main+0x17>
  5c:	bf 00 00 00 00       	mov    $0x0,%edi
			5d: R_X86_64_32	.rodata.str1.8
  61:	e8 00 00 00 00       	callq  66 <main+0x66>
			62: R_X86_64_PLT32	puts-0x4
  66:	bf 01 00 00 00       	mov    $0x1,%edi
  6b:	e8 00 00 00 00       	callq  70 <main+0x70>
			6c: R_X86_64_PLT32	exit-0x4
  70:	48 8b 3d 00 00 00 00 	mov    0x0(%rip),%rdi        # 77 <main+0x77>
			73: R_X86_64_PC32	stdin-0x4
  77:	e8 00 00 00 00       	callq  7c <main+0x7c>
			78: R_X86_64_PLT32	getc-0x4
  7c:	b8 00 00 00 00       	mov    $0x0,%eax
  81:	48 83 c4 08          	add    $0x8,%rsp
  85:	5b                   	pop    %rbx
  86:	5d                   	pop    %rbp
  87:	c3                   	retq   
