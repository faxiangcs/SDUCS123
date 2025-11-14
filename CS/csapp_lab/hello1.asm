
hello：     文件格式 elf64-x86-64


Disassembly of section .init:

0000000000401000 <_init>:
  401000:	f3 0f 1e fa          	endbr64 
  401004:	48 83 ec 08          	sub    $0x8,%rsp
  401008:	48 8b 05 e9 2f 00 00 	mov    0x2fe9(%rip),%rax        # 403ff8 <__gmon_start__>
  40100f:	48 85 c0             	test   %rax,%rax
  401012:	74 02                	je     401016 <_init+0x16>
  401014:	ff d0                	callq  *%rax
  401016:	48 83 c4 08          	add    $0x8,%rsp
  40101a:	c3                   	retq   

Disassembly of section .plt:

0000000000401020 <.plt>:
  401020:	ff 35 e2 2f 00 00    	pushq  0x2fe2(%rip)        # 404008 <_GLOBAL_OFFSET_TABLE_+0x8>
  401026:	f2 ff 25 e3 2f 00 00 	bnd jmpq *0x2fe3(%rip)        # 404010 <_GLOBAL_OFFSET_TABLE_+0x10>
  40102d:	0f 1f 00             	nopl   (%rax)
  401030:	f3 0f 1e fa          	endbr64 
  401034:	68 00 00 00 00       	pushq  $0x0
  401039:	f2 e9 e1 ff ff ff    	bnd jmpq 401020 <.plt>
  40103f:	90                   	nop
  401040:	f3 0f 1e fa          	endbr64 
  401044:	68 01 00 00 00       	pushq  $0x1
  401049:	f2 e9 d1 ff ff ff    	bnd jmpq 401020 <.plt>
  40104f:	90                   	nop
  401050:	f3 0f 1e fa          	endbr64 
  401054:	68 02 00 00 00       	pushq  $0x2
  401059:	f2 e9 c1 ff ff ff    	bnd jmpq 401020 <.plt>
  40105f:	90                   	nop
  401060:	f3 0f 1e fa          	endbr64 
  401064:	68 03 00 00 00       	pushq  $0x3
  401069:	f2 e9 b1 ff ff ff    	bnd jmpq 401020 <.plt>
  40106f:	90                   	nop
  401070:	f3 0f 1e fa          	endbr64 
  401074:	68 04 00 00 00       	pushq  $0x4
  401079:	f2 e9 a1 ff ff ff    	bnd jmpq 401020 <.plt>
  40107f:	90                   	nop
  401080:	f3 0f 1e fa          	endbr64 
  401084:	68 05 00 00 00       	pushq  $0x5
  401089:	f2 e9 91 ff ff ff    	bnd jmpq 401020 <.plt>
  40108f:	90                   	nop

Disassembly of section .plt.sec:

0000000000401090 <puts@plt>:
  401090:	f3 0f 1e fa          	endbr64 
  401094:	f2 ff 25 7d 2f 00 00 	bnd jmpq *0x2f7d(%rip)        # 404018 <puts@GLIBC_2.2.5>
  40109b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

00000000004010a0 <strtol@plt>:
  4010a0:	f3 0f 1e fa          	endbr64 
  4010a4:	f2 ff 25 75 2f 00 00 	bnd jmpq *0x2f75(%rip)        # 404020 <strtol@GLIBC_2.2.5>
  4010ab:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

00000000004010b0 <__printf_chk@plt>:
  4010b0:	f3 0f 1e fa          	endbr64 
  4010b4:	f2 ff 25 6d 2f 00 00 	bnd jmpq *0x2f6d(%rip)        # 404028 <__printf_chk@GLIBC_2.3.4>
  4010bb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

00000000004010c0 <exit@plt>:
  4010c0:	f3 0f 1e fa          	endbr64 
  4010c4:	f2 ff 25 65 2f 00 00 	bnd jmpq *0x2f65(%rip)        # 404030 <exit@GLIBC_2.2.5>
  4010cb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

00000000004010d0 <sleep@plt>:
  4010d0:	f3 0f 1e fa          	endbr64 
  4010d4:	f2 ff 25 5d 2f 00 00 	bnd jmpq *0x2f5d(%rip)        # 404038 <sleep@GLIBC_2.2.5>
  4010db:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

00000000004010e0 <getc@plt>:
  4010e0:	f3 0f 1e fa          	endbr64 
  4010e4:	f2 ff 25 55 2f 00 00 	bnd jmpq *0x2f55(%rip)        # 404040 <getc@GLIBC_2.2.5>
  4010eb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

Disassembly of section .text:

00000000004010f0 <_start>:
  4010f0:	f3 0f 1e fa          	endbr64 
  4010f4:	31 ed                	xor    %ebp,%ebp
  4010f6:	49 89 d1             	mov    %rdx,%r9
  4010f9:	5e                   	pop    %rsi
  4010fa:	48 89 e2             	mov    %rsp,%rdx
  4010fd:	48 83 e4 f0          	and    $0xfffffffffffffff0,%rsp
  401101:	50                   	push   %rax
  401102:	54                   	push   %rsp
  401103:	49 c7 c0 20 12 40 00 	mov    $0x401220,%r8
  40110a:	48 c7 c1 b0 11 40 00 	mov    $0x4011b0,%rcx
  401111:	48 c7 c7 25 11 40 00 	mov    $0x401125,%rdi
  401118:	ff 15 d2 2e 00 00    	callq  *0x2ed2(%rip)        # 403ff0 <__libc_start_main@GLIBC_2.2.5>
  40111e:	f4                   	hlt    
  40111f:	90                   	nop

0000000000401120 <_dl_relocate_static_pie>:
  401120:	f3 0f 1e fa          	endbr64 
  401124:	c3                   	retq   

0000000000401125 <main>:
  401125:	f3 0f 1e fa          	endbr64 
  401129:	55                   	push   %rbp
  40112a:	53                   	push   %rbx
  40112b:	48 83 ec 08          	sub    $0x8,%rsp
  40112f:	83 ff 05             	cmp    $0x5,%edi
  401132:	75 4d                	jne    401181 <main+0x5c>
  401134:	48 89 f3             	mov    %rsi,%rbx
  401137:	bd 00 00 00 00       	mov    $0x0,%ebp
  40113c:	83 fd 09             	cmp    $0x9,%ebp
  40113f:	7f 54                	jg     401195 <main+0x70>
  401141:	48 8b 4b 10          	mov    0x10(%rbx),%rcx
  401145:	48 8b 53 08          	mov    0x8(%rbx),%rdx
  401149:	4c 8b 43 18          	mov    0x18(%rbx),%r8
  40114d:	be 38 20 40 00       	mov    $0x402038,%esi
  401152:	bf 01 00 00 00       	mov    $0x1,%edi
  401157:	b8 00 00 00 00       	mov    $0x0,%eax
  40115c:	e8 4f ff ff ff       	callq  4010b0 <__printf_chk@plt>
  401161:	48 8b 7b 20          	mov    0x20(%rbx),%rdi
  401165:	ba 0a 00 00 00       	mov    $0xa,%edx
  40116a:	be 00 00 00 00       	mov    $0x0,%esi
  40116f:	e8 2c ff ff ff       	callq  4010a0 <strtol@plt>
  401174:	48 89 c7             	mov    %rax,%rdi
  401177:	e8 54 ff ff ff       	callq  4010d0 <sleep@plt>
  40117c:	83 c5 01             	add    $0x1,%ebp
  40117f:	eb bb                	jmp    40113c <main+0x17>
  401181:	bf 08 20 40 00       	mov    $0x402008,%edi
  401186:	e8 05 ff ff ff       	callq  401090 <puts@plt>
  40118b:	bf 01 00 00 00       	mov    $0x1,%edi
  401190:	e8 2b ff ff ff       	callq  4010c0 <exit@plt>
  401195:	48 8b 3d b4 2e 00 00 	mov    0x2eb4(%rip),%rdi        # 404050 <stdin@@GLIBC_2.2.5>
  40119c:	e8 3f ff ff ff       	callq  4010e0 <getc@plt>
  4011a1:	b8 00 00 00 00       	mov    $0x0,%eax
  4011a6:	48 83 c4 08          	add    $0x8,%rsp
  4011aa:	5b                   	pop    %rbx
  4011ab:	5d                   	pop    %rbp
  4011ac:	c3                   	retq   
  4011ad:	0f 1f 00             	nopl   (%rax)

00000000004011b0 <__libc_csu_init>:
  4011b0:	f3 0f 1e fa          	endbr64 
  4011b4:	41 57                	push   %r15
  4011b6:	4c 8d 3d 93 2c 00 00 	lea    0x2c93(%rip),%r15        # 403e50 <_DYNAMIC>
  4011bd:	41 56                	push   %r14
  4011bf:	49 89 d6             	mov    %rdx,%r14
  4011c2:	41 55                	push   %r13
  4011c4:	49 89 f5             	mov    %rsi,%r13
  4011c7:	41 54                	push   %r12
  4011c9:	41 89 fc             	mov    %edi,%r12d
  4011cc:	55                   	push   %rbp
  4011cd:	48 8d 2d 7c 2c 00 00 	lea    0x2c7c(%rip),%rbp        # 403e50 <_DYNAMIC>
  4011d4:	53                   	push   %rbx
  4011d5:	4c 29 fd             	sub    %r15,%rbp
  4011d8:	48 83 ec 08          	sub    $0x8,%rsp
  4011dc:	e8 1f fe ff ff       	callq  401000 <_init>
  4011e1:	48 c1 fd 03          	sar    $0x3,%rbp
  4011e5:	74 1f                	je     401206 <__libc_csu_init+0x56>
  4011e7:	31 db                	xor    %ebx,%ebx
  4011e9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  4011f0:	4c 89 f2             	mov    %r14,%rdx
  4011f3:	4c 89 ee             	mov    %r13,%rsi
  4011f6:	44 89 e7             	mov    %r12d,%edi
  4011f9:	41 ff 14 df          	callq  *(%r15,%rbx,8)
  4011fd:	48 83 c3 01          	add    $0x1,%rbx
  401201:	48 39 dd             	cmp    %rbx,%rbp
  401204:	75 ea                	jne    4011f0 <__libc_csu_init+0x40>
  401206:	48 83 c4 08          	add    $0x8,%rsp
  40120a:	5b                   	pop    %rbx
  40120b:	5d                   	pop    %rbp
  40120c:	41 5c                	pop    %r12
  40120e:	41 5d                	pop    %r13
  401210:	41 5e                	pop    %r14
  401212:	41 5f                	pop    %r15
  401214:	c3                   	retq   
  401215:	66 66 2e 0f 1f 84 00 	data16 nopw %cs:0x0(%rax,%rax,1)
  40121c:	00 00 00 00 

0000000000401220 <__libc_csu_fini>:
  401220:	f3 0f 1e fa          	endbr64 
  401224:	c3                   	retq   

Disassembly of section .fini:

0000000000401228 <_fini>:
  401228:	f3 0f 1e fa          	endbr64 
  40122c:	48 83 ec 08          	sub    $0x8,%rsp
  401230:	48 83 c4 08          	add    $0x8,%rsp
  401234:	c3                   	retq   
