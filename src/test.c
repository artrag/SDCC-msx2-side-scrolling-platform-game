#include "test.h"

void print(char* c) {
    do {
        putch(*c);
    } while(*c++);
}

void print_hello() __banked  {
    print("Hello world from bank2-3 \r\n");
}
