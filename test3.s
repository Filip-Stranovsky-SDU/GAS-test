	.file	"test3.cpp"
	.text
	.globl	_Z10WindowProcP6HWND__jyx
	.def	_Z10WindowProcP6HWND__jyx;	.scl	2;	.type	32;	.endef
	.seh_proc	_Z10WindowProcP6HWND__jyx
_Z10WindowProcP6HWND__jyx:
.LFB5874:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$112, %rsp
	movq	%rcx, 16(%rbp)
	movl	%edx, 24(%rbp)
	movq	%r8, 32(%rbp)
	movq	%r9, 40(%rbp)
	cmpl	$15, 24(%rbp)
	jne	.L2
	leaq	-80(%rbp), %rdx
	movq	16(%rbp), %rax
	movq	%rax, %rcx
	call BeginPaint
	movq	%rax, -8(%rbp)
	leaq	-80(%rbp), %rax
	leaq	12(%rax), %rdx
	movq	-8(%rbp), %rax
	movl	$6, %r8d
	movq	%rax, %rcx
	movq	__imp_FillRect(%rip), %rax
	call	*%rax
	leaq	-80(%rbp), %rdx
	movq	16(%rbp), %rax
	movq	%rax, %rcx
	movq	__imp_EndPaint(%rip), %rax
	call	*%rax
	movl	$0, %eax
	jmp	.L3
.L2:
	movq	40(%rbp), %r8
	movq	32(%rbp), %rcx
	movl	24(%rbp), %edx
	movq	16(%rbp), %rax
	movq	%r8, %r9
	movq	%rcx, %r8
	movq	%rax, %rcx
	movq	__imp_DefWindowProcA(%rip), %rax
	call	*%rax
	nop
.L3:
	addq	$112, %rsp
	popq	%rbp
	ret
	.seh_endproc
	.ident	"GCC: (Rev2, Built by MSYS2 project) 14.2.0"
