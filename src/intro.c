
#include <string.h>
#include <stdlib.h>
#include <stdio.h>

#include "myheader.h"

extern const char fire_palette[];
extern const char title_sprites[];
extern const char title_sat[];
extern const char gradient_colrs[];
extern const char gradient_tiles[];

void FireIteration(char *b) __sdcccall(1);


char buffer[24*32];
	
void intro(void) __banked  
{
	chgmod(4);						  		// Init Screen 4
	myVDPwrite(0,7);						// borders	
	RG1SAV |= 2;
	myVDPwrite(RG1SAV,1);
	RG8SAV |= 32;
	myVDPwrite(RG8SAV,8);
	
	SetPalette(fire_palette);

	const int bb = 6144+23*32;

	SetVramW14(0x3800);
	VramWrite((unsigned int)title_sprites,32*32);

	SetVramW14(0x1C00);
	for (int i=32*16;i>0;i--) {
		Port98 = 7;
	}

	SetVramW14(0x1E00);
	VramWrite((unsigned int)title_sat,32*4);
	

	SetVramW14(0);
	for (char j=0;j<16*3;j++) {
		VramWrite((unsigned int)gradient_tiles,8*16);
	}
	
	for (char s=0;s<3;s++) {
		SetVramW14(0x2000+0x800*s);
		for (int i=64*8;i>0;i--) {
			Port98 = 0;
		}
		for (int i=0;i<64;i++) {
			char k = i/4;
			for (char j=0;j<8;j++) {
				Port98 = gradient_colrs[k];
			}
		}
	}
	
	memset(&buffer[0],0,24*32);
	memset(&buffer[23*32],127,32);
	
	while (myCheckkbd(7)==0xFF)	{
		FireIteration(buffer);
	}
	memset(&buffer[23*32],0,32);	
	
	for (char t = 20;t>0;t--)  {
		FireIteration(buffer);
	}
		

	RestorePalette();
}

void FireIteration(char *b) __sdcccall(1)
{
	char *v = &b[23*32];
	for (char j=23;j>0;j--) 
	{
		for (char i=32;i>0;i--)
		{
			char w = (MyRand()&15);
			if (*v>w) 
				*(v-32-2+(w&3)) = *v-w;
			else
				*(v-32-2+(w&3)) = 0;
			v++;
		}
		v += -64;
	}
	myFT_wait(1);
	SetVramW14(0x1800);
	VramWrite((unsigned int)&b[0],3*256);		
}


int g_RandomSeed8 = 5;

char MyRand(void) __naked  __preserves_regs(b,c,iyl,iyh)
{
__asm
	ld	hl, (_g_RandomSeed8)
	ld      a, r
	ld      d, a
	ld      e, a
	add     hl, de
	xor     l
	add     a
	xor     h
	ld      l, a
	ld	(_g_RandomSeed8), hl
	ret
__endasm;
}



void SetPalette(char *palette) __sdcccall(1)
{
	palette;
__asm
	ld	bc,#0x1000		; 16 colours
SPcoLoop:
	ld	a,c
	di
	out	(#0x99),a	; colour Nr.
	ld	a, #128+#16
	out	(#0x99),a       
	ld	a,(hl)		; red
	sla	a
	sla	a
	sla	a
	sla	a			; bits 4-7
	inc	hl
	inc	hl
	or	a,(hl)		; blue bits 0-3
	out	(#0x9A),a
	dec	hl
	ld	a,(hl)		; green bits 0-3
	inc	hl
	inc	hl
	ei 
	out	(#0x9A),a
	inc c
	djnz	SPcoLoop
	ret
__endasm;
}

// -----------------------------------------------
// 	Sets palette, provide table pointer
// 
void RestorePalette(void) __naked
{
__asm
	ld	hl, #__msx_palette
	jp	_SetPalette
	
;---------------------------------------------------
;        colour  R  G  B   bright 0..7   Name
;---------------------------------------------------
__msx_palette:
	.db #0,#0,#0		;transparent
	.db #0,#0,#0		;black
	.db #1,#6,#1		;bright green
	.db #3,#7,#3		;light green
	.db #1,#1,#7		;deep blue
	.db #2,#3,#7		;bright blue
	.db #5,#1,#1		;deep red
	.db #2,#6,#7		;light blue
	.db #7,#1,#1		;bright red
	.db #7,#3,#3		;light red
	.db #6,#6,#1		;bright yellow
	.db #6,#6,#3		;pale yellow
	.db #1,#4,#1		;deep green
	.db #6,#2,#5		;purple
	.db #5,#5,#5		;grey
	.db #7,#7,#7		;white
__endasm;
}	
	
	

const char fire_palette[] = {
     0x0,0x0,0x0,
     0x2,0x0,0x0,
     0x3,0x0,0x0,
     0x4,0x1,0x0,
     0x5,0x2,0x0,
     0x6,0x2,0x0,
     0x6,0x3,0x0,
     0x6,0x3,0x0,
     0x6,0x4,0x0,
     0x6,0x4,0x0,
     0x5,0x4,0x0,
     0x5,0x5,0x1,
     0x5,0x5,0x1,
     0x6,0x6,0x4,
     0x7,0x7,0x7
};

// ****************************************
// * Sprite Patterns                       
// ****************************************
const char title_sprites[] = {
   0x3F,0x7F,0x7F,0x7F,0x3F,0x03,0x03,0x03,    // Color 9
   0x03,0x03,0x03,0x03,0x03,0x03,0x03,0x03,    // 
   0xFF,0xFF,0xFF,0xFF,0xFF,0xE0,0xE0,0xE0,    // 
   0xE0,0xE0,0xE1,0xE1,0xE1,0xFF,0xFF,0xFF,    // 
   0xFF,0xFF,0xFF,0xFF,0xFF,0x00,0x00,0x00,    // Color 9
   0x00,0xE0,0xF0,0xF0,0xF0,0xF0,0xF0,0xF0,    // 
   0xF8,0xF8,0xF8,0xF8,0xF8,0xF8,0xF8,0xF8,    // 
   0xF8,0xF8,0xF8,0x70,0x00,0x00,0x00,0x00,    // 
   0x3F,0x7F,0x7F,0x7F,0x3F,0x00,0x00,0x00,    // Color 9
   0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,    // 
   0xFF,0xFF,0xFF,0xFF,0xFF,0x3E,0x3E,0x3E,    // 
   0x3E,0x3E,0x3E,0x3E,0x3E,0x3E,0x3E,0x3E,    // 
   0xFE,0xFF,0xFF,0xFF,0xFE,0x00,0x00,0x00,    // Color 9
   0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,    // 
   0x03,0x07,0x07,0x07,0x03,0x00,0x00,0x00,    // 
   0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,    // 
   0xFF,0xFF,0xFF,0xFF,0xFF,0x3E,0x3E,0x3E,    // Color 9
   0x3E,0x3E,0x3E,0x3E,0x3E,0x3F,0x3F,0x3F,    // 
   0xFF,0xFF,0xFF,0xFF,0xFF,0x00,0x00,0x00,    // 
   0x00,0x00,0x00,0x00,0x01,0xFF,0xFF,0xFF,    // 
   0x80,0xE0,0xF8,0xFC,0xFE,0xFE,0x3F,0x1F,    // Color 9
   0x1F,0x1F,0x3F,0x7E,0xFE,0xFC,0xF8,0xE0,    // 
   0x07,0x0F,0x0F,0x0F,0x07,0x00,0x00,0x00,    // 
   0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,    // 
   0xFF,0xFF,0xFF,0xFF,0xFF,0x7C,0x7C,0x7C,    // Color 9
   0x7C,0x7C,0x7C,0x7C,0x7F,0x7F,0x7F,0x7F,    // 
   0xFF,0xFF,0xFF,0xFF,0xFF,0x00,0x00,0x00,    // 
   0x1C,0x3E,0x3E,0x3E,0xFE,0xFE,0xFE,0xFE,    // 
   0xFE,0xFE,0xFE,0xFE,0xFE,0x3E,0x3E,0x3E,    // Color 9
   0x3E,0x3E,0x3E,0x1C,0x00,0x00,0x00,0x00,    // 
   0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,    // 
   0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,    // 
   0x03,0x03,0x03,0x03,0x03,0x03,0x03,0x03,    // Color 9
   0x03,0x3F,0x7F,0x7F,0x7F,0x3F,0x00,0x00,    // 
   0xFF,0xFF,0xE1,0xE1,0xE1,0xE0,0xE0,0xE0,    // 
   0xE0,0xFF,0xFF,0xFF,0xFF,0xFF,0x00,0x00,    // 
   0xF0,0xF0,0xF0,0xF0,0xF0,0xE0,0x00,0x00,    // Color 9
   0x00,0xE0,0xF0,0xF0,0xF0,0xE0,0x00,0x00,    // 
   0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,    // 
   0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,    // 
   0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,    // Color 9
   0x00,0x3F,0x7F,0x7F,0x7F,0x3F,0x00,0x00,    // 
   0x3E,0x3E,0x3E,0x3E,0x3E,0x3E,0x3E,0x3E,    // 
   0x3E,0xFF,0xFF,0xFF,0xFF,0xFF,0x00,0x00,    // 
   0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,    // Color 9
   0x00,0xFE,0xFF,0xFF,0xFF,0xFE,0x00,0x00,    // 
   0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,    // 
   0x00,0x03,0x07,0x07,0x07,0x03,0x00,0x00,    // 
   0x3F,0x3F,0x3E,0x3E,0x3E,0x3E,0x3E,0x3E,    // Color 9
   0x3E,0xFF,0xFF,0xFF,0xFF,0xFF,0x00,0x00,    // 
   0xFF,0xFF,0x07,0x03,0x01,0x00,0x00,0x00,    // 
   0x00,0xF0,0xF8,0xF8,0xF8,0xF0,0x00,0x00,    // 
   0x80,0xC0,0xE0,0xF0,0xF8,0xFC,0x7C,0x3E,    // Color 9
   0x3F,0x1F,0x0F,0x0F,0x07,0x03,0x00,0x00,    // 
   0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,    // 
   0x00,0xE7,0xFF,0xFF,0xFF,0xE7,0x00,0x00,    // 
   0x7F,0x7C,0x7C,0x7C,0x7C,0x7C,0x7C,0x7C,    // Color 9
   0x7C,0xFF,0xFF,0xFF,0xFF,0xFF,0x00,0x00,    // 
   0xFE,0x3E,0x3E,0x3E,0x1C,0x00,0x00,0x00,    // 
   0x00,0xFF,0xFF,0xFF,0xFF,0xFF,0x00,0x00,    // 
   0x00,0x00,0x0E,0x1F,0x1F,0x1F,0x1F,0x1F,    // Color 9
   0x1F,0xFF,0xFF,0xFF,0xFF,0xFF,0x00,0x00,    // 
   0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,    // 
   0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,    // 
   0x00,0x00,0x00,0x00,0x00,0x00,0x01,0x01,    // Color 9
   0x01,0x01,0x01,0x00,0x00,0x00,0x00,0x01,    // 
   0x07,0x1F,0x3F,0x7F,0xFF,0xF8,0xF0,0xF0,    // 
   0xF0,0xF8,0xF8,0xFC,0xFE,0x7E,0xFF,0xFF,    // 
   0xF0,0xFE,0xFF,0xFF,0xFE,0x7C,0x10,0x00,    // Color 9
   0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x87,    // 
   0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,    // 
   0x00,0x00,0x00,0x00,0x00,0x00,0x00,0xE0,    // 
   0x3F,0x7F,0x7F,0x7F,0x3F,0x00,0x00,0x00,    // Color 9
   0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,    // 
   0xFF,0xFF,0xFF,0xFF,0xFF,0x3E,0x3E,0x3E,    // 
   0x3E,0x3E,0x3E,0x3E,0x3E,0x3E,0x3E,0x3E,    // 
   0xFE,0xFF,0xFF,0xFF,0xFE,0x00,0x00,0x00,    // Color 9
   0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,    // 
   0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,    // 
   0x00,0x00,0x01,0x01,0x01,0x01,0x01,0x01,    // 
   0x00,0x03,0x07,0x1F,0x1F,0x3F,0x7F,0x7E,    // Color 9
   0xFC,0xF8,0xF8,0xF0,0xF0,0xF0,0xF0,0xF0,    // 
   0x7F,0xFF,0xFF,0xFF,0xFF,0xC0,0x00,0x00,    // 
   0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,    // 
   0x87,0xEF,0xFF,0xFF,0xFF,0xFF,0x3F,0x0F,    // Color 9
   0x0F,0x0F,0x07,0x00,0x00,0x00,0x00,0x00,    // 
   0x07,0x8F,0x8F,0x8F,0x87,0x80,0x80,0x80,    // 
   0x80,0x80,0x00,0x00,0x00,0x00,0x00,0x00,    // 
   0xFF,0xFF,0xFF,0xFF,0xFF,0x7C,0x7C,0x7C,    // Color 9
   0x7C,0x7C,0x7C,0x7C,0x7F,0x7F,0x7F,0x7F,    // 
   0xFF,0xFF,0xFF,0xFF,0xFF,0x00,0x00,0x00,    // 
   0x1C,0x3E,0x3E,0x3E,0xFE,0xFE,0xFE,0xFE,    // 
   0xFE,0xFE,0xFE,0xFE,0xFE,0x3E,0x3E,0x3E,    // Color 9
   0x3E,0x3E,0x3E,0x1C,0x00,0x00,0x00,0x00,    // 
   0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,    // 
   0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,    // 
   0x03,0x07,0x07,0x0F,0x0F,0x0F,0x0F,0x0F,    // Color 9
   0x0F,0x07,0x03,0x03,0x00,0x00,0x00,0x00,    // 
   0xFF,0xFF,0xE7,0xC3,0x81,0x81,0x80,0x80,    // 
   0xE0,0xFF,0xFF,0xFF,0xFF,0x3F,0x00,0x00,    // 
   0xC7,0xEF,0xEF,0xFF,0xFF,0xFF,0xFF,0x7F,    // Color 9
   0xFF,0xFF,0xFF,0xFF,0xF7,0xC0,0x00,0x00,    // 
   0xF0,0xF0,0xF0,0xE0,0x80,0x80,0x80,0x00,    // 
   0xE0,0xF0,0xF0,0xF0,0xE0,0x00,0x00,0x00,    // 
   0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,    // Color 9
   0x00,0x3F,0x7F,0x7F,0x7F,0x3F,0x00,0x00,    // 
   0x3E,0x3E,0x3E,0x3E,0x3E,0x3E,0x3E,0x3E,    // 
   0x3E,0xFF,0xFF,0xFF,0xFF,0xFF,0x00,0x00,    // 
   0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,    // Color 9
   0x00,0xFE,0xFF,0xFF,0xFF,0xFE,0x00,0x00,    // 
   0x01,0x01,0x01,0x01,0x01,0x00,0x00,0x00,    // 
   0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,    // 
   0xF0,0xF0,0xF0,0xF0,0xF8,0xF8,0xFC,0xFE,    // Color 9
   0x7F,0x3F,0x1F,0x0F,0x07,0x01,0x00,0x00,    // 
   0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,    // 
   0x00,0xC0,0xFF,0xFF,0xFF,0xFF,0x3F,0x00,    // 
   0x00,0x00,0x00,0x00,0x00,0x00,0x03,0x07,    // Color 9
   0x0F,0x3F,0xFF,0xFF,0xFE,0xF8,0xC0,0x00,    // 
   0x00,0x00,0x00,0x00,0x00,0x00,0x80,0xC0,    // 
   0xC0,0xC7,0x8F,0x0F,0x0F,0x07,0x00,0x00,    // 
   0x7F,0x7C,0x7C,0x7C,0x7C,0x7C,0x7C,0x7C,    // Color 9
   0x7C,0xFF,0xFF,0xFF,0xFF,0xFF,0x00,0x00,    // 
   0xFE,0x3E,0x3E,0x3E,0x1C,0x00,0x00,0x00,    // 
   0x00,0xFF,0xFF,0xFF,0xFF,0xFF,0x00,0x00,    // 
   0x00,0x00,0x0E,0x1F,0x1F,0x1F,0x1F,0x1F,    // Color 9
   0x1F,0xFF,0xFF,0xFF,0xFF,0xFF,0x00,0x00,    // 
   0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,    // 
   0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00    // 
};
const char title_sat[] = 
{
 255,0,0,9   , //y, x, pattern#, color#
 15,16,36,9  , 
 31,32,72,9  , 
 47,48,108,9 , 
 255,16,4,9  , 
 15,0,32,9   , 
 31,48,76,9  , 
 47,32,104,9 , 
 255,32,8,9  , 
 15,48,44,9  , 
 31,0,64,9   , 
 47,16,100,9 , 
 255,48,12,9 , 
 15,32,40,9  , 
 31,16,68,9  , 
 47,0,96,9   , 
 255,64,16,9 , 
 15,80,52,9  , 
 31,96,88,9  , 
 47,112,124,9, 
 255,80,20,9 , 
 15,64,48,9  , 
 31,112,92,9 , 
 47,96,120,9 , 
 255,96,24,9 , 
 15,112,60,9 , 
 31,64,80,9  , 
 47,80,116,9 , 
 255,112,28,9, 
 15,96,56,9  , 
 31,80,84,9  , 
 47,64,112,9  
};
// ****************************************

const char gradient_colrs[] = {
	0x10,0x21,0x32,0x43,0x54,0x65,0x76,0x87,
	0x98,0xA9,0xBA,0xCB,0xDC,0xED,0xFE,0xFF
	};

const char gradient_tiles[] = {
	0x00,0x00,0x00,0x88,0x00,0x00,0x00,0x88,
	0x00,0x22,0x00,0x88,0x00,0x22,0x00,0x88,    
	0x00,0x22,0x00,0xAA,0x00,0x22,0x00,0xAA,    
	0x00,0xAA,0x00,0xAA,0x00,0xAA,0x00,0xAA,    
	0x00,0xAA,0x44,0xAA,0x00,0xAA,0x44,0xAA,    
	0x11,0xAA,0x44,0xAA,0x11,0xAA,0x45,0xAA,    
	0x11,0xAA,0x55,0xAA,0x11,0xAA,0x55,0xAA,    
	0x55,0xAA,0x55,0xAA,0x55,0xAA,0x55,0xAA,    
	0x55,0xAA,0x55,0xEE,0x55,0xAA,0x55,0xEE,    
	0x55,0xBB,0x55,0xEE,0x55,0xBB,0x55,0xEE,    
	0x55,0xBB,0x55,0xFF,0x55,0xBB,0x55,0xFF,    
	0x55,0xFF,0x55,0xFF,0x55,0xFF,0x55,0xFF,    
	0x55,0xFF,0xDD,0xFF,0x55,0xFF,0xDD,0xFF,    
	0x77,0xFF,0xDD,0xFF,0x77,0xFF,0xDD,0xFF,    
	0x77,0xFF,0xFF,0xFF,0x77,0xFF,0xFF,0xFF,    
	0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF    
};

	