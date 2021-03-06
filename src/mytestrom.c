/*
 ___________________________________________________________
/				  			  								\
|				  Screen 8 side scroller					|
\___________________________________________________________/
*/
//
// Works on MSX2 and upper	
// Need external files 
//

#define __SDK_OPTIMIZATION__ 1 
// #define CPULOAD
// #define VDPLOAD
// #define WBORDER

#include <string.h>
#include <stdlib.h>
#include <stdio.h>

#include "myheader.h"

// static FCB file;							// Init the FCB Structure varaible
static FastVDP MyCommand;
static FastVDP MyBorder;

unsigned char page;							// VDP active page

  signed int  WLevelx;						// (X,Y) position in the level map 4096x192 of
unsigned char WLevely;						//  the 240x176 window screen 

unsigned int LevelW;						// size of the actual map in tile (initialised at level change
unsigned char LevelH;

  signed int WLevelDX;						// scrolling direction and speed F8.8 on X
  signed int WLevelDY;						// scrolling direction and speed F8.8 on Y

#define MaxLevelW 512U						// Max size of the map in tile
#define MaxLevelH 11U

#define WindowW 240U						// size of the screen in pixels
#define WindowH 176U

unsigned char newx,page;
unsigned char OldIsr[3];

unsigned char cursat;

/*
SAT0 = 0FA00h ; R5 = F7h;R11 = 01h
SAT1 = 1FA00h ; R5 = F7h;R11 = 03h

SPG = 0F000h ; R6 = 1Eh
*/

unsigned char  LevelMap[MaxLevelW*MaxLevelH];


void main(void) 
{
	unsigned char rd;

	audioinit();

	intro();
	
	rd = ReadMSXtype();					  	// Read MSX Type
	if (rd==0) FT_errorHandler(3,"msx 1 ");	// If MSX1 got to Error !
	
	MyLoadMap(0,LevelMap);					// load level map 256x11 arranged by columns
	
	chgmod(8);						  		// Init Screen 8

	audiosfxinit(0);						

	ObjectsInit();							// initialize logical object 

	myVDPwrite(0,7);						// borders	
	VDPlineSwitch();						// 192 lines
	VDP60Hz();

	myHMMV(0,0,256,512, 0);					// Clear all VRAM  by Byte 0 (Black)
	DisableInterrupt();
	myVDPready();							// wait for command completion
	EnableInterrupt();
	
	SprtInit();								// initialize sprites in VRAM 
	ObjectstoVRAM(0);	
	
	myInstISR();							// install a fake ISR to cut the overhead
	myVDPwrite((char)(WindowH-8),(char)19); 				// set Line Interrupt
	
	
	page = 0;
	mySetAdjust(0,8);						// same as myVDPwrite((0-8) & 15,18);	
	
	for (WLevelx = 0;WLevelx<0+WindowW;) {
		myFT_wait(1);		
		NewLine(WLevelx,0,WLevelx);WLevelx++;
		NewLine(WindowW-WLevelx,0,WindowW-WLevelx);	WLevelx++;
		NewLine(WLevelx,0,WLevelx);WLevelx++;
		NewLine(WindowW-WLevelx,0,WindowW-WLevelx);	WLevelx++;
	}

	WLevelx = 0;	

	MyBorder.ny = WindowH;
	MyBorder.col = 0;
	MyBorder.param = 0;
	MyBorder.cmd = opHMMV;
	
	MyCommand.ny = WindowH;
	MyCommand.col = 0;
	MyCommand.param = 0;
	MyCommand.cmd = opHMMM;
	
	
	while (myCheckkbd(7)==0xFF)
	{
		ChangeLevel();
		audioplay();
		
		WaitLineInt();			// wait for line 176-16
		cursat^=1;				// swap sat 0 and sat 1
				
		if ((myCheckkbd(8)==0x7F) && (WLevelx<16*(LevelW-15)))  { 
			WLevelx++;
			ObjectstoVRAM(WLevelx);			
			ScrollRight(WLevelx & 15);
		}
		else if ((myCheckkbd(8)==0xEF) && (WLevelx>0)) { 
			WLevelx--;
			ObjectstoVRAM(WLevelx);			
			ScrollLeft(WLevelx & 15);
		}
		else {
			ObjectstoVRAM(WLevelx);						
		}
	}

	chgmod(0);
	Reboot(0);
}

void ScrollRight(char step) __sdcccall(1) 
{
	// from left to right 
	myVDPwrite((step-8) & 15,18);			
	switch (step) {
		case 0: 
			page ^=1;							// case 0
			SetDisplayPage(page);
			MyBorder.dx = 240;
			MyBorder.nx = 15;
			MyBorder.dy = 256*page;
			myfVDP(&MyBorder);
			BorderLinesR((unsigned char)(WindowW-1),page, WLevelx+WindowW-1);		
		break;
		default:								// case 1-15
			MyCommand.sx = 16*step;
			MyCommand.dx = MyCommand.sx - 16;;
			MyCommand.sy = 256*page;
			MyCommand.dy = MyCommand.sy ^ 256;
			MyCommand.nx = 16;
			myfVDP(&MyCommand);		
			BorderLinesR(step+WindowW-1,page,WLevelx+WindowW-1);
		break;
	}
	if (step==15) PatchPlotOneTile(step+WindowW-1-16,page^1,WLevelx+WindowW-1);		
}

void ScrollLeft(char step) __sdcccall(1)
{
	// from right to left
	myVDPwrite((step-8) & 15,18);	
	switch (step) {
		case 15: 
			page ^=1;					
			SetDisplayPage(page);				// case 15
			MyBorder.dx = 0;	
			MyBorder.nx = 15;
			MyBorder.dy = 256*page;
			myfVDP(&MyBorder);
			BorderLinesL(step,page,WLevelx);		
		break;				
		default:								// case 14-0
			MyCommand.sx = 16*step;
			MyCommand.dx = MyCommand.sx + 16;
			MyCommand.sy = 256*page;
			MyCommand.dy = MyCommand.sy ^ 256;		
			MyCommand.nx = 16;						
			myfVDP(&MyCommand);					
			BorderLinesL(step,page,WLevelx);			
		break;		
	}
	if (step==0) PatchPlotOneTile(16,page^1,WLevelx);				
}


static unsigned char *p;


void PlotOneColumnTile(void) __sdcccall(1) 
{
__asm 
	exx
	ld a,(_MemPageOffset)
	ld b,a
	ld	hl,(_p)
	ld	a,(hl)
	rlca	
	rlca
	and a,#3
	add a,a
	add a,b				; memory page offset
	ld (#0x9000),a
    inc a
	ld (#0xb000),a
	// out (#0xfe),a		; set segment in 4..7
	ld	a,(hl)
	inc	hl
	ld	(_p),hl			; save next tile
	and a,#0x3F			; tile number
	add	a,#0x80			; address of the segment
	ld	h,a				; address of the tile in the segment
	ld	l,d
	exx 

	.rept #16
	out (c),e			; set vram address in 14 bits
	out (c),d
	inc d				; new line
	exx 
	outi				; write data
	exx
	.endm
__endasm;
}

void PlotOneColumnTileAndMask(void) __sdcccall(1) 
{
__asm 
	exx
	ld a,(_MemPageOffset)
	ld b,a
	ld	hl,(_p)
	ld	a,(hl)
	rlca	
	rlca
	and a,#3
	add a,a	
	add a,b				; memory page offset
	ld (#0x9000),a
    inc a
	ld (#0xb000),a
	// out (#0xfe),a		; set segment in 4..7
	ld	a,(hl)
	inc	hl
	ld	(_p),hl			; save next tile
	and a,#0x3F			; tile number
	add	a,#0x80			; address of the segment
	ld	h,a				; address of the tile in the segment
	ld	l,d
	exx 
	
	.rept #16
	out (c),e			; set vram address in 14 bits
	out (c),d
	exx 
	outi				; write data
	exx
	out (c),l			; set vram address in 14 bits for border
	out (c),d
	inc d				; new line
	xor a,a				; write border
	out (#0x98),a
	.endm
__endasm;
}

void BorderLinesL(unsigned char ScrnX,char page, int MapX) __sdcccall(1) __naked
{
	ScrnX;
	page;
	MapX;
__asm

	pop bc				; get ret address
	pop de				; de = MapX
	push bc 			; save ret address

	ex af,af'			; a' = ScrnX
	ld a,l				; l = page
	add a,a
	add a,a
	ld (_RG14SA),a

	ld	c,e				; C = low(mapx)
	
	sra	d				; DE/16
	rr	e
	sra	d
	rr	e
	sra	d
	rr	e
	sra	d
	rr	e
	ld	l,e
	ld	h,d
	add	hl,hl
	add	hl,hl
	add	hl,de	
	add	hl,hl
	add	hl,de				; DE/16 * 11
	
	ld 	de,#_LevelMap
	add	hl,de
	ld	(_p), hl
	
#ifdef	CPULOAD	
		ld	a,#0xC0				; color test
		out	(#0x99), a
		ld	a,#0x87
		out	(#0x99), a			
#endif
	
	ex af,af'				; a' = ScrnX	
	ld	e,a 				; DE vramm address for new border data
	add	a,#240 				; L = E +/- 240U according to the scroll direction
	ld	l,a 				; DL hold vramm address for blank border
	
	ld	a,c					; C = low(MapX)
	and	a,#15
	add	a,a
	add	a,a
	add	a,a
	add	a,a
	exx
	ld	d,a 				; common offeset of the address in the tile
	ld	c,#0x98 			; used by _PlotOneColumnTileAndMask
	exx
	di
	ld	a,(_RG14SA) 		; set address in vdp(14)
	out	(#0x99), a
	inc	a
	ld	(_RG14SA),a 		; save next block
	ld	a,#0x8E
	out	(#0x99), a
	ld	c,#0x99
	ld	d,#0x40
	call	_PlotOneColumnTileAndMask	; plot 4 tiles
	call	_PlotOneColumnTileAndMask
	call	_PlotOneColumnTileAndMask
	call	_PlotOneColumnTileAndMask
	ld	a,(_RG14SA) 		; set address in vdp(14)
	out	(#0x99), a
	inc	a
	ld	(_RG14SA),a 		; save next block
	ld	a,#0x8E
	out	(#0x99), a
	ld	d,#0x40
	call	_PlotOneColumnTileAndMask	; plot 4 tiles
	call	_PlotOneColumnTileAndMask
	call	_PlotOneColumnTileAndMask
	call	_PlotOneColumnTileAndMask
	ld	a,(_RG14SA) 		; set address in vdp(14)
	out	(#0x99), a
	ld	a,#0x8E
	out	(#0x99), a
	ld	d,#0x40
	call	_PlotOneColumnTileAndMask	; plot 3 tiles
	call	_PlotOneColumnTileAndMask
	call	_PlotOneColumnTileAndMask
	// ld	a,#1
	// out	(#0xfe),a 			; restore page 1
	
#ifdef	CPULOAD	
		xor a,a				; color test
		out	(#0x99), a
		ld	a,#0x87
		out	(#0x99), a			
#endif
	ei
	ret
__endasm;
}

void BorderLinesR(unsigned char ScrnX,char page, int MapX) __sdcccall(1) __naked
{
	ScrnX;
	page;
	MapX;
__asm

	pop bc				; get ret address
	pop de				; DE = MapX+WindowW
	push bc 			; save ret address

	ex af,af'			; a' = ScrnX
	ld a,l				; l = page
	add a,a
	add a,a
	ld (_RG14SA),a

	ld	c,e				; C = low(mapx)
	
	sra	d				; DE/16
	rr	e
	sra	d
	rr	e
	sra	d
	rr	e
	sra	d
	rr	e
	ld	l,e
	ld	h,d
	add	hl,hl
	add	hl,hl
	add	hl,de	
	add	hl,hl
	add	hl,de				; DE/16 * 11
	
	ld 	de,#_LevelMap
	add	hl,de
	ld	(_p), hl
	
#ifdef	CPULOAD	
		ld	a,#0xC0				; color test
		out	(#0x99), a
		ld	a,#0x87
		out	(#0x99), a			
#endif
	
	ex af,af'				; a' = ScrnX	
	ld	e,a 				; DE vramm address for new border data
	sub	a,#240 				; L = E +/- 240U according to the scroll direction
	ld	l,a 				; DL hold vramm address for blank border
	
	ld	a,c					; C = low(MapX)
	and	a,#15
	add	a,a
	add	a,a
	add	a,a
	add	a,a
	exx
	ld	d,a 				; common offeset of the address in the tile
	ld	c,#0x98 			; used by _PlotOneColumnTileAndMask
	exx
	di
	ld	a,(_RG14SA) 		; set address in vdp(14)
	out	(#0x99), a
	inc	a
	ld	(_RG14SA),a 		; save next block
	ld	a,#0x8E
	out	(#0x99), a
	ld	c,#0x99
	ld	d,#0x40
	call	_PlotOneColumnTileAndMask	; plot 4 tiles
	call	_PlotOneColumnTileAndMask	
	call	_PlotOneColumnTileAndMask	
	call	_PlotOneColumnTileAndMask	
	ld	a,(_RG14SA) 		; set address in vdp(14)
	out	(#0x99), a
	inc	a
	ld	(_RG14SA),a 		; save next block
	ld	a,#0x8E
	out	(#0x99), a
	ld	d,#0x40
	call	_PlotOneColumnTileAndMask	; plot 4 tiles
	call	_PlotOneColumnTileAndMask	
	call	_PlotOneColumnTileAndMask	
	call	_PlotOneColumnTileAndMask	
	ld	a,(_RG14SA) 		; set address in vdp(14)
	out	(#0x99), a
	ld	a,#0x8E
	out	(#0x99), a
	ld	d,#0x40
	call	_PlotOneColumnTileAndMask	; plot 3 tiles
	call	_PlotOneColumnTileAndMask	
	call	_PlotOneColumnTileAndMask	
	// ld	a,#1
	// out	(#0xfe),a 			; restore page 1
	
#ifdef	CPULOAD	
		xor a,a				; color test
		out	(#0x99), a
		ld	a,#0x87
		out	(#0x99), a			
#endif
	ei
	ret
__endasm;
}

void NewLine(unsigned char ScrnX,char page, int MapX) __sdcccall(1) __naked
{
	ScrnX;
	page;
	MapX;

__asm
	pop bc				; get ret address
	pop de				; de = MapX
	push bc 			; save ret address

	ex af,af'			; a' = ScrnX
	ld a,l				; l = page
	add a,a
	add a,a
	ld (_RG14SA),a

	ld	c,e				; C = low(mapx)

	sra	d				; DE/16
	rr	e
	sra	d
	rr	e
	sra	d
	rr	e
	sra	d
	rr	e
	ld	l,e
	ld	h,d
	add	hl,hl
	add	hl,hl
	add	hl,de	
	add	hl,hl
	add	hl,de				; DE/16 * 11

	ld 	de,#_LevelMap
	add	hl,de
	ld	(_p), hl
	
#ifdef	CPULOAD	
		ld	a,#0xC0				; color test
		out	(#0x99), a
		ld	a,#0x87
		out	(#0x99), a			
#endif
	ex af,af'			; a' = ScrnX	
	ld	e,a				; DE vramm address for new border data 
	
	ld	a,c				; C = low(MapX)
	and a,#15
	add a,a
	add a,a
	add a,a
	add a,a
	exx
	ld	d,a				; common offeset of the address in the tile 
	ld	c,#0x98			; used by _PlotOneColumnTile
	exx
	
	di

	ld	a,(_RG14SA)	; set address in vdp(14)
	out	(#0x99), a
	inc	a
	ld	(_RG14SA),a	; save next block
	ld	a,#0x8E
	out	(#0x99), a			

	ld 	c,#0x99
	ld	d,#0x40
	call _PlotOneColumnTile		; 4 tiles
	call _PlotOneColumnTile
	call _PlotOneColumnTile
	call _PlotOneColumnTile

	ld	a,(_RG14SA)	; set address in vdp(14)
	out	(#0x99), a
	inc	a
	ld	(_RG14SA),a	; save next block
	ld	a,#0x8E
	out	(#0x99), a			

	ld	d,#0x40
	call _PlotOneColumnTile		; 4 tiles
	call _PlotOneColumnTile
	call _PlotOneColumnTile
	call _PlotOneColumnTile

	ld	a,(_RG14SA)	; set address in vdp(14)
	out	(#0x99), a
	ld	a,#0x8E
	out	(#0x99), a			

	ld	d,#0x40
	call _PlotOneColumnTile		; 3 tiles
	call _PlotOneColumnTile		
	call _PlotOneColumnTile		
	
	// ld a,#1
	// out (#0xfe),a		; restore page 1
	
#ifdef	CPULOAD	
		xor a,a				; color test
		out	(#0x99), a
		ld	a,#0x87
		out	(#0x99), a			
#endif
	ei
	ret
__endasm;
}

void PatchPlotOneTile(unsigned char ScrnX,char page, int MapX) __sdcccall(1) __naked
{
	ScrnX;
	page;
	MapX;

__asm
	pop bc				; get ret address
	pop de				; DE = MapX
	push bc 			; save ret address

	ex af,af'			; a' = ScrnX
	ld a,l				; l = page
	add a,a
	add a,a
	ld (_RG14SA),a

	ld	c,e				; C = low(mapx)

	sra	d				; DE/16
	rr	e
	sra	d
	rr	e
	sra	d
	rr	e
	sra	d
	rr	e
	ld	l,e
	ld	h,d
	add	hl,hl
	add	hl,hl
	add	hl,de	
	add	hl,hl
	add	hl,de				; DE/16 * 11

	ld 	de,#_LevelMap
	add	hl,de
	ld	(_p), hl

	ex af,af'				; a' = ScrnX	
	ld	e,a 				; DE vramm address for new border data

	ld	a,c					; C = low(MapX)
	and	a,#15
	add	a,a
	add	a,a
	add	a,a
	add	a,a

	exx
	ld	d,a 				; common offeset of the address in the tile
	ld	c,#0x98 			; used by _PlotOneColumnTile
	exx
	
	di
#ifdef	CPULOAD	
		ld	a,#0xC0				; color test
		out	(#0x99), a
		ld	a,#0x87
		out	(#0x99), a			
#endif

	ld	a,(_RG14SA)	; set address in vdp(14)
	out	(#0x99), a
	ld	a,#0x8E
	out	(#0x99), a			

	ld	d,#0x40
	ld 	c,#0x99
	
	call _PlotOneColumnTile		; 1 tile
	
	// ld a,#1
	// out (#0xfe),a		; restore page 1
		
#ifdef	CPULOAD	
		xor a,a				; color test
		out	(#0x99), a
		ld	a,#0x87
		out	(#0x99), a			
#endif
	ei
	ret
__endasm;
}

void 	myVDPwrite(char data, char vdpreg) __sdcccall(1) __naked
{
	vdpreg;
	data;
__asm	
	di
	out (#0x99),a
	ld  a,#128
	or 	a,l
	out (#0x99),a            ;R#A := L
	ei 
	ret
__endasm;

}	


void  	myfVDP(void *Address)  __sdcccall(1)  __naked
{
	Address;
__asm
	di
	ld  a,#32                ; Start with Reg 32
	out (#0x99),a
	ld  a,#128+#17
	out (#0x99),a            ;R#17 := 32

	ld  c,#0x9b           	 ; c=#0x9b

fvdpWait:
	ld  a,#2
	out (#0x99),a           
	ld  a,#128+#15
	out (#0x99),a
	in  a,(#0x99)
	rrca
	jp  c, fvdpWait        ; wait CE
		
.rept #15		
	OUTI    
.endm

	xor  a,a           ; set Status Register #0 for reading
	out (#0x99),a
	ld  a,#0x8f
	out (#0x99),a

	ei
	ret
 __endasm;
}

/*
char	myPoint( unsigned int X,  unsigned int Y ) __sdcccall(1) __naked
{
	X,Y;
__asm
		; hl = m
		; de = n
		
		di
		  
		ld    a,#32
		out   (#0x99),a
		ld    a,#128+#17
		out   (#0x99),a    ;R#17 := 32

		ld   c,#0x9b

		out	(c),l    ; R32 DX low byte
		out	(c),h    ; R33 DX high byte
		out	(c),e    ; R34 DY low byte
		out (c),d    ; R35 DY high byte
		  
		ld  a,#0b01000000		; Point command
		out (#0x99),a
		ld  a,#128+#46
		out (#0x99),a

		ld  a,#7     		; set Status Register #7 for reading
		out (#0x99),a
		ld  a,#0x8f
		out (#0x99),a

		in  a,(#0x99)
		ld l,a

		xor a				; set Status Register #0 for reading
		out (#0x99),a
		ld  a,#0x8f
		out (#0x99),a
		ei
		ld	a,l

		ret
__endasm;
}
*/	
/* --------------------------------------------------------- */
/* SETADJUST   Adjust screen offset                          */
/* --------------------------------------------------------- */

void mySetAdjust(signed char x, signed char y) __sdcccall(1)
{
	unsigned char value = ((x-8) & 15) | (((y-8) & 15)<<4);
	RG18SA = value;			// Reg18 Save
	myVDPwrite(value,18);
}

/* ---------------------------------
				FT_Wait
				Waiting 
-----------------------------------*/ 

void myFT_wait(unsigned char cicles) __sdcccall(1) __naked {
	cicles;
__asm
#ifdef	VDPLOAD
	push af
	ld		l,#7
	ld		a,#12
	call	_myVDPwrite		
	di
	call	_myVDPready
	ei
	ld		l,#7
	xor 	a,a
	call	_myVDPwrite		
	pop af
#endif

	or	a, a
00004$:
	ret	Z
	halt
	dec	a
	jp	00004$
__endasm;
}

void WaitLineInt(void) __sdcccall(1) __naked {
__asm
#ifdef	VDPLOAD
	ld		l,#7
	ld		a,#12
	call	_myVDPwrite		
	di
	call	_myVDPready
	ei
	ld		l,#7
	xor 	a,a
	call	_myVDPwrite		
#endif
	di
	ld  a,#1           ; set Status Register #1 for reading
	out (#0x99),a
	ld  a,#0x8f
	out (#0x99),a

WaitLI:
	in  a,(#0x99)	
	rrca
	jr	nc,WaitLI

	xor  a,a           ; set Status Register #0 for reading
	out (#0x99),a
	ld  a,#0x8f
	out (#0x99),a
	ei
	ret
__endasm;
}


/* ---------------------------------
			FT_errorHandler

		  In case of Error
-----------------------------------*/ 
void FT_errorHandler(char n, char *name) __sdcccall(1) 
{
	name;
	// SetColors(15,6,6);
	// FORCLR   =   0xF3E9       ; foreground color 
	// BAKCLR   =   0xF3EA       ; background color
	// BDRCLR   =   0xF3EB       ; border color

	chgmod(0);
	
	switch (n)
	{
	  case 3:
		  Print("\n\rStop Kidding, run me on MSX2 !");
	  break;
	  
	  default:
			Print("\n\rUnkon error. Sorry !");
	  break; 
	}
	Reboot(0);
}

void ChangeLevel(void) 
{
	unsigned char k = myCheckkbd(0);
	
	if (k == 0xFF) 
		return;
	else if (k == 0xFE)	{
		k = 0;
	}
	else if (k == 0xFD)	{
		k = 1;
	}
	else if (k == 0xFB)	{
		k = 2;
	}
	else if (k == 0xF7) {
		k = 3;
	}
	else if (k == 0xEF) {
		k = 4;
	}
	else if (k == 0xDF) {
		k = 5;
	} 
	else {
		k=0;
	}
	
	audioinit();
	
	MyLoadMap(k,LevelMap);
	audiosfxinit(k);
		
	myVDPwrite((0-8) & 15,18);	

	MyBorder.dx = 240;
	MyBorder.nx = 15;
	MyBorder.dy = 256*page;
	myfVDP(&MyBorder);
	
	for (WLevelx = 0;WLevelx<0+WindowW;) {
		myFT_wait(1);		
		NewLine(WLevelx,page,WLevelx);WLevelx++;
		NewLine(WindowW-WLevelx,page,WindowW-WLevelx);	WLevelx++;
		NewLine(WLevelx,page,WLevelx);WLevelx++;
		NewLine(WindowW-WLevelx,page,WindowW-WLevelx);	WLevelx++;
	}

	WLevelx = 0;	

	ObjectstoVRAM(0);
	
}

char MemPageOffset;


void MyLoadMap(char MapNum,unsigned char* p ) __sdcccall(1) __naked
{
	MapNum;
	p;
	__asm
	; A MapNum
	; DE destination
	
	ld hl,#_BankLevelMap
	add a,a
	ld c,a
	ld b,#0
	add hl,bc
		
	ld	a,(hl)
	ld (#0x9000),a
	ld (#_curr_bank),a
    inc a
	ld (#0xb000),a
	
	inc hl
	ld  a,(hl)
	ld (_MemPageOffset),a	

	ld bc,#_LevelWidth-#_BankLevelMap-#1
	add hl,bc
	ld c,(hl)
	inc hl 
	ld b,(hl)
	ld (#_LevelW),bc

	ld bc,#_LevelHeight-#_LevelWidth-#1
	add hl,bc
	ld a,(hl)
	ld (#_LevelH),a

	ld bc,#_DataLevelMap-#_LevelHeight
	add hl,bc
	ld c,(hl)
	inc hl 
	ld b,(hl)
	
	push de		; dest
	push bc		; source
	
	ld de,(#_LevelH)
	ld d,#0
	ld hl,(#_LevelW)
	call	__mulint
	ld c,e		; size
	ld b,d
	
	pop 	hl	; source
	pop 	de	; dest 
	
	ldir
	ret 


	.include "data\levels\L0metadatamap.asm"	
	.include "data\levels\L1metadatamap.asm"	
	.include "data\levels\L2metadatamap.asm"	
	.include "data\levels\L3metadatamap.asm"	
	.include "data\levels\L4metadatamap.asm"	
	.include "data\levels\L5metadatamap.asm"
	
_BankLevelMap:
	.db #b_L0DataLevelMap,#b_L0data0
	.db #b_L1DataLevelMap,#b_L1data0
	.db #b_L2DataLevelMap,#b_L2data0
	.db #b_L3DataLevelMap,#b_L3data0
	.db #b_L4DataLevelMap,#b_L4data0
	.db #b_L5DataLevelMap,#b_L5data0

_LevelWidth:
	.dw #L0width
	.dw #L1width
	.dw #L2width
	.dw #L3width
	.dw #L4width
	.dw #L5width
	
_LevelHeight:
	.dw #L0height
	.dw #L1height	
	.dw #L2height	
	.dw #L3height	
	.dw #L4height	
	.dw #L5height	
	
_DataLevelMap:
	.dw _L0DataLevelMap
	.dw _L1DataLevelMap
	.dw _L2DataLevelMap
	.dw _L3DataLevelMap
	.dw _L4DataLevelMap
	.dw _L5DataLevelMap	

	__endasm;
}

void myISR(void) __sdcccall(1) __naked
{						
__asm 

#ifdef WBORDER	
	ld	a,#0x03			// blue
	out	(#0x99),a
	ld	a,#128+#7
	out	(#0x99),a 
#endif

	ld a,(#_cursat)
	and a,a
	ld a,#3				// SAT1 = 1FA00h;
	jr	nz,setsat1
	ld a,#1				// set sat0 // SAT0 = 0FA00h;
setsat1:	
	out	(#0x99),a
	ld	a,#128+#11
	out	(#0x99),a 

		
#ifdef WBORDER	
	xor	a,a
	out	(#0x99),a
	ld	a,#128+#7
	out	(#0x99),a 
#endif

	ret
__endasm;
}

void myInstISR(void) __sdcccall(1) __naked
{
	
__asm 
	di
	ld	a,#0xC3
	ld  (#0xFD9A+#0),a
	ld	hl,#_myISR
	ld  (#0xFD9A+#1),hl
	ei
	ret
__endasm;
}


	

unsigned char myCheckkbd(unsigned char nrow) __sdcccall(1) __naked
{
	nrow;
__asm 
; // Line Bit_7 Bit_6 Bit_5 Bit_4 Bit_3 Bit_2 Bit_1 Bit_0
; // 0 "7" "6" "5" "4" "3" "2" "1" "0"
; // 1 ";" "]" "[" "\" "=" "-" "9" "8"
; // 2 "B" "A" ??? "/" "." "," "'" "`"
; // 3 "J" "I" "H" "G" "F" "E" "D" "C"
; // 4 "R" "Q" "P" "O" "N" "M" "L" "K"
; // 5 "Z" "Y" "X" "W" "V" "U" "T" "S"
; // 6 F3 F2 F1 CODE CAP GRAPH CTRL SHIFT
; // 7 RET SEL BS STOP TAB ESC F5 F4
; // 8 RIGHT DOWN UP LEFT DEL INS HOME SPACE

; checkkbd:
		ld	e,a
		di
		in	a,(#0xaa)
		and a,#0b11110000			; upper 4 bits contain info to preserve
		or	a,e
		out (#0xaa),a
		in	a,(#0xa9)
		ld	l,a
		ei
		ret
__endasm;
}

struct SpriteObject {
	signed int x;
	signed int y;
	unsigned char type;
	unsigned char frame;
	unsigned char status;
} object[MaxObjNum];


void ObjectsInit(void) {
	unsigned char t;
	for (t=0;t<MaxObjNum;t++)
	{
		object[t].x = t*LevelW*4/MaxObjNum + WindowW/2;
		object[t].y = (t & 1) ? 128 : 80;
		object[t].frame = t;
		object[t].status = 255;		// 0 is for inactive
	}
}


int  u;
unsigned char y;
unsigned char x;
unsigned char v;

void ObjectstoVRAM(int MapX) __sdcccall(1)
{
	char t;
	struct SpriteObject *q;

#ifdef CPULOAD
	myVDPwrite(0x91,7);
#endif

	if (cursat==0) {
		SetVramW(0,0xFA00);	// sat 0
		q = &object[MaxObjNum-1];
	}
	else {
		SetVramW(1,0xFA00);	// sat 1		
		q = &object[0];		
	}

	
	for (t=0; t<MaxObjNum; t++) 
	{
		// u = q->x-MapX+(MapX & 15);
		u = q->x-(((unsigned int) MapX) & 0xFFF0);
		y = q->y;
		x = u;
		v = q->frame<<4;
		
		if (q->status && (q->x - MapX >= 0) && (q->x - MapX < WindowW-16)) 
		{
			__asm
			ld c,#0x98
			.rept 2
			ld hl,#_y
			outi
			outi
			outi
			ld	a, (_v)
			out (#0x98),a
			add	a, #4
			ld	(_v),a
			.endm
			
			ld hl,#_y
			ld a,#16
			add a,(hl)
			ld (hl),a
			outi
			outi
			outi
			ld	a,(_v)
			out (#0x98),a
			add	a, #4
			ld	(_v),a
			ld hl,#_y
			outi
			outi
			outi
			nop
			out (#0x98),a
			__endasm;
		}     
		else { 
			__asm
			ld a,#217
			.rept 16
			out (#0x98),a
			nop
			.endm
			__endasm;
		}
		if (cursat==0) {
			q--;
		}
		else {
			q++;
		}
	}
#ifdef CPULOAD
	myVDPwrite(0,7);
#endif
}



void UpdateColor(char plane,char frame,char nsat) __sdcccall(1){

	if (nsat)
		SetVramW(1,0xF800+plane*16);
	else
		SetVramW(0,0xF800+plane*16);
		
	VramWrite(((unsigned int) &sprite_colors) + frame*64,64);
}

void UpdateFrame(char plane,char frame,char nsat) __sdcccall(1){

	if (nsat)
		SetVramW(0,0xF000+plane*32);
	else
		SetVramW(0,0xF000+32*32+plane*32);
		
	VramWrite(((unsigned int) &sprite_patterns) + frame*128,128);
}
/* 
void SatUpdate(int MapX) __sdcccall(1)
{
	MapX;
__asm
	ld	c,l
__endasm;	

#ifdef CPULOAD
	myVDPwrite(255,7);
#endif

__asm
	ld  a,(#_cursat)
	and a
	ld  a,#1
	ld	de,#0x0FA00 
	ld 	hl,#_sprite_sat1
	jp nz,setsat1			 	// scegli quella attiva che cambia ad ogni frame
	ld  a,#0
	ld	de,#0x0FA00 
	ld 	hl,#_sprite_sat0
setsat1:	
	call _SetVramW				// hl is unchanged
	ld	a,#15
	and a,c
	ld  e,a
	ld  c,#0x98
		
	.rept 32
	outi
	ld a,e
	add a,(hl)
	out (0x98),a
	inc hl
	outi
	outi
	.endm

__endasm;	
#ifdef CPULOAD
	myVDPwrite(0,7);
#endif
}

void SwapSat(void) 
{
	if (cursat) 
		myVDPwrite(3,11);		// SAT1 = 1FA00h;
	else
		myVDPwrite(1,11);		// SAT0 = 0FA00h;
}
*/

void SprtInit(void) __sdcccall(1) 
{
	char t;
	
	RG1SAV |= 2;
	myVDPwrite(RG1SAV,1);
	RG8SAV |= 32;
	myVDPwrite(RG8SAV,8);
	
		
	// access paged data 
	__asm
	ld	a,#b_sprite_colors
	ld (#0x9000),a
	ld (#_curr_bank),a
    inc a
	ld (#0xb000),a
	__endasm;

	
	SetVramW(0,0xF800);					// sat 0
	for (t=0; t<MaxObjNum; t++) {
		VramWrite(((unsigned int) &sprite_colors) + (MaxObjNum-1-t)*64,64);
	}

	SetVramW(1,0xF800);					// sat 1
	for (t=0; t<MaxObjNum; t++) {
		VramWrite(((unsigned int) &sprite_colors) + t*64,64);
	}

	// access paged data 
	__asm
	ld	a,#b_sprite_patterns
	ld (#0x9000),a
	ld (#_curr_bank),a
    inc a
	ld (#0xb000),a
	__endasm;

	SetVramW(0,0xF000);					// sprite patterns	
	for (t=0; t<MaxObjNum; t++) {	
		VramWrite(((unsigned int) &sprite_patterns) + t*128,128);
	}
}

void VramWrite(unsigned int addr, unsigned int len) __sdcccall(1) __naked
{
	addr;
	len;
__asm
	ld  c,#0x98
095$:
	outi
	dec de
	ld a,d
	or a,e
	jr nz,095$
	ret
__endasm;		
}

void SetVramR14( unsigned int addr) __sdcccall(1) __naked __preserves_regs(b,c,d,e,h,l,iyl,iyh) 
{
	addr;
__asm
    ld a,l
    di
    out (#0x99),a
    ld a,h
    ei
    out (#0x99),a
    ret
__endasm;		
}
void SetVramW14( unsigned int addr) __sdcccall(1) __naked __preserves_regs(b,c,d,e,h,l,iyl,iyh) 
{
	addr;
__asm
    ld a,l
    di
    out (#0x99),a
    ld a,h
    or a,#0x40
    ei
    out (#0x99),a
    ret
__endasm;		
}
void SetVramW(char page, unsigned int addr) __sdcccall(1) __naked __preserves_regs(b,c,h,l,iyl,iyh) 
{
	page;
	addr;
__asm
					; Set VDP address counter to write from address ADE (17-bit)
					; Enables the interrupts
    rlc d
    rla
    rlc d
    rla
    srl d
    srl d
    di
    out (#0x99),a
    ld a,#0x8E
    out (#0x99),a
    ld a,e
    out (#0x99),a
    ld a,d
    or a,#0x40
    ei
    out (#0x99),a
    ret
__endasm;		
}


void SetVramR(char page, unsigned int addr) __sdcccall(1) __naked __preserves_regs(b,c,h,l,iyl,iyh) 
{
	page;
	addr;
__asm
					; Set VDP address counter to write from address ADE (17-bit)
					; Enables the interrupts
	rlc	d
	rla
	rlc	d
	rla
	srl	d
	srl	d
	di
	out	(#0x99),a
	ld	a,#0x8E
	out	(#0x99),a
	ld	a,e
	out	(#0x99),a
	ld	a,d 		; set for reading
	ei
	out	(#0x99),a
    ret
__endasm;		
}

void chgmod(char c) __sdcccall(1) __naked {
	c;
    __asm
    jp 0x005f
    __endasm;
}

void putch(char c) __sdcccall(1) __naked {
	c;
    __asm
    jp 0x00a2
    __endasm;
}


void	myHMMV( unsigned int DX, unsigned int DY, unsigned int NX, unsigned int NY, char COL) __sdcccall(0) __naked
{
	DX,DY,NX,NY,COL;
__asm


;****************************************************************
; HMMV painting the rectangle in high speed          Eric
; void  HMMV( unsigned int XS, unsigned int YS, unsigned int DX, unsigned int DY, char COL);
; 
;****************************************************************

  push ix
  ld ix,#0
  add ix,sp

  di
  call    _myVDPready
  ld    a,#36
  out    (#0x99),a
  ld    a,#128+#17
  out    (#0x99),a    ;R#17 := 36

  ld    c,#0x9b
  ld  a,4(ix)  ;
  out    (c),a    ; R36 DX low byte

  ld  a,5(ix)  ;
  out    (c),a    ; R37 DX high byte

  ld  a,6(ix)  ;
  out    (c),a    ; R38 DY low byte

  ld  a,7(ix)  ;
  out    (c),a    ; R39 DY high byte

  ld  a,8(ix)  ;
  out (c),a     ; R40 NX low byte

  ld  a,9(ix)  ;
  out    (c),a    ; R41 NX high byte

  ld  a,10(ix) ;
  out    (c),a    ; R42 NY low byte

  ld  a,11(ix) ;
  out    (c),a    ; R43 NY high byte

  ld  a,12(ix) ;

  out    (c),a     ; R44 COL low byte

  xor a        ;

  out    (c),a     ; R45 DIX and DIY ! DX and DY express in incremental direction ! internal VRAM

  or    #0b11000000   ;HMMV command

  out    (c),a    ;do it
  ei
  pop    ix
  ret

__endasm;
}


void SetDisplayPage(char n) __z88dk_fastcall
{
	n;
__asm

;----------------------------
;   void SetDisplayPage(char n)
;   MSX2 Show the specified VRAM Page at Screen
;
	
    ld  a,l
	rla
	rla
	rla
	rla
	rla
	and #0x7F
	or #0x1F
	ld b,a 
	ld a,#2
	or #0x80
	ld		c, #0x99		;;	VDP port #1 (unsupport "MSX1 adapter")
	di
	out		(c), b			;;	out data
	out		(c), a			;;	out VDP register number
	ei
	ld (#0xFAF5),a			;; DPPAGE
__endasm;
}




void VDPlineSwitch(void) 
{
__asm
	ld a,(#_RG9SAV)
 	xor a,#0b10000000
 	ld (#_RG9SAV),a
 	ld b,a
	ld a,#0x89
 	ld		c, #0x99		;;	VDP port #1 (unsupport "MSX1 adapter")
	out		(c), b			;;	out data
	out		(c), a			;;	out VDP register number
__endasm;
}

void VDP60Hz(void)
{
__asm
	ld a,(#_RG9SAV)
	and #0b11111101
	ld (#_RG9SAV),a
	ld b,a
	ld a,#0x89
	ld		c, #0x99		;;	VDP port #1 (unsupport "MSX1 adapter")
	out		(c), b			;;	out data
	out		(c), a			;;	out VDP register number
__endasm;
}

void PrintChar(char c) 
{
  c;
__asm
  push  ix
  ld ix,#0
  add ix,sp
  ld  a,4(ix)
  call #0xA2       ; Bios CHPUT
  ei 
  pop ix
__endasm;
}

/* =============================================================================
 PRINT
  
 Description: 
           Displays a text string on the screen.             
                        
 Input:    (char*) String    
 Output:   -
 Notes:
            Supports escape sequences:
             \a (0x07) - Beep
             \b (0x08) - Backspace. Cursor left, wraps around to previous line, 
                         stop at top left of screen.
             \t (0x09) - Horizontal Tab. Tab, overwrites with spaces up to next 
                         8th column, wraps around to start of next line, scrolls
                         at bottom right of screen.
             \n (0x0A) - Newline > Line Feed and Carriage Return (CRLF) 
                         Note: CR added in this Lib.
             \v (0x0B) - Cursor home. Place the cursor at the top of the screen.
             \f (0x0C) - Formfeed. Clear screen and place the cursor at the top. 
             \r (0x0D) - CR (Carriage Return)
            
             \" (0x22) - Double quotation mark
             \' (0x27) - Single quotation mark
             \? (0x3F) - Question mark
             \\ (0x5C) - Backslash
============================================================================= */
void Print(char* text)
{
  char character;
  
  while(*(text)) 
  {
    character=*(text++);
    if (character=='\n')
    {
      PrintChar(10); //LF (Line Feed)
      PrintChar(13); //CR (Carriage Return)
    }else{ 
      PrintChar(character);
    } 
  }
}

                                          				
void     myVDPready(void) __naked															// Check if MSX2 VDP is ready (Internal Use)
{ 
__asm 
    checkIfReady:
    ld  a,#2
    out (#0x99),a           ; wait till previous VDP execution is over (CE)
    ld  a,#128+#15
    out (#0x99),a
    in  a,(#0x99)
   	rra						; check CE (bit#0)
    ld	a, #0				
    out (#0x99),a
    ld  a,#128+#15
    out (#0x99),a
    jp		c, checkIfReady
    ret
__endasm; 
}
