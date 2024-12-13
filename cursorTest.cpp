#include <windows.h>
#include <stdio.h>
#include <iostream>
using namespace std;

int main() {
    HCURSOR hCursor = (HCURSOR)LoadImageA(NULL, "#32512", IMAGE_CURSOR, 0, 0, LR_SHARED);
    if (hCursor == NULL) {
        printf("Error: %lu\n", GetLastError());
    } else {
        printf("Cursor loaded successfully!\n");
    }
    
    return 0;
}