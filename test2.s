	.file	"test2.c"

	.section .rdata,"dr"
.LC0:
	.ascii "MyClass\0"
.LC1:
	.ascii "My Window\0"
	.text
plem:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$192, %rsp

	movl	$0, %ecx
	movq	__imp_GetModuleHandleA(%rip), %rax
	call	*%rax

	movq	%rax, -8(%rbp)
	
	pxor	%xmm0, %xmm0
	movups	%xmm0, -96(%rbp)
	movups	%xmm0, -80(%rbp)
	movups	%xmm0, -64(%rbp)
	movups	%xmm0, -48(%rbp)
	movq	%xmm0, -32(%rbp)
	
	movq	__imp_DefWindowProcA(%rip), %rax
	movq	%rax, -88(%rbp)
	movq	-8(%rbp), %rax
	movq	%rax, -72(%rbp)
	leaq	.LC0(%rip), %rax
	movq	%rax, -32(%rbp)
	leaq	-96(%rbp), %rax
	movq	%rax, %rcx
	movq	__imp_RegisterClassA(%rip), %rax
	call	*%rax
	movq	$0, 88(%rsp)
	movq	-8(%rbp), %rax
	movq	%rax, 80(%rsp)
	movq	$0, 72(%rsp)
	movq	$0, 64(%rsp)
	movl	$480, 56(%rsp)
	movl	$640, 48(%rsp)
	movl	$-2147483648, 40(%rsp)
	movl	$-2147483648, 32(%rsp)
	movl	$13565952, %r9d
	leaq	.LC1(%rip), %r8
	leaq	.LC0(%rip), %rax
	movq	%rax, %rdx
	movl	$0, %ecx
	movq	__imp_CreateWindowExA(%rip), %rax
	call	*%rax
	movq	%rax, -16(%rbp)
	movl	$0, %eax
	addq	$192, %rsp
	popq	%rbp
	ret
	.seh_endproc
	.ident	"GCC: (Rev2, Built by MSYS2 project) 14.2.0"
