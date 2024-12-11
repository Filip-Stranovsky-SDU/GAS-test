//###########################################################################
//###########################################################################
// ABOUT SPACE-TRIS:
//
// This is the main portion of code. It has WinMain and performs all
// of the management for the game.
//
// - WinMain()
// - WndProc()
// - Main_Loop()
// - Game_Init()
// - Game_Main()
// - Game_Shutdown()
//
//
//###########################################################################
//###########################################################################


//###########################################################################
//###########################################################################
// THE INCLUDES SECTION
//###########################################################################
//###########################################################################


.extern MessageBoxA
.extern ExitProcess
.extern GetModuleHandleA
.extern GetCommandLineA

.extern LoadIconA
.extern GetStockObject
.extern LoadCursorA

.extern RegisterClass
.extern CreateWindowExA
.extern ShowCursor
.extern ShowWindow

.extern PeekMessageA
.extern TranslateMessage
.extern DispatchMessageA

.extern GetLastError




//#################################################################################
//#################################################################################
// Variables we want to use in other modules
//#################################################################################
//#################################################################################


//#################################################################################
//#################################################################################
// External variables
//#################################################################################
//#################################################################################


//#################################################################################
//#################################################################################
// BEGIN INITIALIZED DATA
//#################################################################################
//#################################################################################

    .section .data
hInstance:      .quad 0        # Reserve space for HINSTANCE
hPrevInstance:  .quad 0        # Reserve space for HINSTANCE
lpCmdLine:      .quad 0        # Reserve space for LPSTR
hMainWnd:       .quad 0
nCmdShow:       .long 0        # Reserve space for int (4 bytes)
                .long 0        # Padding for alignment (optional)
                .quad 0

MSG:
    .quad 0      # HWND *hwnd
    .long 0      # UINT message
    .long 0      # Alignment padding (if needed)
    .quad 0      # WPARAM wParam (assuming 64-bit)
    .quad 0      # LPARAM lParam (assuming 64-bit)
    .long 0      # DWORD time
    .long 0      # Alignment padding
    .long 0      # POINT x
    .long 0      # POINT y
    .long 0      # DWORD lPrivate
    .long 0      # Alignment padding



szClassName:
    .asciz "MyWindowClass"   # Class name as a null-terminated string
iconName:
    .asciz "IDI_MYICON"
cursorName:
    .asciz "IDC_ARROW"

    .section .bss
    .lcomm wc, 80            # Allocate 80 bytes for the WNDCLASSA structure



//#################################################################################
//#################################################################################
// BEGIN CONSTANTS
//#################################################################################
//#################################################################################


//#################################################################################
//#################################################################################
// BEGIN EQUATES
//#################################################################################
//#################################################################################
.equ WM_QUIT, 0x0012
.equ BLACK_BRUSH, 4 

//#################################################################################
//#################################################################################
// BEGIN THE CODE SECTION
//#################################################################################
//#################################################################################

    .section .text
.globl _start
_start:
    mov $0, %rcx
    call GetModuleHandleA

    push %rax

    call GetCommandLineA
    
    pop %rcx
    mov $0, %rdx
    mov %rax, %r8
    mov $0, %r9

    call WinMain

    movq $0, %rcx
    call ExitProcess

    hlt



//########################################################################
// WinMain Function
//########################################################################

.globl WinMain
WinMain:
        # Prologue

    push %rbp

    mov %rsp, %rbp


    # Store arguments
    mov %rcx, hInstance(%rip) # hInstance
    mov %rdx, hPrevInstance(%rip)   # hPrevInstance
    mov %r8, lpCmdLine(%rip)    # lpCmdLine
    mov %r9d, nCmdShow(%rip)   # nCmdShow

    ###############################
    #WNDCLASSA SETUP
    ###############################
    
    movq $0x0020, wc(%rip)
    
    leaq WndProc(%rip), %rax     # Address of WndProc
    movq %rax, wc+8(%rip)              # lpfnWndProc

    movl $0, wc+16(%rip)               # cbClsExtra
    movl $0, wc+20(%rip)               # cbWndExtra

    movq hInstance(%rip), %rax       # hInstance
    movq %rax, wc+24(%rip)

    # Call LoadIcon(hInst, IDI_ICON)
    movq hInstance(%rip), %rcx       # hInst (first argument)
    leaq iconName(%rip), %rdx              # IDI_ICON (second argument, exinoample ID)
    call LoadIconA
    movq %rax, wc+32(%rip)             # hIcon

    # Call LoadCursor(NULL, IDC_ARROW)
    movq hInstance(%rip), %rcx                # NULL
    leaq cursorName(%rip), %rdx            # IDC_ARROW = 32512
    call LoadCursorA
    _xd:
    movq %rax, wc+40(%rip)             # hCursor

    # Call GetStockObject(BLACK_BRUSH)
    movl $4, %ecx                # BLACK_BRUSH = 4
    call GetStockObject
    movq %rax, wc+48(%rip)             # hbrBackground

    movq $0, wc+56(%rip)               # lpszMenuName = NULL

    leaq szClassName(%rip), %rax # Offset of szClassName
    movq %rax, wc+64(%rip)             # lpszClassName

    mov $0, %rcx
    mov $0, %rdx
    mov %rax, wc+72(%rip) #LPCSTR *lpszClassName


    ###############################
    #WNDCLASSA SETUP END
    ###############################
    leaq wc(%rip), %rcx
    call RegisterClassExA #REGISTER wc

    ###############################
    #Create the main screen
    ###############################

    movl $0x00040000L, %ecx    #DWORD dwExStyle
    leaq szClassName(%rip), %rdx    #LPCSTR lpClassName
    movq $0, %r8    #LPCSTR lpWindowName
    movq $1, %r9    #DWORD dwStyle
    push $0    #int X
    push $0    #int Y
    push $640  #int nWidth
    push $480  #int nHeight
    pushq $0
    pushq $0
    leaq hInstance(%rip), %rax
    pushq %rax
    pushq $0

    subq $40, %rsp
    call CreateWindowExA
    add $40, %rsp

    mov %rax, hMainWnd(%rip)

    movq $0, %rcx
    subq $40, %rsp
    call ShowCursor
    add $40, %rsp

    leaq hMainWnd(%rip), %rcx
    movl nCmdShow(%rip), %edx
    subq $40, %rsp
    call ShowWindow
    add $40, %rsp

    call Game_Init ## CUSTOM GAME INIT, not win32
    
    cmp $0, %eax
    jnz _shutdown #IF error status !=0, Game_Init failed

    #####################################
    # Loop until PostQuitMessage is sent
    #####################################
    _gameLoop:
        #Setup PeekMessageA
        leaq MSG(%rip), %rcx
        movl $0, %edx
        movl $0, %r8d
        movl $0, %r9d
        push $0x001

        call PeekMessageA

        cmp $0, %eax
        jz _after1if
        
        movl MSG+8(%rip), %eax
        cmp WM_QUIT(%rip), %eax
        je _shutdown
    
    
        leaq MSG(%rip), %rcx
        call TranslateMessage
        leaq MSG(%rip), %rcx
        call DispatchMessageA

    _after1if:

        call Game_Main ## Custom Game_Main

        jmp _gameLoop



    #Reset stack
    mov %rbp, %rsp
    pop %rbp

    add $80, %rsp

    # Return an exit code
    mov $0, %eax            # Return 0

_shutdown:
    call Game_Shutdown
    mov $1, %rcx
    call ShowCursor
_getout:
    mov $0, %rax ##TODO: msg.wParam
    ret


//########################################################################
// End of WinMain Procedure
//########################################################################



//########################################################################
// Main Window Callback Procedure -- WndProc
//########################################################################

.global WndProc
WndProc:
    ret
//########################################################################
// End of Main Windows Callback Procedure
//########################################################################




//========================================================================
//========================================================================
// THE GAME PROCEDURES
//========================================================================
//========================================================================


//########################################################################
// Game_Init Procedure
//########################################################################
    .global Game_Init
Game_Init:
    xor %rax, %rax
    ret
//########################################################################
// END Game_Init
//########################################################################



//########################################################################
// Game_Main Procedure
//########################################################################
    .global Game_Main
Game_Main:
    ret

//########################################################################
// END Game_Main
//########################################################################



//########################################################################
// Game_Shutdown Procedure
//########################################################################
    .global Game_Shutdown
Game_Shutdown:
    ret

//########################################################################
// END Game_Shutdown
//########################################################################

//######################################
// THIS IS THE END OF THE PROGRAM CODE #
//######################################
