#include <windows.h>


void* main(){
    return LoadImageA(NULL, "#32512", IMAGE_CURSOR, 0, 0, LR_SHARED);

}