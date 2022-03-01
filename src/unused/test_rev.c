#include "test.h"

void print_rev(char* c) {
    do {
        putch(*c);
    } while(*c++);
}

void print_hello_rev() __banked  {
    print_rev("Hello world from bank4-5  \r\n");
}
