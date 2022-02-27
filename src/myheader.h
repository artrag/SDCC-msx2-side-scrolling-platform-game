
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
void putch(char c) __sdcccall(1) __naked;

// void FT_SetName( FCB *p_fcb, const char *p_name ) __sdcccall(1) ;
void FT_errorHandler(char n, char *name) __sdcccall(1) ;
// char myFT_LoadSc8Image(char *file_name, unsigned int start_Y, char *buffer) __sdcccall(1) ;

void	myHMMV( unsigned int DX, unsigned int DY, unsigned int NX, unsigned int NY, char COL) __sdcccall(0) __naked;

void myfVDP(void *Address)  __sdcccall(1)  __naked;
void myVDPwrite( char vdpreg, char data ) __sdcccall(1) __naked;	// write to VDP Register
void myFT_wait(unsigned char cicles) __sdcccall(1) __naked;
// char myPoint( unsigned int X,  unsigned int Y ) __sdcccall(1) __naked;
void WaitLineInt(void) __sdcccall(1) __naked;

void mySetAdjust(signed char x, signed char y) __sdcccall(1);
void myISR(void) __sdcccall(1) __naked;
void myInstISR(void) __sdcccall(1) __naked;
void myISRrestore(void) __sdcccall(1) __naked;

unsigned char myCheckkbd(unsigned char nrow) __sdcccall(1) __naked;

void 			myOutPort(unsigned char port,unsigned char data) __sdcccall(1) __naked __preserves_regs(a,b,h,l,d,e,iyl,iyh);
unsigned char 	myInPort( unsigned char port ) __sdcccall(1) __naked __preserves_regs(b,h,l,d,e,iyl,iyh);

char MyLoadTiles(char *file_name) __sdcccall(1);
void MyLoadMap(char mapnumber,unsigned char* p ) __sdcccall(1);

void NewLine(unsigned char x,char page, int MapX) __sdcccall(1) __naked;
void PatchPlotOneTile(unsigned char ScrnX,char page, int MapX) __sdcccall(1) __naked;

void ScrollRight(char step) __sdcccall(1);
void ScrollLeft(char step) __sdcccall(1); 

void BorderLinesL(unsigned char ScrnX,char page, int MapX) __sdcccall(1) __naked;
void BorderLinesR(unsigned char ScrnX,char page, int MapX) __sdcccall(1) __naked;

void SetVramW(char page, unsigned int addr) __sdcccall(1) __naked;
void VramWrite(unsigned int addr, unsigned int len) __sdcccall(1) __naked;

void SprtInit(void) __sdcccall(1) ;
// void SatUpdate(int MapX) __sdcccall(1);
// void SwapSat(void);

#define MaxObjNum 8

void ObjectsInit(void);
// void ObjectsUpdate(int MapX) __sdcccall(1);
void ObjectstoVRAM(int MapX) __sdcccall(1);

void UpdateColor(char plane,char frame,char nsat) __sdcccall(1);
void UpdateFrame(char plane,char frame,char nsat) __sdcccall(1);

void sprite_patterns(void) __naked;
void sprite_colors(void) __naked;