
.equ XD, 0

.section .data
    title:    .asciz "Hello, World!"               # Title of the message box
    message:  .asciz "Hello from Win64 API!"       # Message content

.section .text
        
    _start:
        # Reserve stack space for 64-bit arguments (shadow space requirement for Windows)
        subq $40, %rsp

        # Set up arguments for MessageBoxA
        movq XD, %rcx         # hWnd (NULL)
        lea message(%rip), %rdx # lpText (pointer to message)
        lea title(%rip), %r8  # lpCaption (pointer to title)
        movq $0, %r9          # uType (MB_OK)

        # Call MessageBoxA
        call MessageBoxA
    _xd:
        # Set up arguments for ExitProcess
        movq $0, %rcx         # uExitCode
        call ExitProcess

        # Restore stack
        addq $40, %rsp

        # Halt execution (in case ExitProcess fails)
        hlt

.extern MessageBoxA          # Import MessageBoxA from user32.dll
.extern ExitProcess          # Import ExitProcess from kernel32.dll
