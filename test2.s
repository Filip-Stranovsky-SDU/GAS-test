	.file	"test2.c"
	.text
	.section .rdata,"dr"
.LC0:
	.ascii "#32512\0"
	.text
	.globl	main
	.def	main;	.scl	2;	.type	32;	.endef
	.seh_proc	main
main:
	pushq	%rbp
	.seh_pushreg	%rbp
	movq	%rsp, %rbp
	.seh_setframe	%rbp, 0
	subq	$48, %rsp
	.seh_stackalloc	48
	.seh_endprologue
	call	__main
	movl	$32768, 40(%rsp)
	movl	$0, 32(%rsp)
	movl	$0, %r9d
	movl	$2, %r8d
	leaq	.LC0(%rip), %rax
	movq	%rax, %rdx
	movl	$0, %ecx
	movq	__imp_LoadImageA(%rip), %rax
	call	*%rax
	addq	$48, %rsp
	popq	%rbp
	ret
	.seh_endproc
	.def	__main;	.scl	2;	.type	32;	.endef
	.ident	"GCC: (Rev2, Built by MSYS2 project) 14.2.0"
