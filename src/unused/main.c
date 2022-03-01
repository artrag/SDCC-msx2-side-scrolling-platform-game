#include "test.h"


void main() {
	unsigned char *p,n;
	
    chgmod(0);
    print_hello();			// banked call
    print_hello_rev();		// banked call
	
	// test paged data access
	__asm
	ld	a,#b_data1
	ld (#0x9000),a
	ld (#_curr_bank),a
    inc a
	ld (#0xb000),a
	__endasm;
	
	p = (unsigned char*) 0x8000;
	
	for (n=0;n<10;n++) {
		putch(*p++);
	}
	putch('\r');
	putch('\n');

	__asm
	ld	a,#b_data0
	ld (#0x9000),a
	ld (#_curr_bank),a
    inc a
	ld (#0xb000),a
	__endasm;

	p = (unsigned char*) 0x8100;
	
	for (n=0;n<5;n++) {
		putch(*p++);
	}

	putch('\r');
	putch('\n');
	
    while(1);
}

void chgmod(char c) __naked {
	c;
    __asm
    jp 0x005f
    __endasm;
}

void putch(char c) __naked {
	c;
    __asm
    jp 0x00a2
    __endasm;
}
