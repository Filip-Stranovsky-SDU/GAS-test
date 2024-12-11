    .section .data
var: .quad 56

    .section .text
_start:
    movq $20, %rbx

    movq $10, %rax

    leaq -8(%rax, %rbx, 2), %rcx
_xd:
    hlt
