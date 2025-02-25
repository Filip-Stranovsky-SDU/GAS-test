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

.extern RegisterClassA
.extern CreateWindowExA
.extern ShowCursor
.extern ShowWindow

.extern PeekMessageA
.extern TranslateMessage
.extern DispatchMessageA

.extern LoadImageA

.extern GetLastError

.extern DefWindowProcA
.extern PostQuitMessage
.extern GetMessageA

.extern BeginPaint
.extern EndPaint
.extern FillRect


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
szDisplayName:
    .asciz "MyDisplayClass"

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
.equ WM_PAINT, 15
.equ WM_DESTROY, 2
.equ WM_KEYDOWN, 256
.equ WM_KEYUP, 257


.equ BLACK_BRUSH, 4 

.equ IMAGE_BITMAP, 0
.equ IMAGE_ICON, 1
.equ IMAGE_CURSOR, 2

.equ LR_SHARED, 32768

.equ IDI_APPLICATION, 32512
.equ IDC_ARROW, 32512

.equ SW_SHOWDEFAULT, 10

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
    xor %rcx, %rcx                # NULL
    movq $IDI_APPLICATION, %rdx
    mov $IMAGE_ICON, %r8     #uint type
    xor %r9, %r9    #int cx
    push $LR_SHARED
    push $0
    sub $32, %rsp
    call LoadImageA
    add $32, %rsp
    movq %rax, wc+32(%rip)             # hIcon
    
    # Call LoadCursor(NULL, IDC_ARROW)
    xor %rcx, %rcx                # NULL
    movq $IDC_ARROW, %rdx
    mov $IMAGE_CURSOR, %r8     #uint type
    xor %r9, %r9    #int cx
    push $LR_SHARED
    push $0
    sub $32, %rsp
    call LoadImageA
    add $32, %rsp
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
    sub $40, %rsp
    call RegisterClassA #REGISTER wc
    add $40, %rsp

    ###############################
    #Create the main screen
    ###############################
    sub $8, %rsp #16-byte stack allignment first, then parameters, then shadowspace, then call XD


    movl $0, %ecx    #DWORD dwExStyle
    leaq szClassName(%rip), %rdx    #LPCSTR lpClassName
    leaq szDisplayName(%rip), %r8    #LPCSTR lpWindowName
    movq $13565952, %r9    #DWORD dwStyle
    push $0
    movq hInstance(%rip), %rax
    push %rax

    push $0
    push $0
    pushq $480
    pushq $640
    pushq $0
    pushq $0

    subq $32, %rsp
    call CreateWindowExA
    add $40, %rsp

    mov %rax, hMainWnd(%rip)

    movq $1, %rcx
    subq $40, %rsp
    call ShowCursor
    add $40, %rsp

    movq hMainWnd(%rip), %rcx
    movl $SW_SHOWDEFAULT, %edx
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

        sub $32, %rsp
        call GetMessageA
        add $32, %rsp

        cmp $0, %eax
        je _getout

        movq MSG(%rip), %rax
        cmp $0, %rax
        je _after1if

        
        movl MSG+8(%rip), %eax
        cmp $WM_QUIT, %eax
        je _shutdown
    
    
        leaq MSG(%rip), %rcx
        sub $32, %rsp
        call TranslateMessage
        leaq MSG(%rip), %rcx
        call DispatchMessageA
        add $32, %rsp

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
    mov $0, %rcx
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
    push %rbp
    mov %rsp, %rbp

    movq	%rcx, 16(%rbp)
	movl	%edx, 24(%rbp)
	movq	%r8, 32(%rbp)
	movq	%r9, 40(%rbp)

    cmp $WM_DESTROY, %rdx
    jne _notQuit
    xor %rcx, %rcx
    sub $32, %rsp
    call PostQuitMessage
    add $32, %rsp
    
    mov %rbp, %rsp
    pop %rbp
    xor %rax, %rax
    ret
    
    _notQuit:
    cmp $WM_PAINT, %rdx
    jne _notPaint

    ## PAINT START

    sub $80, %rsp   #ROOM for PAINTSTRUCT(80 bytes)   
    
    


    movq 16(%rbp), %rcx #HWND
    leaq -80(%rbp), %rdx #PAINTSTRUCT POINTER
    subq $32, %rsp
    call BeginPaint
    addq $32, %rsp
    _xd1:
    movl $5, -64(%rbp)
    movl $5, -60(%rbp)
    movl $200, -56(%rbp)
    movl $100, -52(%rbp)

    movq %rax, %rcx #HDC hDC
    leaq -64(%rbp), %rdx #RECT *lprc
    movq $6, %r8 
    //movq $6, %r9
    subq $32, %rsp
    call FillRect
    addq $32, %rsp

    movq 16(%rbp), %rcx
    leaq 80(%rbp), %rdx
    subq $32, %rsp
    call EndPaint
    addq $32, %rsp

    mov %rbp, %rsp
    pop %rbp
    xor %rax, %rax
    ret

    ##PAINT END
    _notPaint:

    ## INPUT START

    cmp $


    sub $32, %rsp
    call DefWindowProcA
    add $32, %rsp

    pop %rbp
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
    mov $0, %rax
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
