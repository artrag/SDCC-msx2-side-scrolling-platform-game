#pragma once

/* Interrupt	functions										 */
inline void     EnableInterrupt() 
{ 
__asm 
    ei
__endasm; 
}
inline void     DisableInterrupt() \
{
__asm 
    di
__endasm; 
}
inline void     Halt() 
{
__asm
    halt
__endasm; 
}
inline void     Suspend() 
{
__asm
    ei
    halt
    ret
__endasm; 
}



#define ReadMSXtype()	*((char*)0x2D)
#define Reboot(x) __asm__("rst #0")

void                SetDisplayPage(  char page ) __z88dk_fastcall;              // Set the Display Page in MSX2 Screen Mode 5 to 12

void				VDP60Hz(void);												// Switch MSX2 VDP to 60Hz NTSC Mode
void 				VDPlineSwitch(void);										// Switch MSX2 VDP to 192 / 212 vertical lines

void 				Print(char *text);												// Print a string to Text screen mode

void chgmod(char c) __sdcccall(1) __naked;
void putch(char c) 	__sdcccall(1) __naked;


void FT_errorHandler(char n, char *name) __sdcccall(1) ;

void	myHMMV( unsigned int DX, unsigned int DY, unsigned int NX, unsigned int NY, char COL) __sdcccall(0) __naked;

void myfVDP(void *Address)  __sdcccall(1)  __naked;
void myVDPwrite( char value, char regnum) __sdcccall(1) __naked;	// write to VDP Register
void myFT_wait(unsigned char cicles) __sdcccall(1) __naked;
// char myPoint( unsigned int X,  unsigned int Y ) __sdcccall(1) __naked;
void WaitLineInt(void) __sdcccall(1) __naked;

void mySetAdjust(signed char x, signed char y) __sdcccall(1);
void myISR(void) __sdcccall(1) __naked;
void myInstISR(void) __sdcccall(1) __naked;
void myISRrestore(void) __sdcccall(1) __naked;

unsigned char 	myCheckkbd(unsigned char nrow) __sdcccall(1) __naked;

// void 			myOutPort(unsigned char port,unsigned char data) __sdcccall(1) __naked __preserves_regs(a,b,h,l,d,e,iyl,iyh);
// unsigned char 	myInPort( unsigned char port ) __sdcccall(1) __naked __preserves_regs(b,h,l,d,e,iyl,iyh);

__sfr __at 0x98 Port98;
__sfr __at 0x99 Port99;

char MyRand(void) __naked  __preserves_regs(b,c,iyl,iyh);

char MyLoadTiles(char *file_name) __sdcccall(1);
void MyLoadMap(char mapnumber,unsigned char* p ) __sdcccall(1);

void NewLine(unsigned char x,char page, int MapX) __sdcccall(1) __naked;
void PatchPlotOneTile(unsigned char ScrnX,char page, int MapX) __sdcccall(1) __naked;

void ScrollRight(char step) __sdcccall(1);
void ScrollLeft(char step) __sdcccall(1); 

void BorderLinesL(unsigned char ScrnX,char page, int MapX) __sdcccall(1) __naked;
void BorderLinesR(unsigned char ScrnX,char page, int MapX) __sdcccall(1) __naked;

void SetVramR(char page, unsigned int addr) __sdcccall(1) __naked __preserves_regs(b,c,h,l,iyl,iyh);
void SetVramW(char page, unsigned int addr) __sdcccall(1) __naked __preserves_regs(b,c,h,l,iyl,iyh); 
void VramWrite(unsigned int addr, unsigned int len) __sdcccall(1) __naked;

void SetVramR14( unsigned int addr) __sdcccall(1) __naked __preserves_regs(b,c,d,e,h,l,iyl,iyh);
void SetVramW14( unsigned int addr) __sdcccall(1) __naked __preserves_regs(b,c,d,e,h,l,iyl,iyh);


void SprtInit(void) __sdcccall(1) ;

void SetPalette(char *palette) __sdcccall(1);
void RestorePalette(void) __naked;

#define MaxObjNum 8

void ObjectsInit(void);
void ObjectstoVRAM(int MapX) __sdcccall(1);

void UpdateColor(char plane,char frame,char nsat) __sdcccall(1);
void UpdateFrame(char plane,char frame,char nsat) __sdcccall(1);

void     myVDPready(void) __naked;


// DATA
void sprite_patterns(void) __naked;
void sprite_colors(void) __naked;

void DataLevelMap(void) __banked __naked ;

void intro(void) __banked;

void data0(void) __banked __naked ;
void data1(void) __banked __naked ;
void data2(void) __banked __naked ;
void data3(void) __banked __naked ;


typedef struct {

	unsigned int sx;		// source X (0 to 511)			R32 & 	R33
	unsigned int sy;		// source Y (0 to 1023)			R34	&	R34
	unsigned int dx;		// destination X (0 to 511)		R36	&	R37
	unsigned int dy;		// destination Y (0 to 1023) 	R38	&	R39
	unsigned int nx; 		// width (0 to 511)				R40	&	R41
	unsigned int ny; 		// height (0 to 511)			R42	&	R43
	unsigned char col;		// color used by some commands. R44	
	unsigned char param;	// Parameters set the direction. Example opDOWN | opRIGHT 		R45
	unsigned char cmd;		// VDP Command + Logical Operator : Like opLMMM | LOGICAL_XOR	R46
} FastVDP;



// VDP Commande code
#define opHMMC 	0xF0
#define opYMMM 	0xE0
#define opHMMM 	0xD0
#define opHMMV 	0xC0
#define opLMMC 	0xB0
#define opLMCM 	0xA0
#define opLMMM 	0x90
#define opLMMV 	0x80
#define opLINE 	0x70
#define opSRCH	0x60
#define opPSET 	0x50
#define opPOINT 0x40
#define opSTOP	0x00


// VDP Commande parameters
#define opRIGHT 0b00000000
#define opDOWN  0b00000000
#define opLEFT  0b00000100
#define opUP    0b00001000


__at(0xF3DF) unsigned char RG0SAV;
__at(0xF3E0) unsigned char RG1SAV;

__at(0xFFE7) unsigned char RG8SAV;
__at(0xFFE8) unsigned char RG9SAV;
__at(0xFFE9) unsigned char RG10SA;
__at(0xFFEA) unsigned char RG11SA;
__at(0xFFEB) unsigned char RG12SA;
__at(0xFFEC) unsigned char RG13SA;
__at(0xFFED) unsigned char RG14SA;
__at(0xFFEE) unsigned char RG15SA;
__at(0xFFEF) unsigned char RG16SA;
__at(0xFFF0) unsigned char RG17SA;
__at(0xFFF1) unsigned char RG18SA;
