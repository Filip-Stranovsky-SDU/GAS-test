#include <windows.h>
#include <stdio.h>

void xd(){}
void dx(){}

int plem() {
    HINSTANCE hInstance = GetModuleHandleA(NULL);
    WNDCLASSA wc = {0};
    wc.lpfnWndProc = DefWindowProcA;
    wc.hInstance = hInstance;
    wc.lpszClassName = "MyClass";

    RegisterClassA(&wc);

    HWND hwnd = CreateWindowExA(
        0,                    // dwExStyle
        "MyClass",            // lpClassName
        "My Window",          // lpWindowName
        WS_OVERLAPPEDWINDOW,  // dwStyle
        CW_USEDEFAULT,        // x
        CW_USEDEFAULT,        // y
        640,                  // nWidth
        480,                  // nHeight
        NULL,                 // hWndParent
        NULL,                 // hMenu
        hInstance,            // hInstance
        NULL                  // lpParam
    );

    return 0;
}
