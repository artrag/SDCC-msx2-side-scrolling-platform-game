;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.2.0 #13049 (MINGW64)
;--------------------------------------------------------
	.module mytestrom
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _PrintChar
	.globl _PlotOneColumnTileAndMask
	.globl _PlotOneColumnTile
	.globl _main
	.globl b_DataLevelMap
	.globl _DataLevelMap
	.globl _sprite_colors
	.globl _sprite_patterns
	.globl _v
	.globl _x
	.globl _y
	.globl _u
	.globl _object
	.globl _RG18SA
	.globl _RG17SA
	.globl _RG16SA
	.globl _RG15SA
	.globl _RG14SA
	.globl _RG13SA
	.globl _RG12SA
	.globl _RG11SA
	.globl _RG10SA
	.globl _RG9SAV
	.globl _RG8SAV
	.globl _RG1SAV
	.globl _RG0SAV
	.globl _LevelMap
	.globl _cursat
	.globl _OldIsr
	.globl _page
	.globl _newx
	.globl _WLevelDY
	.globl _WLevelDX
	.globl _LevelH
	.globl _LevelW
	.globl _WLevely
	.globl _WLevelx
	.globl _ScrollRight
	.globl _ScrollLeft
	.globl _BorderLinesL
	.globl _BorderLinesR
	.globl _NewLine
	.globl _PatchPlotOneTile
	.globl _myVDPwrite
	.globl _myfVDP
	.globl _mySetAdjust
	.globl _myFT_wait
	.globl _WaitLineInt
	.globl _FT_errorHandler
	.globl _MyLoadMap
	.globl _myISR
	.globl _myInstISR
	.globl _myISRrestore
	.globl _myCheckkbd
	.globl _ObjectsInit
	.globl _ObjectstoVRAM
	.globl _UpdateColor
	.globl _UpdateFrame
	.globl _SprtInit
	.globl _VramWrite
	.globl _SetVramW
	.globl _chgmod
	.globl _putch
	.globl _myHMMV
	.globl _SetDisplayPage
	.globl _VDPlineSwitch
	.globl _VDP60Hz
	.globl _Print
	.globl _myVDPready
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
_Port98	=	0x0098
_Port99	=	0x0099
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
_MyCommand:
	.ds 15
_MyBorder:
	.ds 15
_WLevelx::
	.ds 2
_WLevely::
	.ds 1
_LevelW::
	.ds 1
_LevelH::
	.ds 1
_WLevelDX::
	.ds 2
_WLevelDY::
	.ds 2
_newx::
	.ds 1
_page::
	.ds 1
_OldIsr::
	.ds 3
_cursat::
	.ds 1
_LevelMap::
	.ds 2816
_p:
	.ds 2
_RG0SAV	=	0xf3df
_RG1SAV	=	0xf3e0
_RG8SAV	=	0xffe7
_RG9SAV	=	0xffe8
_RG10SA	=	0xffe9
_RG11SA	=	0xffea
_RG12SA	=	0xffeb
_RG13SA	=	0xffec
_RG14SA	=	0xffed
_RG15SA	=	0xffee
_RG16SA	=	0xffef
_RG17SA	=	0xfff0
_RG18SA	=	0xfff1
_object::
	.ds 56
_u::
	.ds 2
_y::
	.ds 1
_x::
	.ds 1
_v::
	.ds 1
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _INITIALIZED
;--------------------------------------------------------
; absolute external ram data
;--------------------------------------------------------
	.area _DABS (ABS)
;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
	.area _HOME
	.area _GSINIT
	.area _GSFINAL
	.area _GSINIT
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	.area _HOME
	.area _HOME
;--------------------------------------------------------
; code
;--------------------------------------------------------
	.area _BANK0
;src\mytestrom.c:61: void main(void) 
;	---------------------------------
; Function main
; ---------------------------------
_main::
;src\mytestrom.c:65: rd = ReadMSXtype();					  	// Read MSX Type
	ld	a, (#0x002d)
;src\mytestrom.c:67: if (rd==0) FT_errorHandler(3,"msx 1 ");	// If MSX1 got to Error !
	or	a, a
	jr	NZ, 00102$
	ld	de, #___str_0
	ld	a, #0x03
	call	_FT_errorHandler
00102$:
;src\mytestrom.c:69: MyLoadMap(1,LevelMap);					// load level map 256x11 arranged by columns
	ld	de, #_LevelMap
	ld	a, #0x01
	call	_MyLoadMap
;src\mytestrom.c:71: chgmod(8);						  		// Init Screen 8
	ld	a, #0x08
	call	_chgmod
;src\mytestrom.c:72: myVDPwrite(0,7);						// borders	
	ld	l, #0x07
;	spillPairReg hl
;	spillPairReg hl
	xor	a, a
	call	_myVDPwrite
;src\mytestrom.c:73: VDPlineSwitch();						// 192 lines
	call	_VDPlineSwitch
;src\mytestrom.c:75: VDP60Hz();
	call	_VDP60Hz
;src\mytestrom.c:77: myHMMV(0,0,256,512, 0);					// Clear all VRAM  by Byte 0 (Black)
	xor	a, a
	push	af
	inc	sp
	ld	hl, #0x0200
	push	hl
	ld	h, #0x01
	push	hl
	ld	h, l
	push	hl
	push	hl
	call	_myHMMV
	ld	hl, #9
	add	hl, sp
	ld	sp, hl
;src\/myheader.h:14: __endasm; 
	di
;src\mytestrom.c:79: myVDPready();								// wait for command completion
	call	_myVDPready
;src\/myheader.h:8: __endasm; 
	ei
;src\mytestrom.c:82: ObjectsInit();							// initialize logical object 
	call	_ObjectsInit
;src\mytestrom.c:83: SprtInit();								// initialize sprites in VRAM 
	call	_SprtInit
;src\mytestrom.c:85: myInstISR();							// install a fake ISR to cut the overhead
	call	_myInstISR
;src\mytestrom.c:87: page = 0;
	ld	hl, #_page
	ld	(hl), #0x00
;src\mytestrom.c:88: mySetAdjust(0,8);						// same as myVDPwrite((0-8) & 15,18);	
	ld	l, #0x08
;	spillPairReg hl
;	spillPairReg hl
	xor	a, a
	call	_mySetAdjust
;src\mytestrom.c:90: for (WLevelx = 0;WLevelx<0+WindowW;) {
	ld	hl, #0x0000
	ld	(_WLevelx), hl
00117$:
;src\mytestrom.c:91: myFT_wait(1);		
	ld	a, #0x01
	call	_myFT_wait
;src\mytestrom.c:92: NewLine(WLevelx,0,WLevelx);WLevelx++;
	ld	a, (_WLevelx+0)
	ld	c, a
	ld	hl, (_WLevelx)
	push	hl
	ld	l, #0x00
;	spillPairReg hl
;	spillPairReg hl
	ld	a, c
	call	_NewLine
	ld	hl, (_WLevelx)
	inc	hl
;src\mytestrom.c:93: NewLine(WindowW-WLevelx,0,WindowW-WLevelx);	WLevelx++;
	ld	(_WLevelx), hl
	ld	a, #0xf0
	sub	a, l
	ld	e, a
	sbc	a, a
	sub	a, h
	ld	d, a
	ld	a, (_WLevelx+0)
	ld	c, a
	ld	a, #0xf0
	sub	a, c
	ld	c, a
	push	de
	ld	l, #0x00
;	spillPairReg hl
;	spillPairReg hl
	ld	a, c
	call	_NewLine
	ld	hl, (_WLevelx)
	inc	hl
	ld	(_WLevelx), hl
;src\mytestrom.c:94: NewLine(WLevelx,0,WLevelx);WLevelx++;
	ld	a, (_WLevelx+0)
	ld	c, a
	ld	hl, (_WLevelx)
	push	hl
	ld	l, #0x00
;	spillPairReg hl
;	spillPairReg hl
	ld	a, c
	call	_NewLine
	ld	hl, (_WLevelx)
	inc	hl
;src\mytestrom.c:95: NewLine(WindowW-WLevelx,0,WindowW-WLevelx);	WLevelx++;
	ld	(_WLevelx), hl
	ld	a, #0xf0
	sub	a, l
	ld	e, a
	sbc	a, a
	sub	a, h
	ld	d, a
	ld	a, (_WLevelx+0)
	ld	c, a
	ld	a, #0xf0
	sub	a, c
	ld	c, a
	push	de
	ld	l, #0x00
;	spillPairReg hl
;	spillPairReg hl
	ld	a, c
	call	_NewLine
	ld	hl, (_WLevelx)
	inc	hl
;src\mytestrom.c:90: for (WLevelx = 0;WLevelx<0+WindowW;) {
	ld	(_WLevelx), hl
	ld	de, #0x00f0
	cp	a, a
	sbc	hl, de
	jr	C, 00117$
;src\mytestrom.c:98: WLevelx = 0;	
	ld	hl, #0x0000
	ld	(_WLevelx), hl
;src\mytestrom.c:100: MyBorder.ny = WindowH;
	ld	l, #0xb0
	ld	((_MyBorder + 10)), hl
;src\mytestrom.c:101: MyBorder.col = 0;
	ld	hl, #(_MyBorder + 12)
	ld	(hl), #0x00
;src\mytestrom.c:102: MyBorder.param = 0;
	ld	hl, #(_MyBorder + 13)
	ld	(hl), #0x00
;src\mytestrom.c:103: MyBorder.cmd = opHMMV;
	ld	hl, #(_MyBorder + 14)
	ld	(hl), #0xc0
;src\mytestrom.c:105: MyCommand.ny = WindowH;
	ld	hl, #0x00b0
	ld	((_MyCommand + 10)), hl
;src\mytestrom.c:106: MyCommand.col = 0;
	ld	hl, #(_MyCommand + 12)
	ld	(hl), #0x00
;src\mytestrom.c:107: MyCommand.param = 0;
	ld	hl, #(_MyCommand + 13)
	ld	(hl), #0x00
;src\mytestrom.c:108: MyCommand.cmd = opHMMM;
	ld	hl, #(_MyCommand + 14)
	ld	(hl), #0xd0
;src\mytestrom.c:111: while (myCheckkbd(7)==0xFF)
00112$:
	ld	a, #0x07
	call	_myCheckkbd
	inc	a
	jp	NZ,00114$
;src\mytestrom.c:113: WaitLineInt();			// wait for line 176-16
	call	_WaitLineInt
;src\mytestrom.c:114: cursat^=1;				// swap sat 0 and sat 1
	ld	a, (_cursat+0)
	xor	a, #0x01
	ld	(_cursat+0), a
;src\mytestrom.c:116: if ((myCheckkbd(8)==0x7F) && (WLevelx<16*(LevelW-15)))  { 
	ld	a, #0x08
	call	_myCheckkbd
	sub	a, #0x7f
	jr	NZ, 00109$
	ld	a, (_LevelW+0)
	ld	c, #0x00
	add	a, #0xf1
	ld	e, a
	ld	a, c
	adc	a, #0xff
	ld	d, a
	ex	de, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ex	de, hl
	ld	a, (_WLevelx+0)
	sub	a, e
	ld	a, (_WLevelx+1)
	sbc	a, d
	jp	PO, 00170$
	xor	a, #0x80
00170$:
	jp	P, 00109$
;src\mytestrom.c:117: WLevelx++;
	ld	hl, (_WLevelx)
	inc	hl
;src\mytestrom.c:118: ObjectstoVRAM(WLevelx);			
	ld	(_WLevelx), hl
	call	_ObjectstoVRAM
;src\mytestrom.c:119: ScrollRight(WLevelx & 15);
	ld	a, (_WLevelx+0)
	and	a, #0x0f
	call	_ScrollRight
	jp	00112$
00109$:
;src\mytestrom.c:121: else if ((myCheckkbd(8)==0xEF) && (WLevelx>0)) { 
	ld	a, #0x08
	call	_myCheckkbd
	sub	a, #0xef
	jr	NZ, 00105$
	xor	a, a
	ld	iy, #_WLevelx
	cp	a, 0 (iy)
	sbc	a, 1 (iy)
	jp	PO, 00173$
	xor	a, #0x80
00173$:
	jp	P, 00105$
;src\mytestrom.c:122: WLevelx--;
	ld	hl, (_WLevelx)
	dec	hl
;src\mytestrom.c:123: ObjectstoVRAM(WLevelx);			
	ld	(_WLevelx), hl
	call	_ObjectstoVRAM
;src\mytestrom.c:124: ScrollLeft(WLevelx & 15);
	ld	a, (_WLevelx+0)
	and	a, #0x0f
	call	_ScrollLeft
	jp	00112$
00105$:
;src\mytestrom.c:127: ObjectstoVRAM(WLevelx);						
	ld	hl, (_WLevelx)
	call	_ObjectstoVRAM
	jp	00112$
00114$:
;src\mytestrom.c:131: myISRrestore();
	call	_myISRrestore
;src\mytestrom.c:132: chgmod(0);
	xor	a, a
	call	_chgmod
;src\mytestrom.c:133: Reboot(0);
	rst	#0
;src\mytestrom.c:134: }
	ret
___str_0:
	.ascii "msx 1 "
	.db 0x00
;src\mytestrom.c:136: void ScrollRight(char step) __sdcccall(1) 
;	---------------------------------
; Function ScrollRight
; ---------------------------------
_ScrollRight::
	ld	c, a
;src\mytestrom.c:139: myVDPwrite((step-8) & 15,18);			
	ld	b, c
	ld	a, b
	add	a, #0xf8
	and	a, #0x0f
	ld	e, a
	push	bc
	ld	l, #0x12
;	spillPairReg hl
;	spillPairReg hl
	ld	a, e
	call	_myVDPwrite
	pop	bc
;src\mytestrom.c:140: switch (step) {
	ld	a, c
	or	a, a
	jr	NZ, 00102$
;src\mytestrom.c:142: page ^=1;							// case 0
	ld	a, (_page+0)
	xor	a, #0x01
	ld	(_page+0), a
;src\mytestrom.c:143: SetDisplayPage(page);
	push	bc
	ld	a, (_page+0)
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	call	_SetDisplayPage
	pop	bc
;src\mytestrom.c:144: MyBorder.dx = 240;
	ld	hl, #0x00f0
	ld	((_MyBorder + 4)), hl
;src\mytestrom.c:145: MyBorder.nx = 15;
	ld	l, #0x0f
	ld	((_MyBorder + 8)), hl
;src\mytestrom.c:146: MyBorder.dy = 256*page;
	ld	a, (_page+0)
	ld	d, a
	ld	e, #0x00
	ld	((_MyBorder + 6)), de
;src\mytestrom.c:147: myfVDP(&MyBorder);
	push	bc
	ld	hl, #_MyBorder
	call	_myfVDP
	pop	bc
;src\mytestrom.c:148: BorderLinesR(WindowW-1,page, WLevelx+WindowW-1);		
	ld	hl, (_WLevelx)
	ld	de, #0x00ef
	add	hl, de
	push	bc
	push	hl
	ld	a, (_page+0)
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	ld	a, #0xef
	call	_BorderLinesR
	pop	bc
;src\mytestrom.c:149: break;
	jp	00103$
;src\mytestrom.c:150: default:								// case 1-15
00102$:
;src\mytestrom.c:151: MyCommand.sx = 16*step;
	ld	e, c
	ld	d, #0x00
	ex	de, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ex	de, hl
	ld	(_MyCommand), de
;src\mytestrom.c:152: MyCommand.dx = MyCommand.sx - 16;;
	ld	hl, (#_MyCommand + 0)
	ld	de, #0xfff0
	add	hl, de
	ld	e, l
	ld	a,h
	ld	d,a
	ld	((_MyCommand + 4)), de
;src\mytestrom.c:153: MyCommand.sy = 256*page;
	ld	a, (_page+0)
	ld	d, a
	ld	e, #0x00
	ld	((_MyCommand + 2)), de
;src\mytestrom.c:154: MyCommand.dy = MyCommand.sy ^ 256;
	ld	de, (#(_MyCommand + 2) + 0)
	ld	a, d
	xor	a, #0x01
	ld	d, a
	ld	((_MyCommand + 6)), de
;src\mytestrom.c:155: MyCommand.nx = 16;
	ld	hl, #0x0010
	ld	((_MyCommand + 8)), hl
;src\mytestrom.c:156: myfVDP(&MyCommand);		
	push	bc
	ld	hl, #_MyCommand
	call	_myfVDP
	pop	bc
;src\mytestrom.c:157: BorderLinesR(step+WindowW-1,page,WLevelx+WindowW-1);
	ld	hl, (_WLevelx)
	ld	de, #0x00ef
	add	hl, de
	ld	a, b
	add	a, #0xef
	ld	e, a
	push	bc
	push	hl
	ld	a, (_page+0)
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	ld	a, e
	call	_BorderLinesR
	pop	bc
;src\mytestrom.c:159: }
00103$:
;src\mytestrom.c:160: if (step==15) PatchPlotOneTile(step+WindowW-1-16,page^1,WLevelx+WindowW-1);		
	ld	a, c
	sub	a, #0x0f
	ret	NZ
	ld	hl, (_WLevelx)
	ld	de, #0x00ef
	add	hl, de
	ld	a, (_page+0)
	xor	a, #0x01
	ld	c, a
	ld	a, b
	add	a, #0xdf
	ld	b, a
	push	hl
	ld	l, c
;	spillPairReg hl
;	spillPairReg hl
	ld	a, b
	call	_PatchPlotOneTile
;src\mytestrom.c:161: }
	ret
;src\mytestrom.c:163: void ScrollLeft(char step) __sdcccall(1)
;	---------------------------------
; Function ScrollLeft
; ---------------------------------
_ScrollLeft::
;src\mytestrom.c:166: myVDPwrite((step-8) & 15,18);	
	ld	c, a
	add	a, #0xf8
	and	a, #0x0f
	ld	b, a
	push	bc
	ld	l, #0x12
;	spillPairReg hl
;	spillPairReg hl
	ld	a, b
	call	_myVDPwrite
	pop	bc
;src\mytestrom.c:167: switch (step) {
	ld	a, c
	sub	a, #0x0f
	jr	NZ, 00102$
;src\mytestrom.c:169: page ^=1;					
	ld	a, (_page+0)
	xor	a, #0x01
	ld	(_page+0), a
;src\mytestrom.c:170: SetDisplayPage(page);				// case 15
	push	bc
	ld	a, (_page+0)
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	call	_SetDisplayPage
	pop	bc
;src\mytestrom.c:171: MyBorder.dx = 0;	
	ld	hl, #0x0000
	ld	((_MyBorder + 4)), hl
;src\mytestrom.c:172: MyBorder.nx = 15;
	ld	l, #0x0f
	ld	((_MyBorder + 8)), hl
;src\mytestrom.c:173: MyBorder.dy = 256*page;
	ld	a, (_page+0)
	ld	b, #0x00
	ld	d, a
	ld	e, #0x00
	ld	((_MyBorder + 6)), de
;src\mytestrom.c:174: myfVDP(&MyBorder);
	push	bc
	ld	hl, #_MyBorder
	call	_myfVDP
	pop	bc
;src\mytestrom.c:175: BorderLinesL(step,page,WLevelx);		
	push	bc
	ld	hl, (_WLevelx)
	push	hl
	ld	a, (_page+0)
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	ld	a, c
	call	_BorderLinesL
	pop	bc
;src\mytestrom.c:176: break;				
	jp	00103$
;src\mytestrom.c:177: default:								// case 14-0
00102$:
;src\mytestrom.c:178: MyCommand.sx = 16*step;
	ld	e, c
	ld	d, #0x00
	ex	de, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ex	de, hl
	ld	(_MyCommand), de
;src\mytestrom.c:179: MyCommand.dx = MyCommand.sx + 16;
	ld	de, (#_MyCommand + 0)
	ld	hl, #0x0010
	add	hl, de
	ex	de, hl
	ld	((_MyCommand + 4)), de
;src\mytestrom.c:180: MyCommand.sy = 256*page;
	ld	a, (_page+0)
	ld	b, #0x00
	ld	d, a
	ld	e, #0x00
	ld	((_MyCommand + 2)), de
;src\mytestrom.c:181: MyCommand.dy = MyCommand.sy ^ 256;		
	ld	de, (#(_MyCommand + 2) + 0)
	ld	a, d
	xor	a, #0x01
	ld	d, a
	ld	((_MyCommand + 6)), de
;src\mytestrom.c:182: MyCommand.nx = 16;						
	ld	hl, #0x0010
	ld	((_MyCommand + 8)), hl
;src\mytestrom.c:183: myfVDP(&MyCommand);					
	push	bc
	ld	hl, #_MyCommand
	call	_myfVDP
	pop	bc
;src\mytestrom.c:184: BorderLinesL(step,page,WLevelx);			
	push	bc
	ld	hl, (_WLevelx)
	push	hl
	ld	a, (_page+0)
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	ld	a, c
	call	_BorderLinesL
	pop	bc
;src\mytestrom.c:186: }
00103$:
;src\mytestrom.c:187: if (step==0) PatchPlotOneTile(16,page^1,WLevelx);				
	ld	a, c
	or	a, a
	ret	NZ
	ld	a, (_page+0)
	xor	a, #0x01
	ld	c, a
	ld	hl, (_WLevelx)
	push	hl
	ld	l, c
;	spillPairReg hl
;	spillPairReg hl
	ld	a, #0x10
	call	_PatchPlotOneTile
;src\mytestrom.c:188: }
	ret
;src\mytestrom.c:208: void PlotOneColumnTile(void) __sdcccall(1) 
;	---------------------------------
; Function PlotOneColumnTile
; ---------------------------------
_PlotOneColumnTile::
;src\mytestrom.c:240: __endasm;
	exx
	ld	hl,(_p)
	ld	a,(hl)
	rlca
	rlca
	and	a,#3
	add	a,a
	add	a,#b_data0
	ld	(#0x9000),a
	inc	a
	ld	(#0xb000),a
	ld	a,(hl)
	inc	hl
	ld	(_p),hl ; save next tile
	and	a,#0x3F ; tile number
	add	a,#0x80 ; address of the segment
	ld	h,a ; address of the tile in the segment
	ld	l,d
	exx
	.rept	#16
	out	(c),e ; set vram address in 14 bits
	out	(c),d
	inc	d ; new line
	exx
	outi	; write data
	exx
	.endm
;src\mytestrom.c:241: }
	ret
;src\mytestrom.c:243: void PlotOneColumnTileAndMask(void) __sdcccall(1) 
;	---------------------------------
; Function PlotOneColumnTileAndMask
; ---------------------------------
_PlotOneColumnTileAndMask::
;src\mytestrom.c:279: __endasm;
	exx
	ld	hl,(_p)
	ld	a,(hl)
	rlca
	rlca
	and	a,#3
	add	a,a
	add	a,#b_data0
	ld	(#0x9000),a
	inc	a
	ld	(#0xb000),a
	ld	a,(hl)
	inc	hl
	ld	(_p),hl ; save next tile
	and	a,#0x3F ; tile number
	add	a,#0x80 ; address of the segment
	ld	h,a ; address of the tile in the segment
	ld	l,d
	exx
	.rept	#16
	out	(c),e ; set vram address in 14 bits
	out	(c),d
	exx
	outi	; write data
	exx
	out	(c),l ; set vram address in 14 bits for border
	out	(c),d
	inc	d ; new line
	xor	a,a ; write border
	out	(#0x98),a
	.endm
;src\mytestrom.c:280: }
	ret
;src\mytestrom.c:282: void BorderLinesL(unsigned char ScrnX,char page, int MapX) __sdcccall(1) __naked
;	---------------------------------
; Function BorderLinesL
; ---------------------------------
_BorderLinesL::
;src\mytestrom.c:386: __endasm;
	pop	bc ; get ret address
	pop	de ; de = MapX
	push	bc ; save ret address
	ex	af,af'			; a' = ScrnX
	ld	a,l ; l = page
	add	a,a
	add	a,a
	ld	(_RG14SA),a
	ld	c,e ; C = low(mapx)
	sra	d ; DE/16
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
	add	hl,de ; DE/16 * 11
	ld	de,#_LevelMap
	add	hl,de
	ld	(_p), hl
	ex	af,af'				; a' = ScrnX
	ld	e,a ; DE vramm address for new border data
	add	a,#240 ; L = E +/- 240U according to the scroll direction
	ld	l,a ; DL hold vramm address for blank border
	ld	a,c ; C = low(MapX)
	and	a,#15
	add	a,a
	add	a,a
	add	a,a
	add	a,a
	exx
	ld	d,a ; common offeset of the address in the tile
	ld	c,#0x98 ; used by _PlotOneColumnTileAndMask
	exx
	di
	ld	a,(_RG14SA) ; set address in vdp(14)
	out	(#0x99), a
	inc	a
	ld	(_RG14SA),a ; save next block
	ld	a,#0x8E
	out	(#0x99), a
	ld	c,#0x99
	ld	d,#0x40
	call	_PlotOneColumnTileAndMask ; plot 4 tiles
	call	_PlotOneColumnTileAndMask
	call	_PlotOneColumnTileAndMask
	call	_PlotOneColumnTileAndMask
	ld	a,(_RG14SA) ; set address in vdp(14)
	out	(#0x99), a
	inc	a
	ld	(_RG14SA),a ; save next block
	ld	a,#0x8E
	out	(#0x99), a
	ld	d,#0x40
	call	_PlotOneColumnTileAndMask ; plot 4 tiles
	call	_PlotOneColumnTileAndMask
	call	_PlotOneColumnTileAndMask
	call	_PlotOneColumnTileAndMask
	ld	a,(_RG14SA) ; set address in vdp(14)
	out	(#0x99), a
	ld	a,#0x8E
	out	(#0x99), a
	ld	d,#0x40
	call	_PlotOneColumnTileAndMask ; plot 3 tiles
	call	_PlotOneColumnTileAndMask
	call	_PlotOneColumnTileAndMask
	ei
	ret
;src\mytestrom.c:387: }
;src\mytestrom.c:389: void BorderLinesR(unsigned char ScrnX,char page, int MapX) __sdcccall(1) __naked
;	---------------------------------
; Function BorderLinesR
; ---------------------------------
_BorderLinesR::
;src\mytestrom.c:493: __endasm;
	pop	bc ; get ret address
	pop	de ; DE = MapX+240U
	push	bc ; save ret address
	ex	af,af'			; a' = ScrnX
	ld	a,l ; l = page
	add	a,a
	add	a,a
	ld	(_RG14SA),a
	ld	c,e ; C = low(mapx)
	sra	d ; DE/16
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
	add	hl,de ; DE/16 * 11
	ld	de,#_LevelMap
	add	hl,de
	ld	(_p), hl
	ex	af,af'				; a' = ScrnX
	ld	e,a ; DE vramm address for new border data
	sub	a,#240 ; L = E +/- 240U according to the scroll direction
	ld	l,a ; DL hold vramm address for blank border
	ld	a,c ; C = low(MapX)
	and	a,#15
	add	a,a
	add	a,a
	add	a,a
	add	a,a
	exx
	ld	d,a ; common offeset of the address in the tile
	ld	c,#0x98 ; used by _PlotOneColumnTileAndMask
	exx
	di
	ld	a,(_RG14SA) ; set address in vdp(14)
	out	(#0x99), a
	inc	a
	ld	(_RG14SA),a ; save next block
	ld	a,#0x8E
	out	(#0x99), a
	ld	c,#0x99
	ld	d,#0x40
	call	_PlotOneColumnTileAndMask ; plot 4 tiles
	call	_PlotOneColumnTileAndMask
	call	_PlotOneColumnTileAndMask
	call	_PlotOneColumnTileAndMask
	ld	a,(_RG14SA) ; set address in vdp(14)
	out	(#0x99), a
	inc	a
	ld	(_RG14SA),a ; save next block
	ld	a,#0x8E
	out	(#0x99), a
	ld	d,#0x40
	call	_PlotOneColumnTileAndMask ; plot 4 tiles
	call	_PlotOneColumnTileAndMask
	call	_PlotOneColumnTileAndMask
	call	_PlotOneColumnTileAndMask
	ld	a,(_RG14SA) ; set address in vdp(14)
	out	(#0x99), a
	ld	a,#0x8E
	out	(#0x99), a
	ld	d,#0x40
	call	_PlotOneColumnTileAndMask ; plot 3 tiles
	call	_PlotOneColumnTileAndMask
	call	_PlotOneColumnTileAndMask
	ei
	ret
;src\mytestrom.c:494: }
;src\mytestrom.c:496: void NewLine(unsigned char ScrnX,char page, int MapX) __sdcccall(1) __naked
;	---------------------------------
; Function NewLine
; ---------------------------------
_NewLine::
;src\mytestrom.c:605: __endasm;
	pop	bc ; get ret address
	pop	de ; de = MapX
	push	bc ; save ret address
	ex	af,af'			; a' = ScrnX
	ld	a,l ; l = page
	add	a,a
	add	a,a
	ld	(_RG14SA),a
	ld	c,e ; C = low(mapx)
	sra	d ; DE/16
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
	add	hl,de ; DE/16 * 11
	ld	de,#_LevelMap
	add	hl,de
	ld	(_p), hl
	ex	af,af'			; a' = ScrnX
	ld	e,a ; DE vramm address for new border data
	ld	a,c ; C = low(MapX)
	and	a,#15
	add	a,a
	add	a,a
	add	a,a
	add	a,a
	exx
	ld	d,a ; common offeset of the address in the tile
	ld	c,#0x98 ; used by _PlotOneColumnTile
	exx
	di
	ld	a,(_RG14SA) ; set address in vdp(14)
	out	(#0x99), a
	inc	a
	ld	(_RG14SA),a ; save next block
	ld	a,#0x8E
	out	(#0x99), a
	ld	c,#0x99
	ld	d,#0x40
	call	_PlotOneColumnTile ; 4 tiles
	call	_PlotOneColumnTile
	call	_PlotOneColumnTile
	call	_PlotOneColumnTile
	ld	a,(_RG14SA) ; set address in vdp(14)
	out	(#0x99), a
	inc	a
	ld	(_RG14SA),a ; save next block
	ld	a,#0x8E
	out	(#0x99), a
	ld	d,#0x40
	call	_PlotOneColumnTile ; 4 tiles
	call	_PlotOneColumnTile
	call	_PlotOneColumnTile
	call	_PlotOneColumnTile
	ld	a,(_RG14SA) ; set address in vdp(14)
	out	(#0x99), a
	ld	a,#0x8E
	out	(#0x99), a
	ld	d,#0x40
	call	_PlotOneColumnTile ; 3 tiles
	call	_PlotOneColumnTile
	call	_PlotOneColumnTile
	ei
	ret
;src\mytestrom.c:606: }
;src\mytestrom.c:608: void PatchPlotOneTile(unsigned char ScrnX,char page, int MapX) __sdcccall(1) __naked
;	---------------------------------
; Function PatchPlotOneTile
; ---------------------------------
_PatchPlotOneTile::
;src\mytestrom.c:691: __endasm;
	pop	bc ; get ret address
	pop	de ; DE = MapX
	push	bc ; save ret address
	ex	af,af'			; a' = ScrnX
	ld	a,l ; l = page
	add	a,a
	add	a,a
	ld	(_RG14SA),a
	ld	c,e ; C = low(mapx)
	sra	d ; DE/16
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
	add	hl,de ; DE/16 * 11
	ld	de,#_LevelMap
	add	hl,de
	ld	(_p), hl
	ex	af,af'				; a' = ScrnX
	ld	e,a ; DE vramm address for new border data
	ld	a,c ; C = low(MapX)
	and	a,#15
	add	a,a
	add	a,a
	add	a,a
	add	a,a
	exx
	ld	d,a ; common offeset of the address in the tile
	ld	c,#0x98 ; used by _PlotOneColumnTile
	exx
	di
	ld	a,(_RG14SA) ; set address in vdp(14)
	out	(#0x99), a
	ld	a,#0x8E
	out	(#0x99), a
	ld	d,#0x40
	ld	c,#0x99
	call	_PlotOneColumnTile ; 1 tile
	ei
	ret
;src\mytestrom.c:692: }
;src\mytestrom.c:694: void 	myVDPwrite(char data, char vdpreg) __sdcccall(1) __naked
;	---------------------------------
; Function myVDPwrite
; ---------------------------------
_myVDPwrite::
;src\mytestrom.c:706: __endasm;
	di
	out	(#0x99),a
	ld	a,#128
	or	a,l
	out	(#0x99),a ;R#A := L
	ei
	ret
;src\mytestrom.c:708: }	
;src\mytestrom.c:731: void  	myfVDP(void *Address)  __sdcccall(1)  __naked
;	---------------------------------
; Function myfVDP
; ---------------------------------
_myfVDP::
;src\mytestrom.c:763: __endasm;
	di
	ld	a,#32 ; Start with Reg 32
	out	(#0x99),a
	ld	a,#128+#17
	out	(#0x99),a ;R#17 := 32
	ld	c,#0x9b ; c=#0x9b
	fvdpWait:
	ld	a,#2
	out	(#0x99),a
	ld	a,#128+#15
	out	(#0x99),a
	in	a,(#0x99)
	rrca
	jp	c, fvdpWait ; wait CE
	.rept	#15
	OUTI
	.endm
	xor	a,a ; set Status Register #0 for reading
	out	(#0x99),a
	ld	a,#0x8f
	out	(#0x99),a
	ei
	ret
;src\mytestrom.c:764: }
;src\mytestrom.c:816: void mySetAdjust(signed char x, signed char y) __sdcccall(1)
;	---------------------------------
; Function mySetAdjust
; ---------------------------------
_mySetAdjust::
;src\mytestrom.c:818: unsigned char value = ((x-8) & 15) | (((y-8) & 15)<<4);
	add	a, #0xf8
	and	a, #0x0f
	ld	c, a
	ld	a, l
	add	a, #0xf8
	and	a, #0x0f
	add	a, a
	add	a, a
	add	a, a
	add	a, a
	or	a, c
	ld	c, a
;src\mytestrom.c:819: RG18SA = value;			// Reg18 Save
	ld	iy, #_RG18SA
	ld	0 (iy), c
;src\mytestrom.c:820: myVDPwrite(value,18);
	ld	l, #0x12
;	spillPairReg hl
;	spillPairReg hl
	ld	a, c
;src\mytestrom.c:821: }
	jp	_myVDPwrite
;src\mytestrom.c:828: void myFT_wait(unsigned char cicles) __sdcccall(1) __naked {
;	---------------------------------
; Function myFT_wait
; ---------------------------------
_myFT_wait::
;src\mytestrom.c:851: __endasm;
	or	a, a
	00004$:
	ret	Z
	halt
	dec	a
	jp	00004$
;src\mytestrom.c:852: }
;src\mytestrom.c:854: void WaitLineInt(void) __sdcccall(1) __naked {
;	---------------------------------
; Function WaitLineInt
; ---------------------------------
_WaitLineInt::
;src\mytestrom.c:884: __endasm;
	di
	ld	a,#1 ; set Status Register #1 for reading
	out	(#0x99),a
	ld	a,#0x8f
	out	(#0x99),a
	WaitLI:
	in	a,(#0x99)
	rrca
	jr	nc,WaitLI
	xor	a,a ; set Status Register #0 for reading
	out	(#0x99),a
	ld	a,#0x8f
	out	(#0x99),a
	ei
	ret
;src\mytestrom.c:885: }
;src\mytestrom.c:917: void FT_errorHandler(char n, char *name) __sdcccall(1) 
;	---------------------------------
; Function FT_errorHandler
; ---------------------------------
_FT_errorHandler::
	ld	c, a
;src\mytestrom.c:924: chgmod(0);
	push	bc
	push	de
	xor	a, a
	call	_chgmod
	pop	de
	pop	bc
;src\mytestrom.c:926: switch (n)
	ld	a, c
	dec	a
	jr	Z, 00101$
	ld	a, c
	sub	a, #0x02
	jr	Z, 00102$
	ld	a, c
	sub	a, #0x03
	jr	Z, 00103$
	ld	a, c
	sub	a, #0x04
	jr	Z, 00104$
	jp	00105$
;src\mytestrom.c:928: case 1:
00101$:
;src\mytestrom.c:929: Print("\n\rFAILED: fcb_open(): ");
	push	de
	ld	hl, #___str_1
	call	_Print
	pop	de
;src\mytestrom.c:930: Print(name);
	ex	de, hl
	call	_Print
;src\mytestrom.c:931: break;
	jp	00105$
;src\mytestrom.c:933: case 2:
00102$:
;src\mytestrom.c:934: Print("\n\rFAILED: fcb_close():");
	push	de
	ld	hl, #___str_2
	call	_Print
	pop	de
;src\mytestrom.c:935: Print(name);
	ex	de, hl
	call	_Print
;src\mytestrom.c:936: break;  
	jp	00105$
;src\mytestrom.c:938: case 3:
00103$:
;src\mytestrom.c:939: Print("\n\rStop Kidding, run me on MSX2 !");
	ld	hl, #___str_3
	call	_Print
;src\mytestrom.c:940: break;
	jp	00105$
;src\mytestrom.c:942: case 4:
00104$:
;src\mytestrom.c:943: Print("\n\rUnespected end of file:");
	push	de
	ld	hl, #___str_4
	call	_Print
	pop	de
;src\mytestrom.c:944: Print(name);		  
	ex	de, hl
	call	_Print
;src\mytestrom.c:946: }
00105$:
;src\mytestrom.c:947: Reboot(0);
	rst	#0
;src\mytestrom.c:948: }
	ret
___str_1:
	.db 0x0a
	.db 0x0d
	.ascii "FAILED: fcb_open(): "
	.db 0x00
___str_2:
	.db 0x0a
	.db 0x0d
	.ascii "FAILED: fcb_close():"
	.db 0x00
___str_3:
	.db 0x0a
	.db 0x0d
	.ascii "Stop Kidding, run me on MSX2 !"
	.db 0x00
___str_4:
	.db 0x0a
	.db 0x0d
	.ascii "Unespected end of file:"
	.db 0x00
;src\mytestrom.c:950: void MyLoadMap(char mapnumber,unsigned char* p ) __sdcccall(1)
;	---------------------------------
; Function MyLoadMap
; ---------------------------------
_MyLoadMap::
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl, #-5
	add	hl, sp
	ld	sp, hl
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	ld	-3 (ix), e
	ld	-2 (ix), d
;src\mytestrom.c:952: char *q = &((char*)DataLevelMap)[2]+12*mapnumber;
	ld	bc, #_DataLevelMap
	ld	e, c
	ld	d, b
	inc	de
	inc	de
	ld	h, #0x00
;	spillPairReg hl
;	spillPairReg hl
	push	de
	ld	e, l
	ld	d, h
	add	hl, hl
	add	hl, de
	add	hl, hl
	add	hl, hl
	pop	de
	add	hl, de
	ex	de, hl
;src\mytestrom.c:961: __endasm;	
	ld	a,#b_DataLevelMap
	ld	(#0x9000),a
	ld	(#_curr_bank),a
	inc	a
	ld	(#0xb000),a
;src\mytestrom.c:963: LevelW = ((char*)DataLevelMap)[0];
	ld	a, (bc)
	ld	(_LevelW+0), a
;src\mytestrom.c:965: LevelH = 11;
	ld	hl, #_LevelH
	ld	(hl), #0x0b
;src\mytestrom.c:967: for (char t=0;t<LevelW;t++) {
	ld	c, -3 (ix)
	ld	b, -2 (ix)
	ld	-1 (ix), #0x00
00103$:
	ld	hl, #_LevelW
	ld	a, -1 (ix)
	sub	a, (hl)
	jr	NC, 00105$
;src\mytestrom.c:968: memcpy(p,q,11);
	inc	sp
	inc	sp
	push	bc
	ld	l, e
;	spillPairReg hl
;	spillPairReg hl
	ld	h, d
;	spillPairReg hl
;	spillPairReg hl
	push	de
	push	bc
	ld	e, -5 (ix)
	ld	d, -4 (ix)
	ld	bc, #0x000b
	ldir
	pop	bc
	pop	de
;src\mytestrom.c:969: p +=11;
	ld	hl, #0x000b
	add	hl, bc
	ld	c, l
	ld	b, h
;src\mytestrom.c:970: q +=24;
	ld	hl, #0x0018
	add	hl, de
	ex	de, hl
;src\mytestrom.c:967: for (char t=0;t<LevelW;t++) {
	inc	-1 (ix)
	jp	00103$
00105$:
;src\mytestrom.c:972: }
	ld	sp, ix
	pop	ix
	ret
;src\mytestrom.c:974: void myISR(void) __sdcccall(1) __naked
;	---------------------------------
; Function myISR
; ---------------------------------
_myISR::
;src\mytestrom.c:1013: __endasm;
	push	af
	xor	a,a ; set Status Register #0 for reading
	out	(#0x99),a
	ld	a,#0x8f
	out	(#0x99),a
	in	a,(#0x99) ; mimimum ISR
	ld	a,(#_cursat)
	and	a,a
	ld	a,#3
	jr	nz,setsat1
	ld	a,#1
	setsat1:
	out	(#0x99),a
	ld	a,#128+#11
	out	(#0x99),a
	pop	af
	ei
	ret
;src\mytestrom.c:1014: }
;src\mytestrom.c:1016: void myInstISR(void) __sdcccall(1) __naked
;	---------------------------------
; Function myInstISR
; ---------------------------------
_myInstISR::
;src\mytestrom.c:1018: myVDPwrite(WindowH-8,19); // indagare sul glitch !!! xxx
	ld	l, #0x13
;	spillPairReg hl
;	spillPairReg hl
	ld	a, #0xa8
	call	_myVDPwrite
;src\mytestrom.c:1034: __endasm;
	ld	hl,#0xFD9A
	ld	de,#_OldIsr
	ld	bc,#3
	ldir
	di
	ld	a,#0xC3
	ld	(#0xFD9A+#0),a
	ld	hl,#_myISR
	ld	(#0xFD9A+#1),hl
	ei
	ret
;src\mytestrom.c:1035: }
;src\mytestrom.c:1037: void myISRrestore(void) __sdcccall(1) __naked
;	---------------------------------
; Function myISRrestore
; ---------------------------------
_myISRrestore::
;src\mytestrom.c:1039: RG0SAV &= 0xEF;
	ld	a, (_RG0SAV+0)
	and	a, #0xef
	ld	(_RG0SAV+0), a
;src\mytestrom.c:1040: myVDPwrite(RG0SAV,0);
	ld	l, #0x00
;	spillPairReg hl
;	spillPairReg hl
	ld	a, (_RG0SAV+0)
	call	_myVDPwrite
;src\mytestrom.c:1050: __endasm;
	ld	hl,#_OldIsr
	ld	de,#0xFD9A
	ld	bc,#3
	di
	ldir
	ei
	ret
;src\mytestrom.c:1051: }
;src\mytestrom.c:1055: unsigned char myCheckkbd(unsigned char nrow) __sdcccall(1) __naked
;	---------------------------------
; Function myCheckkbd
; ---------------------------------
_myCheckkbd::
;src\mytestrom.c:1081: __endasm;
;
;
;
;
;
;
;
;
;
;
;	checkkbd:
	ld	e,a
	di
	in	a,(#0xaa)
	and	a,#0b11110000 ; upper 4 bits contain info to preserve
	or	a,e
	out	(#0xaa),a
	in	a,(#0xa9)
	ld	l,a
	ei
	ret
;src\mytestrom.c:1082: }
;src\mytestrom.c:1093: void ObjectsInit(void) {
;	---------------------------------
; Function ObjectsInit
; ---------------------------------
_ObjectsInit::
	push	ix
	ld	ix,#0
	add	ix,sp
	push	af
	dec	sp
;src\mytestrom.c:1095: for (t=0;t<MaxObjNum;t++)
	ld	-1 (ix), #0x00
00102$:
;src\mytestrom.c:1097: object[t].x = t*LevelW*4/MaxObjNum + WindowW/2;
	ld	c, -1 (ix)
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, bc
	ex	de, hl
	ld	hl, #_object
	add	hl, de
	ex	de, hl
	inc	sp
	inc	sp
	push	de
	push	de
	ld	a, (#_LevelW + 0)
	ld	e, a
	ld	h, -1 (ix)
;	spillPairReg hl
;	spillPairReg hl
	ld	l, #0x00
	ld	d, l
	ld	b, #0x08
00125$:
	add	hl, hl
	jr	NC, 00126$
	add	hl, de
00126$:
	djnz	00125$
	pop	de
	add	hl, hl
	add	hl, hl
;	spillPairReg hl
;	spillPairReg hl
	ld	c,l
	ld	b,h
;	spillPairReg hl
;	spillPairReg hl
	bit	7, b
	jr	Z, 00106$
	ld	hl, #0x0007
	add	hl, bc
00106$:
	sra	h
	rr	l
	sra	h
	rr	l
	sra	h
	rr	l
	ld	a, l
	ld	b, h
	add	a, #0x78
	ld	c, a
	jr	NC, 00127$
	inc	b
00127$:
	pop	hl
	push	hl
	ld	(hl), c
	inc	hl
	ld	(hl), b
;src\mytestrom.c:1098: object[t].y = (t & 1) ? LevelH*16-32 : 0;
	ld	l, e
;	spillPairReg hl
;	spillPairReg hl
	ld	h, d
;	spillPairReg hl
;	spillPairReg hl
	inc	hl
	inc	hl
	bit	0, -1 (ix)
	jr	Z, 00107$
	ld	a, (_LevelH+0)
	ld	c, #0x00
	add	a, a
	rl	c
	add	a, a
	rl	c
	add	a, a
	rl	c
	add	a, a
	rl	c
	add	a, #0xe0
	ld	b, a
	ld	a, c
	adc	a, #0xff
	jp	00108$
00107$:
	xor	a, a
	ld	b, a
00108$:
	ld	(hl), b
	inc	hl
	ld	(hl), a
;src\mytestrom.c:1099: object[t].frame = t;
	ld	hl, #0x0005
	add	hl, de
	ld	a, -1 (ix)
	ld	(hl), a
;src\mytestrom.c:1100: object[t].status = 255;		// 0 is for inactive
	ld	hl, #0x0006
	add	hl, de
	ld	(hl), #0xff
;src\mytestrom.c:1095: for (t=0;t<MaxObjNum;t++)
	inc	-1 (ix)
	ld	a, -1 (ix)
	sub	a, #0x08
	jp	C, 00102$
;src\mytestrom.c:1102: }
	ld	sp, ix
	pop	ix
	ret
;src\mytestrom.c:1110: void ObjectstoVRAM(int MapX) __sdcccall(1)
;	---------------------------------
; Function ObjectstoVRAM
; ---------------------------------
_ObjectstoVRAM::
	push	ix
	ld	ix,#0
	add	ix,sp
	push	af
	push	af
	dec	sp
	ld	-3 (ix), l
	ld	-2 (ix), h
;src\mytestrom.c:1119: if (cursat==0) {
	ld	a, (_cursat+0)
	or	a, a
	jr	NZ, 00102$
;src\mytestrom.c:1120: SetVramW(0,0xFA00);	// sat 0
	ld	de, #0xfa00
	xor	a, a
	call	_SetVramW
;src\mytestrom.c:1121: q = &object[MaxObjNum-1];
	ld	de, #_object+49
	jp	00122$
00102$:
;src\mytestrom.c:1124: SetVramW(1,0xFA00);	// sat 1		
	ld	de, #0xfa00
	ld	a, #0x01
	call	_SetVramW
;src\mytestrom.c:1125: q = &object[0];		
	ld	de, #_object
;src\mytestrom.c:1129: for (t=0; t<MaxObjNum; t++) 
00122$:
	ld	-1 (ix), #0x00
00113$:
;src\mytestrom.c:1132: u = q->x-(((unsigned int) MapX) & 0xFFF0);
	ld	l, e
	ld	h, d
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	ld	a, -3 (ix)
	ld	l, -2 (ix)
;	spillPairReg hl
;	spillPairReg hl
	and	a, #0xf0
	ld	-5 (ix), a
	ld	-4 (ix), l
	ld	hl, #_u
	ld	a, c
	sub	a, -5 (ix)
	ld	(hl), a
	ld	a, b
	sbc	a, -4 (ix)
	inc	hl
	ld	(hl), a
;src\mytestrom.c:1133: y = q->y;
	ld	c, e
	ld	b, d
	inc	bc
	inc	bc
	ld	a, (bc)
	ld	(_y+0), a
;src\mytestrom.c:1134: x = u;
	ld	a, (_u+0)
	ld	(_x+0), a
;src\mytestrom.c:1135: v = q->frame<<4;
	push	de
	pop	iy
	ld	a, 5 (iy)
	add	a, a
	add	a, a
	add	a, a
	add	a, a
	ld	(_v+0), a
;src\mytestrom.c:1137: if (q->status && (q->x - MapX >= 0) && (q->x - MapX < WindowW-16)) 
	push	de
	pop	iy
	ld	a, 6 (iy)
	or	a, a
	jp	Z, 00105$
	ld	l, e
	ld	h, d
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	ld	a, c
	sub	a, -3 (ix)
	ld	c, a
	ld	a, b
	sbc	a, -2 (ix)
	ld	b, a
	bit	7, b
	jp	NZ, 00105$
	ld	a, c
	sub	a, #0xe0
	ld	a, b
	sbc	a, #0x00
	jp	NC, 00105$
;src\mytestrom.c:1169: __endasm;
	ld	c,#0x98
	.rept	2
	ld	hl,#_y
	outi
	outi
	outi
	ld	a, (_v)
	out	(#0x98),a
	add	a, #4
	ld	(_v),a
	.endm
	ld	hl,#_y
	ld	a,#16
	add	a,(hl)
	ld	(hl),a
	outi
	outi
	outi
	ld	a,(_v)
	out	(#0x98),a
	add	a, #4
	ld	(_v),a
	ld	hl,#_y
	outi
	outi
	outi
	nop
	out	(#0x98),a
	jp	00106$
00105$:
;src\mytestrom.c:1178: __endasm;
	ld	a,#217
	.rept	16
	out	(#0x98),a
	nop
	.endm
00106$:
;src\mytestrom.c:1180: if (cursat==0) {
	ld	a, (_cursat+0)
	or	a, a
	jr	NZ, 00110$
;src\mytestrom.c:1181: q--;
	ld	a, e
	add	a, #0xf9
	ld	e, a
	ld	a, d
	adc	a, #0xff
	ld	d, a
	jp	00114$
00110$:
;src\mytestrom.c:1184: q++;
	ld	hl, #0x0007
	add	hl, de
	ex	de, hl
00114$:
;src\mytestrom.c:1129: for (t=0; t<MaxObjNum; t++) 
	inc	-1 (ix)
	ld	a, -1 (ix)
	sub	a, #0x08
	jp	C, 00113$
;src\mytestrom.c:1190: }
	ld	sp, ix
	pop	ix
	ret
;src\mytestrom.c:1194: void UpdateColor(char plane,char frame,char nsat) __sdcccall(1){
;	---------------------------------
; Function UpdateColor
; ---------------------------------
_UpdateColor::
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	e, a
;src\mytestrom.c:1197: SetVramW(1,0xF800+plane*16);
	ld	d, #0x00
	ex	de, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ex	de, hl
	ld	a, d
	add	a, #0xf8
	ld	d, a
;src\mytestrom.c:1196: if (nsat)
	ld	a, 4 (ix)
	or	a, a
	jr	Z, 00102$
;src\mytestrom.c:1197: SetVramW(1,0xF800+plane*16);
	push	hl
	ld	a, #0x01
	call	_SetVramW
	pop	hl
	jp	00103$
00102$:
;src\mytestrom.c:1199: SetVramW(0,0xF800+plane*16);
	push	hl
	xor	a, a
	call	_SetVramW
	pop	hl
00103$:
;src\mytestrom.c:1201: VramWrite(((unsigned int) &sprite_colors) + frame*64,64);
	ld	bc, #_sprite_colors
	ld	h, #0x00
;	spillPairReg hl
;	spillPairReg hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, bc
	ld	de, #0x0040
	call	_VramWrite
;src\mytestrom.c:1202: }
	pop	ix
	pop	hl
	inc	sp
	jp	(hl)
;src\mytestrom.c:1204: void UpdateFrame(char plane,char frame,char nsat) __sdcccall(1){
;	---------------------------------
; Function UpdateFrame
; ---------------------------------
_UpdateFrame::
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	e, a
;src\mytestrom.c:1207: SetVramW(0,0xF000+plane*32);
	ld	d, #0x00
	ex	de, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ex	de, hl
;src\mytestrom.c:1206: if (nsat)
	ld	a, 4 (ix)
	or	a, a
	jr	Z, 00102$
;src\mytestrom.c:1207: SetVramW(0,0xF000+plane*32);
	ld	a, d
	add	a, #0xf0
	ld	d, a
	push	hl
	xor	a, a
	call	_SetVramW
	pop	hl
	jp	00103$
00102$:
;src\mytestrom.c:1209: SetVramW(0,0xF000+32*32+plane*32);
	ld	a, d
	add	a, #0xf4
	ld	d, a
	push	hl
	xor	a, a
	call	_SetVramW
	pop	hl
00103$:
;src\mytestrom.c:1211: VramWrite(((unsigned int) &sprite_patterns) + frame*128,128);
	ld	bc, #_sprite_patterns
	xor	a, a
	rr	a
	ld	h, l
	rr	h
	rra
	ld	l, a
	add	hl, bc
	ld	de, #0x0080
	call	_VramWrite
;src\mytestrom.c:1212: }
	pop	ix
	pop	hl
	inc	sp
	jp	(hl)
;src\mytestrom.c:1267: void SprtInit(void) __sdcccall(1) 
;	---------------------------------
; Function SprtInit
; ---------------------------------
_SprtInit::
;src\mytestrom.c:1271: RG1SAV |= 2;
	ld	a, (_RG1SAV+0)
	or	a, #0x02
	ld	(_RG1SAV+0), a
;src\mytestrom.c:1272: myVDPwrite(RG1SAV,1);
	ld	l, #0x01
;	spillPairReg hl
;	spillPairReg hl
	ld	a, (_RG1SAV+0)
	call	_myVDPwrite
;src\mytestrom.c:1273: RG8SAV |= 32;
	ld	a, (_RG8SAV+0)
	or	a, #0x20
	ld	(_RG8SAV+0), a
;src\mytestrom.c:1274: myVDPwrite(RG8SAV,8);
	ld	l, #0x08
;	spillPairReg hl
;	spillPairReg hl
	ld	a, (_RG8SAV+0)
	call	_myVDPwrite
;src\mytestrom.c:1284: __endasm;
	ld	a,#b_sprite_colors
	ld	(#0x9000),a
	ld	(#_curr_bank),a
	inc	a
	ld	(#0xb000),a
;src\mytestrom.c:1287: SetVramW(0,0xF800);					// sat 0
	ld	de, #0xf800
	xor	a, a
	call	_SetVramW
;src\mytestrom.c:1288: for (t=0; t<MaxObjNum; t++) {
	ld	c, #0x00
00104$:
;src\mytestrom.c:1289: VramWrite(((unsigned int) &sprite_colors) + (MaxObjNum-1-t)*64,64);
	ld	de, #_sprite_colors
	ld	l, c
;	spillPairReg hl
;	spillPairReg hl
	ld	h, #0x00
;	spillPairReg hl
;	spillPairReg hl
	ld	a, #0x07
	sub	a, l
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	sbc	a, a
	sub	a, h
	ld	h, a
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, de
	push	bc
	ld	de, #0x0040
	call	_VramWrite
	pop	bc
;src\mytestrom.c:1288: for (t=0; t<MaxObjNum; t++) {
	inc	c
	ld	a, c
	sub	a, #0x08
	jr	C, 00104$
;src\mytestrom.c:1292: SetVramW(1,0xF800);					// sat 1
	ld	de, #0xf800
	ld	a, #0x01
	call	_SetVramW
;src\mytestrom.c:1293: for (t=0; t<MaxObjNum; t++) {
	ld	c, #0x00
00106$:
;src\mytestrom.c:1294: VramWrite(((unsigned int) &sprite_colors) + t*64,64);
	ld	de, #_sprite_colors
	ld	l, c
;	spillPairReg hl
;	spillPairReg hl
	ld	h, #0x00
;	spillPairReg hl
;	spillPairReg hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, de
	push	bc
	ld	de, #0x0040
	call	_VramWrite
	pop	bc
;src\mytestrom.c:1293: for (t=0; t<MaxObjNum; t++) {
	inc	c
	ld	a, c
	sub	a, #0x08
	jr	C, 00106$
;src\mytestrom.c:1304: __endasm;
	ld	a,#b_sprite_patterns
	ld	(#0x9000),a
	ld	(#_curr_bank),a
	inc	a
	ld	(#0xb000),a
;src\mytestrom.c:1306: SetVramW(0,0xF000);					// sprite patterns	
	ld	de, #0xf000
	xor	a, a
	call	_SetVramW
;src\mytestrom.c:1307: for (t=0; t<MaxObjNum; t++) {	
	ld	c, #0x00
00108$:
;src\mytestrom.c:1308: VramWrite(((unsigned int) &sprite_patterns) + t*128,128);
	ld	de, #_sprite_patterns
	ld	l, c
;	spillPairReg hl
;	spillPairReg hl
;	spillPairReg hl
;	spillPairReg hl
	xor	a, a
	ld	h, a
	rr	h
	ld	h, l
	rr	h
	rra
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	add	hl, de
	push	bc
	ld	de, #0x0080
	call	_VramWrite
	pop	bc
;src\mytestrom.c:1307: for (t=0; t<MaxObjNum; t++) {	
	inc	c
	ld	a, c
	sub	a, #0x08
	jr	C, 00108$
;src\mytestrom.c:1310: }
	ret
;src\mytestrom.c:1312: void VramWrite(unsigned int addr, unsigned int len) __sdcccall(1) __naked
;	---------------------------------
; Function VramWrite
; ---------------------------------
_VramWrite::
;src\mytestrom.c:1325: __endasm;		
	ld	c,#0x98
	095$:
	outi
	dec	de
	ld	a,d
	or	a,e
	jr	nz,095$
	ret
;src\mytestrom.c:1326: }
;src\mytestrom.c:1328: void SetVramW(char page, unsigned int addr) __sdcccall(1) __naked {
;	---------------------------------
; Function SetVramW
; ---------------------------------
_SetVramW::
;src\mytestrom.c:1353: __endasm;		
;	Set VDP address counter to write from address ADE (17-bit)
;	Enables the interrupts
	ex	de,hl
	rlc	h
	rla
	rlc	h
	rla
	srl	h
	srl	h
	di
	out	(#0x99),a
	ld	a,#0x8E
	out	(#0x99),a
	ld	a,l
	out	(#0x99),a
	ld	a,h
	or	a,#0x40
	ei
	out	(#0x99),a
	ex	de,hl
	ret
;src\mytestrom.c:1354: }
;src\mytestrom.c:1357: void chgmod(char c) __sdcccall(1) __naked {
;	---------------------------------
; Function chgmod
; ---------------------------------
_chgmod::
;src\mytestrom.c:1361: __endasm;
	jp	0x005f
;src\mytestrom.c:1362: }
;src\mytestrom.c:1364: void putch(char c) __sdcccall(1) __naked {
;	---------------------------------
; Function putch
; ---------------------------------
_putch::
;src\mytestrom.c:1368: __endasm;
	jp	0x00a2
;src\mytestrom.c:1369: }
;src\mytestrom.c:1372: void	myHMMV( unsigned int DX, unsigned int DY, unsigned int NX, unsigned int NY, char COL) __sdcccall(0) __naked
;	---------------------------------
; Function myHMMV
; ---------------------------------
_myHMMV::
;src\mytestrom.c:1435: __endasm;
;****************************************************************
;	HMMV painting the rectangle in high speed Eric
;	void HMMV( unsigned int XS, unsigned int YS, unsigned int DX, unsigned int DY, char COL);
;
;****************************************************************
	push	ix
	ld	ix,#0
	add	ix,sp
	di
	call	_myVDPready
	ld	a,#36
	out	(#0x99),a
	ld	a,#128+#17
	out	(#0x99),a ;R#17 := 36
	ld	c,#0x9b
	ld	a,4(ix) ;
	out	(c),a ; R36 DX low byte
	ld	a,5(ix) ;
	out	(c),a ; R37 DX high byte
	ld	a,6(ix) ;
	out	(c),a ; R38 DY low byte
	ld	a,7(ix) ;
	out	(c),a ; R39 DY high byte
	ld	a,8(ix) ;
	out	(c),a ; R40 NX low byte
	ld	a,9(ix) ;
	out	(c),a ; R41 NX high byte
	ld	a,10(ix) ;
	out	(c),a ; R42 NY low byte
	ld	a,11(ix) ;
	out	(c),a ; R43 NY high byte
	ld	a,12(ix) ;
	out	(c),a ; R44 COL low byte
	xor	a ;
	out	(c),a ; R45 DIX and DIY ! DX and DY express in incremental direction ! internal VRAM
	or	#0b11000000 ;HMMV command
	out	(c),a ;do it
	ei
	pop	ix
	ret
;src\mytestrom.c:1436: }
;src\mytestrom.c:1439: void SetDisplayPage(char n) __z88dk_fastcall
;	---------------------------------
; Function SetDisplayPage
; ---------------------------------
_SetDisplayPage::
;src\mytestrom.c:1466: __endasm;
;----------------------------
;	void SetDisplayPage(char n)
;	MSX2 Show the specified VRAM Page at Screen
;
	ld	a,l
	rla
	rla
	rla
	rla
	rla
	and	#0x7F
	or	#0x1F
	ld	b,a
	ld	a,#2
	or	#0x80
	ld	c, #0x99 ;; VDP port #1 (unsupport "MSX1 adapter")
	di
	out	(c), b ;; out data
	out	(c), a ;; out VDP register number
	ei
	ld	(#0xFAF5),a ;; DPPAGE
;src\mytestrom.c:1467: }
	ret
;src\mytestrom.c:1472: void VDPlineSwitch(void) 
;	---------------------------------
; Function VDPlineSwitch
; ---------------------------------
_VDPlineSwitch::
;src\mytestrom.c:1483: __endasm;
	ld	a,(#_RG9SAV)
	xor	a,#0b10000000
	ld	(#_RG9SAV),a
	ld	b,a
	ld	a,#0x89
	ld	c, #0x99 ;; VDP port #1 (unsupport "MSX1 adapter")
	out	(c), b ;; out data
	out	(c), a ;; out VDP register number
;src\mytestrom.c:1484: }
	ret
;src\mytestrom.c:1486: void VDP60Hz(void)
;	---------------------------------
; Function VDP60Hz
; ---------------------------------
_VDP60Hz::
;src\mytestrom.c:1497: __endasm;
	ld	a,(#_RG9SAV)
	and	#0b11111101
	ld	(#_RG9SAV),a
	ld	b,a
	ld	a,#0x89
	ld	c, #0x99 ;; VDP port #1 (unsupport "MSX1 adapter")
	out	(c), b ;; out data
	out	(c), a ;; out VDP register number
;src\mytestrom.c:1498: }
	ret
;src\mytestrom.c:1500: void PrintChar(char c) 
;	---------------------------------
; Function PrintChar
; ---------------------------------
_PrintChar::
;src\mytestrom.c:1511: __endasm;
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	a,4(ix)
	call	#0xA2 ; Bios CHPUT
	ei
	pop	ix
;src\mytestrom.c:1512: }
	ret
;src\mytestrom.c:1541: void Print(char* text)
;	---------------------------------
; Function Print
; ---------------------------------
_Print::
;src\mytestrom.c:1545: while(*(text)) 
00104$:
	ld	a, (hl)
	or	a, a
	ret	Z
;src\mytestrom.c:1547: character=*(text++);
	inc	hl
;src\mytestrom.c:1548: if (character=='\n')
	ld	c, a
	sub	a, #0x0a
	jr	NZ, 00102$
;src\mytestrom.c:1550: PrintChar(10); //LF (Line Feed)
	push	hl
	ld	a, #0x0a
	call	_PrintChar
	ld	a, #0x0d
	call	_PrintChar
	pop	hl
	jp	00104$
00102$:
;src\mytestrom.c:1553: PrintChar(character);
	push	hl
	ld	a, c
	call	_PrintChar
	pop	hl
;src\mytestrom.c:1556: }
	jp	00104$
;src\mytestrom.c:1559: void     myVDPready(void) __naked															// Check if MSX2 VDP is ready (Internal Use)
;	---------------------------------
; Function myVDPready
; ---------------------------------
_myVDPready::
;src\mytestrom.c:1575: __endasm; 
	    checkIfReady:
	ld	a,#2
	out	(#0x99),a ; wait till previous VDP execution is over (CE)
	ld	a,#128+#15
	out	(#0x99),a
	in	a,(#0x99)
	rra	; check CE (bit#0)
	ld	a, #0
	out	(#0x99),a
	ld	a,#128+#15
	out	(#0x99),a
	jp	c, checkIfReady
	ret
;src\mytestrom.c:1576: }
	.area _BANK0
	.area _INITIALIZER
	.area _CABS (ABS)
