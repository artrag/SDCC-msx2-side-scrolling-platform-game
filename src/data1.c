#include "test.h"

void data1(void) __banked __naked {
    __asm
    .incbin "data\tile1.bin"
    __endasm;
}