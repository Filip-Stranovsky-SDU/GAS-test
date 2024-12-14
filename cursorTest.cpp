#include <windows.h>
#include <stdio.h>
#include <iostream>
using namespace std;

int main() {
    /*HCURSOR hCursor = (HCURSOR)LoadImageA(NULL, "#32512", IMAGE_CURSOR, 0, 0, LR_SHARED);
    if (hCursor == NULL) {
        printf("Error: %lu\n", GetLastError());
    } else {
        printf("Cursor loaded successfully!\n");
    }*/
    CreateWindowExA(WS_EX_APPWINDOW, "XD", "DX", WS_MAXIMIZE, 0,0,640,480,NULL,NULL,NULL,NULL);
    while(true);
    return 0;
}