;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.2.0 #13081 (MINGW64)
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
	.globl b_intro
	.globl _intro
	.globl b_DataLevelMap
	.globl _DataLevelMap
	.globl _sprite_colors
	.globl _sprite_patterns
	.globl _v
	.globl _x
	.globl _y
	.globl _u
	.globl _object
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
	.globl _SetVramR14
	.globl _SetVramW14
	.globl _SetVramW
	.globl _SetVramR
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
;src\mytestrom.c:65: intro();
	ld	e, #b_intro
	ld	hl, #_intro
	call	___sdcc_bcall_ehl
;src\mytestrom.c:67: rd = ReadMSXtype();					  	// Read MSX Type
	ld	a, (#0x002d)
;src\mytestrom.c:69: if (rd==0) FT_errorHandler(3,"msx 1 ");	// If MSX1 got to Error !
	or	a, a
	jr	NZ, 00102$
	ld	de, #___str_0
	ld	a, #0x03
	call	_FT_errorHandler
00102$:
;src\mytestrom.c:71: MyLoadMap(1,LevelMap);					// load level map 256x11 arranged by columns
	ld	de, #_LevelMap
	ld	a, #0x01
	call	_MyLoadMap
;src\mytestrom.c:73: chgmod(8);						  		// Init Screen 8
	ld	a, #0x08
	call	_chgmod
;src\mytestrom.c:75: ObjectsInit();							// initialize logical object 
	call	_ObjectsInit
;src\mytestrom.c:77: myVDPwrite(0,7);						// borders	
	ld	l, #0x07
;	spillPairReg hl
;	spillPairReg hl
	xor	a, a
	call	_myVDPwrite
;src\mytestrom.c:78: VDPlineSwitch();						// 192 lines
	call	_VDPlineSwitch
;src\mytestrom.c:79: VDP60Hz();
	call	_VDP60Hz
;src\mytestrom.c:81: myHMMV(0,0,256,512, 0);					// Clear all VRAM  by Byte 0 (Black)
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
;src\mytestrom.c:83: myVDPready();							// wait for command completion
	call	_myVDPready
;src\/myheader.h:8: __endasm; 
	ei
;src\mytestrom.c:86: SprtInit();								// initialize sprites in VRAM 
	call	_SprtInit
;src\mytestrom.c:87: ObjectstoVRAM(0);	
	ld	hl, #0x0000
	call	_ObjectstoVRAM
;src\mytestrom.c:89: myInstISR();							// install a fake ISR to cut the overhead
	call	_myInstISR
;src\mytestrom.c:91: page = 0;
	ld	hl, #_page
	ld	(hl), #0x00
;src\mytestrom.c:92: mySetAdjust(0,8);						// same as myVDPwrite((0-8) & 15,18);	
	ld	l, #0x08
;	spillPairReg hl
;	spillPairReg hl
	xor	a, a
	call	_mySetAdjust
;src\mytestrom.c:94: for (WLevelx = 0;WLevelx<0+WindowW;) {
	ld	hl, #0x0000
	ld	(_WLevelx), hl
00117$:
;src\mytestrom.c:95: myFT_wait(1);		
	ld	a, #0x01
	call	_myFT_wait
;src\mytestrom.c:96: NewLine(WLevelx,0,WLevelx);WLevelx++;
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
;src\mytestrom.c:97: NewLine(WindowW-WLevelx,0,WindowW-WLevelx);	WLevelx++;
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
;src\mytestrom.c:98: NewLine(WLevelx,0,WLevelx);WLevelx++;
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
;src\mytestrom.c:99: NewLine(WindowW-WLevelx,0,WindowW-WLevelx);	WLevelx++;
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
;src\mytestrom.c:94: for (WLevelx = 0;WLevelx<0+WindowW;) {
	ld	(_WLevelx), hl
	ld	de, #0x00f0
	cp	a, a
	sbc	hl, de
	jr	C, 00117$
;src\mytestrom.c:102: WLevelx = 0;	
	ld	hl, #0x0000
	ld	(_WLevelx), hl
;src\mytestrom.c:104: MyBorder.ny = WindowH;
	ld	l, #0xb0
	ld	((_MyBorder + 10)), hl
;src\mytestrom.c:105: MyBorder.col = 0;
	ld	hl, #(_MyBorder + 12)
	ld	(hl), #0x00
;src\mytestrom.c:106: MyBorder.param = 0;
	ld	hl, #(_MyBorder + 13)
	ld	(hl), #0x00
;src\mytestrom.c:107: MyBorder.cmd = opHMMV;
	ld	hl, #(_MyBorder + 14)
	ld	(hl), #0xc0
;src\mytestrom.c:109: MyCommand.ny = WindowH;
	ld	hl, #0x00b0
	ld	((_MyCommand + 10)), hl
;src\mytestrom.c:110: MyCommand.col = 0;
	ld	hl, #(_MyCommand + 12)
	ld	(hl), #0x00
;src\mytestrom.c:111: MyCommand.param = 0;
	ld	hl, #(_MyCommand + 13)
	ld	(hl), #0x00
;src\mytestrom.c:112: MyCommand.cmd = opHMMM;
	ld	hl, #(_MyCommand + 14)
	ld	(hl), #0xd0
;src\mytestrom.c:115: while (myCheckkbd(7)==0xFF)
00112$:
	ld	a, #0x07
	call	_myCheckkbd
	inc	a
	jp	NZ,00114$
;src\mytestrom.c:117: WaitLineInt();			// wait for line 176-16
	call	_WaitLineInt
;src\mytestrom.c:118: cursat^=1;				// swap sat 0 and sat 1
	ld	a, (_cursat+0)
	xor	a, #0x01
	ld	(_cursat+0), a
;src\mytestrom.c:120: if ((myCheckkbd(8)==0x7F) && (WLevelx<16*(LevelW-15)))  { 
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
;src\mytestrom.c:121: WLevelx++;
	ld	hl, (_WLevelx)
	inc	hl
;src\mytestrom.c:122: ObjectstoVRAM(WLevelx);			
	ld	(_WLevelx), hl
	call	_ObjectstoVRAM
;src\mytestrom.c:123: ScrollRight(WLevelx & 15);
	ld	a, (_WLevelx+0)
	and	a, #0x0f
	call	_ScrollRight
	jp	00112$
00109$:
;src\mytestrom.c:125: else if ((myCheckkbd(8)==0xEF) && (WLevelx>0)) { 
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
;src\mytestrom.c:126: WLevelx--;
	ld	hl, (_WLevelx)
	dec	hl
;src\mytestrom.c:127: ObjectstoVRAM(WLevelx);			
	ld	(_WLevelx), hl
	call	_ObjectstoVRAM
;src\mytestrom.c:128: ScrollLeft(WLevelx & 15);
	ld	a, (_WLevelx+0)
	and	a, #0x0f
	call	_ScrollLeft
	jp	00112$
00105$:
;src\mytestrom.c:131: ObjectstoVRAM(WLevelx);						
	ld	hl, (_WLevelx)
	call	_ObjectstoVRAM
	jp	00112$
00114$:
;src\mytestrom.c:135: myISRrestore();
	call	_myISRrestore
;src\mytestrom.c:136: chgmod(0);
	xor	a, a
	call	_chgmod
;src\mytestrom.c:137: Reboot(0);
	rst	#0
;src\mytestrom.c:138: }
	ret
___str_0:
	.ascii "msx 1 "
	.db 0x00
;src\mytestrom.c:140: void ScrollRight(char step) __sdcccall(1) 
;	---------------------------------
; Function ScrollRight
; ---------------------------------
_ScrollRight::
	ld	c, a
;src\mytestrom.c:143: myVDPwrite((step-8) & 15,18);			
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
;src\mytestrom.c:144: switch (step) {
	ld	a, c
	or	a, a
	jr	NZ, 00102$
;src\mytestrom.c:146: page ^=1;							// case 0
	ld	a, (_page+0)
	xor	a, #0x01
	ld	(_page+0), a
;src\mytestrom.c:147: SetDisplayPage(page);
	push	bc
	ld	a, (_page+0)
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	call	_SetDisplayPage
	pop	bc
;src\mytestrom.c:148: MyBorder.dx = 240;
	ld	hl, #0x00f0
	ld	((_MyBorder + 4)), hl
;src\mytestrom.c:149: MyBorder.nx = 15;
	ld	l, #0x0f
	ld	((_MyBorder + 8)), hl
;src\mytestrom.c:150: MyBorder.dy = 256*page;
	ld	a, (_page+0)
	ld	d, a
	ld	e, #0x00
	ld	((_MyBorder + 6)), de
;src\mytestrom.c:151: myfVDP(&MyBorder);
	push	bc
	ld	hl, #_MyBorder
	call	_myfVDP
	pop	bc
;src\mytestrom.c:152: BorderLinesR(WindowW-1,page, WLevelx+WindowW-1);		
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
;src\mytestrom.c:153: break;
	jp	00103$
;src\mytestrom.c:154: default:								// case 1-15
00102$:
;src\mytestrom.c:155: MyCommand.sx = 16*step;
	ld	e, c
	ld	d, #0x00
	ex	de, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ex	de, hl
	ld	(_MyCommand), de
;src\mytestrom.c:156: MyCommand.dx = MyCommand.sx - 16;;
	ld	hl, (#_MyCommand + 0)
	ld	de, #0xfff0
	add	hl, de
	ld	e, l
	ld	a,h
	ld	d,a
	ld	((_MyCommand + 4)), de
;src\mytestrom.c:157: MyCommand.sy = 256*page;
	ld	a, (_page+0)
	ld	d, a
	ld	e, #0x00
	ld	((_MyCommand + 2)), de
;src\mytestrom.c:158: MyCommand.dy = MyCommand.sy ^ 256;
	ld	de, (#(_MyCommand + 2) + 0)
	ld	a, d
	xor	a, #0x01
	ld	d, a
	ld	((_MyCommand + 6)), de
;src\mytestrom.c:159: MyCommand.nx = 16;
	ld	hl, #0x0010
	ld	((_MyCommand + 8)), hl
;src\mytestrom.c:160: myfVDP(&MyCommand);		
	push	bc
	ld	hl, #_MyCommand
	call	_myfVDP
	pop	bc
;src\mytestrom.c:161: BorderLinesR(step+WindowW-1,page,WLevelx+WindowW-1);
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
;src\mytestrom.c:163: }
00103$:
;src\mytestrom.c:164: if (step==15) PatchPlotOneTile(step+WindowW-1-16,page^1,WLevelx+WindowW-1);		
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
;src\mytestrom.c:165: }
	ret
;src\mytestrom.c:167: void ScrollLeft(char step) __sdcccall(1)
;	---------------------------------
; Function ScrollLeft
; ---------------------------------
_ScrollLeft::
;src\mytestrom.c:170: myVDPwrite((step-8) & 15,18);	
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
;src\mytestrom.c:171: switch (step) {
	ld	a, c
	sub	a, #0x0f
	jr	NZ, 00102$
;src\mytestrom.c:173: page ^=1;					
	ld	a, (_page+0)
	xor	a, #0x01
	ld	(_page+0), a
;src\mytestrom.c:174: SetDisplayPage(page);				// case 15
	push	bc
	ld	a, (_page+0)
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	call	_SetDisplayPage
	pop	bc
;src\mytestrom.c:175: MyBorder.dx = 0;	
	ld	hl, #0x0000
	ld	((_MyBorder + 4)), hl
;src\mytestrom.c:176: MyBorder.nx = 15;
	ld	l, #0x0f
	ld	((_MyBorder + 8)), hl
;src\mytestrom.c:177: MyBorder.dy = 256*page;
	ld	a, (_page+0)
	ld	b, #0x00
	ld	d, a
	ld	e, #0x00
	ld	((_MyBorder + 6)), de
;src\mytestrom.c:178: myfVDP(&MyBorder);
	push	bc
	ld	hl, #_MyBorder
	call	_myfVDP
	pop	bc
;src\mytestrom.c:179: BorderLinesL(step,page,WLevelx);		
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
;src\mytestrom.c:180: break;				
	jp	00103$
;src\mytestrom.c:181: default:								// case 14-0
00102$:
;src\mytestrom.c:182: MyCommand.sx = 16*step;
	ld	e, c
	ld	d, #0x00
	ex	de, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ex	de, hl
	ld	(_MyCommand), de
;src\mytestrom.c:183: MyCommand.dx = MyCommand.sx + 16;
	ld	de, (#_MyCommand + 0)
	ld	hl, #0x0010
	add	hl, de
	ex	de, hl
	ld	((_MyCommand + 4)), de
;src\mytestrom.c:184: MyCommand.sy = 256*page;
	ld	a, (_page+0)
	ld	b, #0x00
	ld	d, a
	ld	e, #0x00
	ld	((_MyCommand + 2)), de
;src\mytestrom.c:185: MyCommand.dy = MyCommand.sy ^ 256;		
	ld	de, (#(_MyCommand + 2) + 0)
	ld	a, d
	xor	a, #0x01
	ld	d, a
	ld	((_MyCommand + 6)), de
;src\mytestrom.c:186: MyCommand.nx = 16;						
	ld	hl, #0x0010
	ld	((_MyCommand + 8)), hl
;src\mytestrom.c:187: myfVDP(&MyCommand);					
	push	bc
	ld	hl, #_MyCommand
	call	_myfVDP
	pop	bc
;src\mytestrom.c:188: BorderLinesL(step,page,WLevelx);			
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
;src\mytestrom.c:190: }
00103$:
;src\mytestrom.c:191: if (step==0) PatchPlotOneTile(16,page^1,WLevelx);				
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
;src\mytestrom.c:192: }
	ret
;src\mytestrom.c:198: void PlotOneColumnTile(void) __sdcccall(1) 
;	---------------------------------
; Function PlotOneColumnTile
; ---------------------------------
_PlotOneColumnTile::
;src\mytestrom.c:230: __endasm;
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
;src\mytestrom.c:231: }
	ret
;src\mytestrom.c:233: void PlotOneColumnTileAndMask(void) __sdcccall(1) 
;	---------------------------------
; Function PlotOneColumnTileAndMask
; ---------------------------------
_PlotOneColumnTileAndMask::
;src\mytestrom.c:269: __endasm;
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
;src\mytestrom.c:270: }
	ret
;src\mytestrom.c:272: void BorderLinesL(unsigned char ScrnX,char page, int MapX) __sdcccall(1) __naked
;	---------------------------------
; Function BorderLinesL
; ---------------------------------
_BorderLinesL::
;src\mytestrom.c:376: __endasm;
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
;src\mytestrom.c:377: }
;src\mytestrom.c:379: void BorderLinesR(unsigned char ScrnX,char page, int MapX) __sdcccall(1) __naked
;	---------------------------------
; Function BorderLinesR
; ---------------------------------
_BorderLinesR::
;src\mytestrom.c:483: __endasm;
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
;src\mytestrom.c:484: }
;src\mytestrom.c:486: void NewLine(unsigned char ScrnX,char page, int MapX) __sdcccall(1) __naked
;	---------------------------------
; Function NewLine
; ---------------------------------
_NewLine::
;src\mytestrom.c:595: __endasm;
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
;src\mytestrom.c:596: }
;src\mytestrom.c:598: void PatchPlotOneTile(unsigned char ScrnX,char page, int MapX) __sdcccall(1) __naked
;	---------------------------------
; Function PatchPlotOneTile
; ---------------------------------
_PatchPlotOneTile::
;src\mytestrom.c:681: __endasm;
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
;src\mytestrom.c:682: }
;src\mytestrom.c:684: void 	myVDPwrite(char data, char vdpreg) __sdcccall(1) __naked
;	---------------------------------
; Function myVDPwrite
; ---------------------------------
_myVDPwrite::
;src\mytestrom.c:696: __endasm;
	di
	out	(#0x99),a
	ld	a,#128
	or	a,l
	out	(#0x99),a ;R#A := L
	ei
	ret
;src\mytestrom.c:698: }	
;src\mytestrom.c:721: void  	myfVDP(void *Address)  __sdcccall(1)  __naked
;	---------------------------------
; Function myfVDP
; ---------------------------------
_myfVDP::
;src\mytestrom.c:753: __endasm;
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
;src\mytestrom.c:754: }
;src\mytestrom.c:806: void mySetAdjust(signed char x, signed char y) __sdcccall(1)
;	---------------------------------
; Function mySetAdjust
; ---------------------------------
_mySetAdjust::
;src\mytestrom.c:808: unsigned char value = ((x-8) & 15) | (((y-8) & 15)<<4);
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
;src\mytestrom.c:809: RG18SA = value;			// Reg18 Save
	ld	iy, #_RG18SA
	ld	0 (iy), c
;src\mytestrom.c:810: myVDPwrite(value,18);
	ld	l, #0x12
;	spillPairReg hl
;	spillPairReg hl
	ld	a, c
;src\mytestrom.c:811: }
	jp	_myVDPwrite
;src\mytestrom.c:818: void myFT_wait(unsigned char cicles) __sdcccall(1) __naked {
;	---------------------------------
; Function myFT_wait
; ---------------------------------
_myFT_wait::
;src\mytestrom.c:841: __endasm;
	or	a, a
	00004$:
	ret	Z
	halt
	dec	a
	jp	00004$
;src\mytestrom.c:842: }
;src\mytestrom.c:844: void WaitLineInt(void) __sdcccall(1) __naked {
;	---------------------------------
; Function WaitLineInt
; ---------------------------------
_WaitLineInt::
;src\mytestrom.c:874: __endasm;
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
;src\mytestrom.c:875: }
;src\mytestrom.c:907: void FT_errorHandler(char n, char *name) __sdcccall(1) 
;	---------------------------------
; Function FT_errorHandler
; ---------------------------------
_FT_errorHandler::
	ld	c, a
;src\mytestrom.c:914: chgmod(0);
	push	bc
	push	de
	xor	a, a
	call	_chgmod
	pop	de
	pop	bc
;src\mytestrom.c:916: switch (n)
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
;src\mytestrom.c:918: case 1:
00101$:
;src\mytestrom.c:919: Print("\n\rFAILED: fcb_open(): ");
	push	de
	ld	hl, #___str_1
	call	_Print
	pop	de
;src\mytestrom.c:920: Print(name);
	ex	de, hl
	call	_Print
;src\mytestrom.c:921: break;
	jp	00105$
;src\mytestrom.c:923: case 2:
00102$:
;src\mytestrom.c:924: Print("\n\rFAILED: fcb_close():");
	push	de
	ld	hl, #___str_2
	call	_Print
	pop	de
;src\mytestrom.c:925: Print(name);
	ex	de, hl
	call	_Print
;src\mytestrom.c:926: break;  
	jp	00105$
;src\mytestrom.c:928: case 3:
00103$:
;src\mytestrom.c:929: Print("\n\rStop Kidding, run me on MSX2 !");
	ld	hl, #___str_3
	call	_Print
;src\mytestrom.c:930: break;
	jp	00105$
;src\mytestrom.c:932: case 4:
00104$:
;src\mytestrom.c:933: Print("\n\rUnespected end of file:");
	push	de
	ld	hl, #___str_4
	call	_Print
	pop	de
;src\mytestrom.c:934: Print(name);		  
	ex	de, hl
	call	_Print
;src\mytestrom.c:936: }
00105$:
;src\mytestrom.c:937: Reboot(0);
	rst	#0
;src\mytestrom.c:938: }
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
;src\mytestrom.c:940: void MyLoadMap(char mapnumber,unsigned char* p ) __sdcccall(1)
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
;src\mytestrom.c:942: char *q = &((char*)DataLevelMap)[2]+12*mapnumber;
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
;src\mytestrom.c:951: __endasm;	
	ld	a,#b_DataLevelMap
	ld	(#0x9000),a
	ld	(#_curr_bank),a
	inc	a
	ld	(#0xb000),a
;src\mytestrom.c:953: LevelW = ((char*)DataLevelMap)[0];
	ld	a, (bc)
	ld	(_LevelW+0), a
;src\mytestrom.c:955: LevelH = 11;
	ld	hl, #_LevelH
	ld	(hl), #0x0b
;src\mytestrom.c:957: for (char t=0;t<LevelW;t++) {
	ld	c, -3 (ix)
	ld	b, -2 (ix)
	ld	-1 (ix), #0x00
00103$:
	ld	hl, #_LevelW
	ld	a, -1 (ix)
	sub	a, (hl)
	jr	NC, 00105$
;src\mytestrom.c:958: memcpy(p,q,11);
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
;src\mytestrom.c:959: p +=11;
	ld	hl, #0x000b
	add	hl, bc
	ld	c, l
	ld	b, h
;src\mytestrom.c:960: q +=24;
	ld	hl, #0x0018
	add	hl, de
	ex	de, hl
;src\mytestrom.c:957: for (char t=0;t<LevelW;t++) {
	inc	-1 (ix)
	jp	00103$
00105$:
;src\mytestrom.c:962: }
	ld	sp, ix
	pop	ix
	ret
;src\mytestrom.c:964: void myISR(void) __sdcccall(1) __naked
;	---------------------------------
; Function myISR
; ---------------------------------
_myISR::
;src\mytestrom.c:1003: __endasm;
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
;src\mytestrom.c:1004: }
;src\mytestrom.c:1006: void myInstISR(void) __sdcccall(1) __naked
;	---------------------------------
; Function myInstISR
; ---------------------------------
_myInstISR::
;src\mytestrom.c:1008: myVDPwrite(WindowH-8,19); // indagare sul glitch !!! xxx
	ld	l, #0x13
;	spillPairReg hl
;	spillPairReg hl
	ld	a, #0xa8
	call	_myVDPwrite
;src\mytestrom.c:1024: __endasm;
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
;src\mytestrom.c:1025: }
;src\mytestrom.c:1027: void myISRrestore(void) __sdcccall(1) __naked
;	---------------------------------
; Function myISRrestore
; ---------------------------------
_myISRrestore::
;src\mytestrom.c:1029: RG0SAV &= 0xEF;
	ld	a, (_RG0SAV+0)
	and	a, #0xef
	ld	(_RG0SAV+0), a
;src\mytestrom.c:1030: myVDPwrite(RG0SAV,0);
	ld	l, #0x00
;	spillPairReg hl
;	spillPairReg hl
	ld	a, (_RG0SAV+0)
	call	_myVDPwrite
;src\mytestrom.c:1040: __endasm;
	ld	hl,#_OldIsr
	ld	de,#0xFD9A
	ld	bc,#3
	di
	ldir
	ei
	ret
;src\mytestrom.c:1041: }
;src\mytestrom.c:1045: unsigned char myCheckkbd(unsigned char nrow) __sdcccall(1) __naked
;	---------------------------------
; Function myCheckkbd
; ---------------------------------
_myCheckkbd::
;src\mytestrom.c:1071: __endasm;
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
;src\mytestrom.c:1072: }
;src\mytestrom.c:1083: void ObjectsInit(void) {
;	---------------------------------
; Function ObjectsInit
; ---------------------------------
_ObjectsInit::
	push	ix
	ld	ix,#0
	add	ix,sp
	push	af
	push	af
;src\mytestrom.c:1085: for (t=0;t<MaxObjNum;t++)
	ld	c, #0x00
00102$:
;src\mytestrom.c:1087: object[t].x = t*LevelW*4/MaxObjNum + WindowW/2;
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, bc
	ld	de, #_object
	add	hl, de
	ex	(sp), hl
	ld	a, -4 (ix)
	ld	-2 (ix), a
	ld	a, -3 (ix)
	ld	-1 (ix), a
	ld	a, (#_LevelW + 0)
	ld	e, a
	ld	h, c
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
	add	hl, hl
	add	hl, hl
	ld	b, h
	ld	e, l
	ld	d, b
	bit	7, b
	jr	Z, 00106$
	ld	a, l
	add	a, #0x07
	ld	e, a
	ld	a, b
	adc	a, #0x00
	ld	d, a
00106$:
	sra	d
	rr	e
	sra	d
	rr	e
	sra	d
	rr	e
	ld	hl, #0x0078
	add	hl, de
	ex	de, hl
	ld	l, -2 (ix)
	ld	h, -1 (ix)
	ld	(hl), e
	inc	hl
	ld	(hl), d
;src\mytestrom.c:1088: object[t].y = (t & 1) ? LevelH*16-32 : 0;
	ld	a, -4 (ix)
	add	a, #0x02
	ld	e, a
	ld	a, -3 (ix)
	adc	a, #0x00
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
	bit	0, c
	jr	Z, 00107$
	ld	a, (_LevelH+0)
	ld	b, #0x00
	add	a, a
	rl	b
	add	a, a
	rl	b
	add	a, a
	rl	b
	add	a, a
	rl	b
	add	a, #0xe0
	ld	d, a
	ld	a, b
	adc	a, #0xff
	ld	b, a
	jp	00108$
00107$:
	ld	d, #0x00
	ld	b, d
00108$:
	ld	l, e
	ld	(hl), d
	inc	hl
	ld	(hl), b
;src\mytestrom.c:1089: object[t].frame = t;
	pop	hl
	push	hl
	ld	de, #0x0005
	add	hl, de
	ld	(hl), c
;src\mytestrom.c:1090: object[t].status = 255;		// 0 is for inactive
	pop	hl
	push	hl
	ld	de, #0x0006
	add	hl, de
	ld	(hl), #0xff
;src\mytestrom.c:1085: for (t=0;t<MaxObjNum;t++)
	inc	c
	ld	a, c
	sub	a, #0x08
	jp	C, 00102$
;src\mytestrom.c:1092: }
	ld	sp, ix
	pop	ix
	ret
;src\mytestrom.c:1100: void ObjectstoVRAM(int MapX) __sdcccall(1)
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
;src\mytestrom.c:1109: if (cursat==0) {
	ld	a, (_cursat+0)
	or	a, a
	jr	NZ, 00102$
;src\mytestrom.c:1110: SetVramW(0,0xFA00);	// sat 0
	ld	de, #0xfa00
	xor	a, a
	call	_SetVramW
;src\mytestrom.c:1111: q = &object[MaxObjNum-1];
	ld	de, #_object+49
	jp	00122$
00102$:
;src\mytestrom.c:1114: SetVramW(1,0xFA00);	// sat 1		
	ld	de, #0xfa00
	ld	a, #0x01
	call	_SetVramW
;src\mytestrom.c:1115: q = &object[0];		
	ld	de, #_object
;src\mytestrom.c:1119: for (t=0; t<MaxObjNum; t++) 
00122$:
	ld	-1 (ix), #0x00
00113$:
;src\mytestrom.c:1122: u = q->x-(((unsigned int) MapX) & 0xFFF0);
	ld	l, e
	ld	h, d
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
;	spillPairReg hl
;	spillPairReg hl
;	spillPairReg hl
;	spillPairReg hl
	ld	a, -3 (ix)
	ld	h, -2 (ix)
	and	a, #0xf0
	ld	-5 (ix), a
	ld	-4 (ix), h
	ld	hl, #_u
	ld	a, c
	sub	a, -5 (ix)
	ld	(hl), a
	ld	a, b
	sbc	a, -4 (ix)
	inc	hl
	ld	(hl), a
;src\mytestrom.c:1123: y = q->y;
	ld	c, e
	ld	b, d
	inc	bc
	inc	bc
	ld	a, (bc)
	ld	(_y+0), a
;src\mytestrom.c:1124: x = u;
	ld	a, (_u+0)
	ld	(_x+0), a
;src\mytestrom.c:1125: v = q->frame<<4;
	push	de
	pop	iy
	ld	a, 5 (iy)
	add	a, a
	add	a, a
	add	a, a
	add	a, a
	ld	(_v+0), a
;src\mytestrom.c:1127: if (q->status && (q->x - MapX >= 0) && (q->x - MapX < WindowW-16)) 
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
;src\mytestrom.c:1159: __endasm;
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
;src\mytestrom.c:1168: __endasm;
	ld	a,#217
	.rept	16
	out	(#0x98),a
	nop
	.endm
00106$:
;src\mytestrom.c:1170: if (cursat==0) {
	ld	a, (_cursat+0)
	or	a, a
	jr	NZ, 00110$
;src\mytestrom.c:1171: q--;
	ld	a, e
	add	a, #0xf9
	ld	e, a
	ld	a, d
	adc	a, #0xff
	ld	d, a
	jp	00114$
00110$:
;src\mytestrom.c:1174: q++;
	ld	hl, #0x0007
	add	hl, de
	ex	de, hl
00114$:
;src\mytestrom.c:1119: for (t=0; t<MaxObjNum; t++) 
	inc	-1 (ix)
	ld	a, -1 (ix)
	sub	a, #0x08
	jp	C, 00113$
;src\mytestrom.c:1180: }
	ld	sp, ix
	pop	ix
	ret
;src\mytestrom.c:1184: void UpdateColor(char plane,char frame,char nsat) __sdcccall(1){
;	---------------------------------
; Function UpdateColor
; ---------------------------------
_UpdateColor::
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	b, a
	ld	c, l
;src\mytestrom.c:1187: SetVramW(1,0xF800+plane*16);
	ld	l, b
;	spillPairReg hl
;	spillPairReg hl
	ld	h, #0x00
;	spillPairReg hl
;	spillPairReg hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	e, l
	ld	a, h
	add	a, #0xf8
	ld	d, a
;src\mytestrom.c:1186: if (nsat)
	ld	a, 4 (ix)
	or	a, a
	jr	Z, 00102$
;src\mytestrom.c:1187: SetVramW(1,0xF800+plane*16);
	ld	a, #0x01
	call	_SetVramW
	jp	00103$
00102$:
;src\mytestrom.c:1189: SetVramW(0,0xF800+plane*16);
	xor	a, a
	call	_SetVramW
00103$:
;src\mytestrom.c:1191: VramWrite(((unsigned int) &sprite_colors) + frame*64,64);
	ld	de, #_sprite_colors
	ld	h, #0x00
;	spillPairReg hl
;	spillPairReg hl
	ld	l, c
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, de
	ld	de, #0x0040
	call	_VramWrite
;src\mytestrom.c:1192: }
	pop	ix
	pop	hl
	inc	sp
	jp	(hl)
;src\mytestrom.c:1194: void UpdateFrame(char plane,char frame,char nsat) __sdcccall(1){
;	---------------------------------
; Function UpdateFrame
; ---------------------------------
_UpdateFrame::
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	b, a
	ld	c, l
;src\mytestrom.c:1197: SetVramW(0,0xF000+plane*32);
	ld	l, b
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
	ld	e, l
;src\mytestrom.c:1196: if (nsat)
	ld	a, 4 (ix)
	or	a, a
	jr	Z, 00102$
;src\mytestrom.c:1197: SetVramW(0,0xF000+plane*32);
	ld	a, h
	add	a, #0xf0
	ld	d, a
	xor	a, a
	call	_SetVramW
	jp	00103$
00102$:
;src\mytestrom.c:1199: SetVramW(0,0xF000+32*32+plane*32);
	ld	a, h
	add	a, #0xf4
	ld	d, a
	xor	a, a
	call	_SetVramW
00103$:
;src\mytestrom.c:1201: VramWrite(((unsigned int) &sprite_patterns) + frame*128,128);
	ld	de, #_sprite_patterns
	xor	a, a
	rr	a
	ld	h, c
	rr	h
	rra
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	add	hl, de
	ld	de, #0x0080
	call	_VramWrite
;src\mytestrom.c:1202: }
	pop	ix
	pop	hl
	inc	sp
	jp	(hl)
;src\mytestrom.c:1257: void SprtInit(void) __sdcccall(1) 
;	---------------------------------
; Function SprtInit
; ---------------------------------
_SprtInit::
;src\mytestrom.c:1261: RG1SAV |= 2;
	ld	a, (_RG1SAV+0)
	or	a, #0x02
	ld	(_RG1SAV+0), a
;src\mytestrom.c:1262: myVDPwrite(RG1SAV,1);
	ld	l, #0x01
;	spillPairReg hl
;	spillPairReg hl
	ld	a, (_RG1SAV+0)
	call	_myVDPwrite
;src\mytestrom.c:1263: RG8SAV |= 32;
	ld	a, (_RG8SAV+0)
	or	a, #0x20
	ld	(_RG8SAV+0), a
;src\mytestrom.c:1264: myVDPwrite(RG8SAV,8);
	ld	l, #0x08
;	spillPairReg hl
;	spillPairReg hl
	ld	a, (_RG8SAV+0)
	call	_myVDPwrite
;src\mytestrom.c:1274: __endasm;
	ld	a,#b_sprite_colors
	ld	(#0x9000),a
	ld	(#_curr_bank),a
	inc	a
	ld	(#0xb000),a
;src\mytestrom.c:1277: SetVramW(0,0xF800);					// sat 0
	ld	de, #0xf800
	xor	a, a
	call	_SetVramW
;src\mytestrom.c:1278: for (t=0; t<MaxObjNum; t++) {
	ld	c, #0x00
00104$:
;src\mytestrom.c:1279: VramWrite(((unsigned int) &sprite_colors) + (MaxObjNum-1-t)*64,64);
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
;src\mytestrom.c:1278: for (t=0; t<MaxObjNum; t++) {
	inc	c
	ld	a, c
	sub	a, #0x08
	jr	C, 00104$
;src\mytestrom.c:1282: SetVramW(1,0xF800);					// sat 1
	ld	de, #0xf800
	ld	a, #0x01
	call	_SetVramW
;src\mytestrom.c:1283: for (t=0; t<MaxObjNum; t++) {
	ld	c, #0x00
00106$:
;src\mytestrom.c:1284: VramWrite(((unsigned int) &sprite_colors) + t*64,64);
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
;src\mytestrom.c:1283: for (t=0; t<MaxObjNum; t++) {
	inc	c
	ld	a, c
	sub	a, #0x08
	jr	C, 00106$
;src\mytestrom.c:1294: __endasm;
	ld	a,#b_sprite_patterns
	ld	(#0x9000),a
	ld	(#_curr_bank),a
	inc	a
	ld	(#0xb000),a
;src\mytestrom.c:1296: SetVramW(0,0xF000);					// sprite patterns	
	ld	de, #0xf000
	xor	a, a
	call	_SetVramW
;src\mytestrom.c:1297: for (t=0; t<MaxObjNum; t++) {	
	ld	c, #0x00
00108$:
;src\mytestrom.c:1298: VramWrite(((unsigned int) &sprite_patterns) + t*128,128);
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
;src\mytestrom.c:1297: for (t=0; t<MaxObjNum; t++) {	
	inc	c
	ld	a, c
	sub	a, #0x08
	jr	C, 00108$
;src\mytestrom.c:1300: }
	ret
;src\mytestrom.c:1302: void VramWrite(unsigned int addr, unsigned int len) __sdcccall(1) __naked
;	---------------------------------
; Function VramWrite
; ---------------------------------
_VramWrite::
;src\mytestrom.c:1315: __endasm;		
	ld	c,#0x98
	095$:
	outi
	dec	de
	ld	a,d
	or	a,e
	jr	nz,095$
	ret
;src\mytestrom.c:1316: }
;src\mytestrom.c:1318: void SetVramR14( unsigned int addr) __sdcccall(1) __naked __preserves_regs(b,c,d,e,h,l,iyl,iyh) 
;	---------------------------------
; Function SetVramR14
; ---------------------------------
_SetVramR14::
;src\mytestrom.c:1329: __endasm;		
	ld	a,l
	di
	out	(#0x99),a
	ld	a,h
	ei
	out	(#0x99),a
	ret
;src\mytestrom.c:1330: }
;src\mytestrom.c:1331: void SetVramW14( unsigned int addr) __sdcccall(1) __naked __preserves_regs(b,c,d,e,h,l,iyl,iyh) 
;	---------------------------------
; Function SetVramW14
; ---------------------------------
_SetVramW14::
;src\mytestrom.c:1343: __endasm;		
	ld	a,l
	di
	out	(#0x99),a
	ld	a,h
	or	a,#0x40
	ei
	out	(#0x99),a
	ret
;src\mytestrom.c:1344: }
;src\mytestrom.c:1345: void SetVramW(char page, unsigned int addr) __sdcccall(1) __naked __preserves_regs(b,c,h,l,iyl,iyh) 
;	---------------------------------
; Function SetVramW
; ---------------------------------
_SetVramW::
;src\mytestrom.c:1369: __endasm;		
;	Set VDP address counter to write from address ADE (17-bit)
;	Enables the interrupts
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
	ld	a,d
	or	a,#0x40
	ei
	out	(#0x99),a
	ret
;src\mytestrom.c:1370: }
;src\mytestrom.c:1373: void SetVramR(char page, unsigned int addr) __sdcccall(1) __naked __preserves_regs(b,c,h,l,iyl,iyh) 
;	---------------------------------
; Function SetVramR
; ---------------------------------
_SetVramR::
;src\mytestrom.c:1396: __endasm;		
;	Set VDP address counter to write from address ADE (17-bit)
;	Enables the interrupts
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
	ld	a,d ; set for reading
	ei
	out	(#0x99),a
	ret
;src\mytestrom.c:1397: }
;src\mytestrom.c:1399: void chgmod(char c) __sdcccall(1) __naked {
;	---------------------------------
; Function chgmod
; ---------------------------------
_chgmod::
;src\mytestrom.c:1403: __endasm;
	jp	0x005f
;src\mytestrom.c:1404: }
;src\mytestrom.c:1406: void putch(char c) __sdcccall(1) __naked {
;	---------------------------------
; Function putch
; ---------------------------------
_putch::
;src\mytestrom.c:1410: __endasm;
	jp	0x00a2
;src\mytestrom.c:1411: }
;src\mytestrom.c:1414: void	myHMMV( unsigned int DX, unsigned int DY, unsigned int NX, unsigned int NY, char COL) __sdcccall(0) __naked
;	---------------------------------
; Function myHMMV
; ---------------------------------
_myHMMV::
;src\mytestrom.c:1477: __endasm;
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
;src\mytestrom.c:1478: }
;src\mytestrom.c:1481: void SetDisplayPage(char n) __z88dk_fastcall
;	---------------------------------
; Function SetDisplayPage
; ---------------------------------
_SetDisplayPage::
;src\mytestrom.c:1508: __endasm;
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
;src\mytestrom.c:1509: }
	ret
;src\mytestrom.c:1514: void VDPlineSwitch(void) 
;	---------------------------------
; Function VDPlineSwitch
; ---------------------------------
_VDPlineSwitch::
;src\mytestrom.c:1525: __endasm;
	ld	a,(#_RG9SAV)
	xor	a,#0b10000000
	ld	(#_RG9SAV),a
	ld	b,a
	ld	a,#0x89
	ld	c, #0x99 ;; VDP port #1 (unsupport "MSX1 adapter")
	out	(c), b ;; out data
	out	(c), a ;; out VDP register number
;src\mytestrom.c:1526: }
	ret
;src\mytestrom.c:1528: void VDP60Hz(void)
;	---------------------------------
; Function VDP60Hz
; ---------------------------------
_VDP60Hz::
;src\mytestrom.c:1539: __endasm;
	ld	a,(#_RG9SAV)
	and	#0b11111101
	ld	(#_RG9SAV),a
	ld	b,a
	ld	a,#0x89
	ld	c, #0x99 ;; VDP port #1 (unsupport "MSX1 adapter")
	out	(c), b ;; out data
	out	(c), a ;; out VDP register number
;src\mytestrom.c:1540: }
	ret
;src\mytestrom.c:1542: void PrintChar(char c) 
;	---------------------------------
; Function PrintChar
; ---------------------------------
_PrintChar::
;src\mytestrom.c:1553: __endasm;
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	a,4(ix)
	call	#0xA2 ; Bios CHPUT
	ei
	pop	ix
;src\mytestrom.c:1554: }
	ret
;src\mytestrom.c:1583: void Print(char* text)
;	---------------------------------
; Function Print
; ---------------------------------
_Print::
;src\mytestrom.c:1587: while(*(text)) 
00104$:
	ld	a, (hl)
	or	a, a
	ret	Z
;src\mytestrom.c:1589: character=*(text++);
	inc	hl
;src\mytestrom.c:1590: if (character=='\n')
	ld	c, a
	sub	a, #0x0a
	jr	NZ, 00102$
;src\mytestrom.c:1592: PrintChar(10); //LF (Line Feed)
	push	hl
	ld	a, #0x0a
	call	_PrintChar
	ld	a, #0x0d
	call	_PrintChar
	pop	hl
	jp	00104$
00102$:
;src\mytestrom.c:1595: PrintChar(character);
	push	hl
	ld	a, c
	call	_PrintChar
	pop	hl
;src\mytestrom.c:1598: }
	jp	00104$
;src\mytestrom.c:1601: void     myVDPready(void) __naked															// Check if MSX2 VDP is ready (Internal Use)
;	---------------------------------
; Function myVDPready
; ---------------------------------
_myVDPready::
;src\mytestrom.c:1617: __endasm; 
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
;src\mytestrom.c:1618: }
	.area _BANK0
	.area _INITIALIZER
	.area _CABS (ABS)
