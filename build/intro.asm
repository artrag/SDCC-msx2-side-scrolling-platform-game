;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.2.0 #13081 (MINGW64)
;--------------------------------------------------------
	.module intro
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _gradient_tiles
	.globl _gradient_colrs
	.globl _title_sat
	.globl _title_sprites
	.globl _fire_palette
	.globl _SetVramW14
	.globl _VramWrite
	.globl _myCheckkbd
	.globl _myFT_wait
	.globl _myVDPwrite
	.globl _chgmod
	.globl _g_RandomSeed8
	.globl _buffer
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
	.globl b_intro
	.globl _intro
	.globl _FireIteration
	.globl _MyRand
	.globl _SetPalette
	.globl _RestorePalette
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
_buffer::
	.ds 768
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _INITIALIZED
_g_RandomSeed8::
	.ds 2
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
	.area _BANK8
;src\intro.c:19: void intro(void) __banked  
;	---------------------------------
; Function intro
; ---------------------------------
	b_intro	= 8
_intro::
	push	ix
	ld	ix,#0
	add	ix,sp
	push	af
	dec	sp
;src\intro.c:21: chgmod(4);						  		// Init Screen 4
	ld	a, #0x04
	call	_chgmod
;src\intro.c:22: myVDPwrite(0,7);						// borders	
	ld	l, #0x07
;	spillPairReg hl
;	spillPairReg hl
	xor	a, a
	call	_myVDPwrite
;src\intro.c:23: RG1SAV |= 2;
	ld	a, (_RG1SAV+0)
	or	a, #0x02
	ld	(_RG1SAV+0), a
;src\intro.c:24: myVDPwrite(RG1SAV,1);
	ld	l, #0x01
;	spillPairReg hl
;	spillPairReg hl
	ld	a, (_RG1SAV+0)
	call	_myVDPwrite
;src\intro.c:25: RG8SAV |= 32;
	ld	a, (_RG8SAV+0)
	or	a, #0x20
	ld	(_RG8SAV+0), a
;src\intro.c:26: myVDPwrite(RG8SAV,8);
	ld	l, #0x08
;	spillPairReg hl
;	spillPairReg hl
	ld	a, (_RG8SAV+0)
	call	_myVDPwrite
;src\intro.c:28: SetPalette(fire_palette);
	ld	hl, #_fire_palette
	call	_SetPalette
;src\intro.c:32: SetVramW14(0x3800);
	ld	hl, #0x3800
	call	_SetVramW14
;src\intro.c:33: VramWrite((unsigned int)title_sprites,32*32);
	ld	de, #0x0400
	ld	hl, #_title_sprites
	call	_VramWrite
;src\intro.c:35: SetVramW14(0x1C00);
	ld	hl, #0x1c00
	call	_SetVramW14
;src\intro.c:36: for (int i=32*16;i>0;i--) {
	ld	bc, #0x0200
00112$:
	xor	a, a
	cp	a, c
	sbc	a, b
	jp	PO, 00229$
	xor	a, #0x80
00229$:
	jp	P, 00101$
;src\intro.c:37: Port98 = 7;
	ld	a, #0x07
	out	(_Port98), a
;src\intro.c:36: for (int i=32*16;i>0;i--) {
	dec	bc
	jp	00112$
00101$:
;src\intro.c:40: SetVramW14(0x1E00);
	ld	hl, #0x1e00
	call	_SetVramW14
;src\intro.c:41: VramWrite((unsigned int)title_sat,32*4);
	ld	de, #0x0080
	ld	hl, #_title_sat
	call	_VramWrite
;src\intro.c:44: SetVramW14(0);
	ld	hl, #0x0000
	call	_SetVramW14
;src\intro.c:45: for (char j=0;j<16*3;j++) {
	ld	c, #0x00
00115$:
	ld	a, c
	sub	a, #0x30
	jr	NC, 00102$
;src\intro.c:46: VramWrite((unsigned int)gradient_tiles,8*16);
	push	bc
	ld	de, #0x0080
	ld	hl, #_gradient_tiles
	call	_VramWrite
	pop	bc
;src\intro.c:45: for (char j=0;j<16*3;j++) {
	inc	c
	jp	00115$
00102$:
;src\intro.c:49: for (char s=0;s<3;s++) {
	ld	bc, #_gradient_colrs+0
	ld	-3 (ix), #0x00
00127$:
	ld	a, -3 (ix)
	sub	a, #0x03
	jp	NC, 00106$
;src\intro.c:50: SetVramW14(0x2000+0x800*s);
	ld	a, -3 (ix)
	add	a, a
	add	a, a
	add	a, a
	ld	d, a
	ld	e, #0x00
	ld	hl, #0x2000
	add	hl, de
	call	_SetVramW14
;src\intro.c:51: for (int i=64*8;i>0;i--) {
	ld	de, #0x0200
00118$:
	xor	a, a
	cp	a, e
	sbc	a, d
	jp	PO, 00230$
	xor	a, #0x80
00230$:
	jp	P, 00103$
;src\intro.c:52: Port98 = 0;
	ld	a, #0x00
	out	(_Port98), a
;src\intro.c:51: for (int i=64*8;i>0;i--) {
	dec	de
	jp	00118$
00103$:
;src\intro.c:54: for (int i=0;i<64;i++) {
	xor	a, a
	ld	-2 (ix), a
	ld	-1 (ix), a
00124$:
	ld	a, -2 (ix)
	sub	a, #0x40
	ld	a, -1 (ix)
	rla
	ccf
	rra
	sbc	a, #0x80
	jr	NC, 00128$
;src\intro.c:55: char k = i/4;
	ld	e, -2 (ix)
	ld	d, -1 (ix)
	bit	7, -1 (ix)
	jr	Z, 00134$
	ld	e, -2 (ix)
	ld	d, -1 (ix)
	inc	de
	inc	de
	inc	de
00134$:
	sra	d
	rr	e
	sra	d
	rr	e
	ld	a, e
;src\intro.c:56: for (char j=0;j<8;j++) {
	add	a, c
	ld	e, a
	ld	a, #0x00
	adc	a, b
	ld	d, a
	xor	a, a
00121$:
	cp	a, #0x08
	jr	NC, 00125$
;src\intro.c:57: Port98 = gradient_colrs[k];
	push	af
	ld	a, (de)
	out	(_Port98), a
	pop	af
;src\intro.c:56: for (char j=0;j<8;j++) {
	inc	a
	jp	00121$
00125$:
;src\intro.c:54: for (int i=0;i<64;i++) {
	inc	-2 (ix)
	jr	NZ, 00124$
	inc	-1 (ix)
	jp	00124$
00128$:
;src\intro.c:49: for (char s=0;s<3;s++) {
	inc	-3 (ix)
	jp	00127$
00106$:
;src\intro.c:62: memset(&buffer[0],0,24*32);
	ld	hl, #_buffer
	ld	(hl), #0x00
	ld	e, l
	ld	d, h
	inc	de
	ld	bc, #0x02ff
	ldir
;src\intro.c:63: memset(&buffer[23*32],127,32);
	ld	hl, #(_buffer + 736)
	ld	b, #0x10
00232$:
	ld	(hl), #0x7f
	inc	hl
	ld	(hl), #0x7f
	inc	hl
	djnz	00232$
;src\intro.c:65: while (myCheckkbd(7)==0xFF)	{
00107$:
	ld	a, #0x07
	call	_myCheckkbd
	inc	a
	jr	NZ, 00109$
;src\intro.c:66: FireIteration(buffer);
	ld	hl, #_buffer
	call	_FireIteration
	jp	00107$
00109$:
;src\intro.c:68: memset(&buffer[23*32],0,32);	
	ld	hl, #(_buffer + 736)
	ld	b, #0x10
00236$:
	ld	(hl), #0x00
	inc	hl
	ld	(hl), #0x00
	inc	hl
	djnz	00236$
;src\intro.c:70: for (char t = 20;t>0;t--)  {
	ld	c, #0x14
00130$:
	ld	a, c
	or	a, a
	jr	Z, 00110$
;src\intro.c:71: FireIteration(buffer);
	push	bc
	ld	hl, #_buffer
	call	_FireIteration
	pop	bc
;src\intro.c:70: for (char t = 20;t>0;t--)  {
	dec	c
	jp	00130$
00110$:
;src\intro.c:75: RestorePalette();
	call	_RestorePalette
;src\intro.c:76: }
	ld	sp, ix
	pop	ix
	ret
;src\intro.c:78: void FireIteration(char *b) __sdcccall(1)
;	---------------------------------
; Function FireIteration
; ---------------------------------
_FireIteration::
	push	ix
	ld	ix,#0
	add	ix,sp
	push	af
	push	af
	push	af
	ld	c, l
	ld	b, h
;src\intro.c:80: char *v = &b[23*32];
	ld	hl, #0x02e0
	add	hl, bc
;src\intro.c:81: for (char j=23;j>0;j--) 
	ld	-2 (ix), #0x17
00110$:
	ld	a, -2 (ix)
	or	a, a
	jr	Z, 00105$
;src\intro.c:83: for (char i=32;i>0;i--)
	ex	de, hl
	ld	-1 (ix), #0x20
00107$:
	ld	a, -1 (ix)
	or	a, a
	jr	Z, 00104$
;src\intro.c:85: char w = (MyRand()&15);
	push	de
	call	_MyRand
	pop	de
	and	a, #0x0f
	ld	-6 (ix), a
;src\intro.c:86: if (*v>w) 
	ld	a, (de)
	ld	-5 (ix), a
;src\intro.c:87: *(v-32-2+(w&3)) = *v-w;
	ld	a, e
	add	a, #0xde
	ld	-4 (ix), a
	ld	a, d
	adc	a, #0xff
	ld	-3 (ix), a
	ld	a, -6 (ix)
;	spillPairReg hl
;	spillPairReg hl
	and	a, #0x03
	ld	h, #0x00
;	spillPairReg hl
;	spillPairReg hl
	add	a, -4 (ix)
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	ld	a, h
	adc	a, -3 (ix)
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
;src\intro.c:86: if (*v>w) 
	ld	a, -6 (ix)
	sub	a, -5 (ix)
	jr	NC, 00102$
;src\intro.c:87: *(v-32-2+(w&3)) = *v-w;
	ld	a, -5 (ix)
	sub	a, -6 (ix)
	ld	(hl), a
	jp	00103$
00102$:
;src\intro.c:89: *(v-32-2+(w&3)) = 0;
	ld	(hl), #0x00
00103$:
;src\intro.c:90: v++;
	inc	de
;src\intro.c:83: for (char i=32;i>0;i--)
	dec	-1 (ix)
	jp	00107$
00104$:
;src\intro.c:92: v += -64;
	ld	hl, #0xffc0
	add	hl, de
;src\intro.c:81: for (char j=23;j>0;j--) 
	dec	-2 (ix)
	jp	00110$
00105$:
;src\intro.c:94: myFT_wait(1);
	push	bc
	ld	a, #0x01
	call	_myFT_wait
	pop	bc
;src\intro.c:95: SetVramW14(0x1800);
	ld	hl, #0x1800
	call	_SetVramW14
;src\intro.c:96: VramWrite((unsigned int)&b[0],3*256);		
	ld	de, #0x0300
	ld	l, c
;	spillPairReg hl
;	spillPairReg hl
	ld	h, b
;	spillPairReg hl
;	spillPairReg hl
	call	_VramWrite
;src\intro.c:97: }
	ld	sp, ix
	pop	ix
	ret
;src\intro.c:102: char MyRand(void) __naked  __preserves_regs(b,c,iyl,iyh)
;	---------------------------------
; Function MyRand
; ---------------------------------
_MyRand::
;src\intro.c:116: __endasm;
	ld	hl, (_g_RandomSeed8)
	ld	a, r
	ld	d, a
	ld	e, a
	add	hl, de
	xor	l
	add	a
	xor	h
	ld	l, a
	ld	(_g_RandomSeed8), hl
	ret
;src\intro.c:117: }
;src\intro.c:121: void SetPalette(char *palette) __sdcccall(1)
;	---------------------------------
; Function SetPalette
; ---------------------------------
_SetPalette::
;src\intro.c:150: __endasm;
	ld	bc,#0x1000 ; 16 colours
	SPcoLoop:
	ld	a,c
	di
	out	(#0x99),a ; colour Nr.
	ld	a, #128+#16
	out	(#0x99),a
	ld	a,(hl) ; red
	sla	a
	sla	a
	sla	a
	sla	a ; bits 4-7
	inc	hl
	inc	hl
	or	a,(hl) ; blue bits 0-3
	out	(#0x9A),a
	dec	hl
	ld	a,(hl) ; green bits 0-3
	inc	hl
	inc	hl
	ei
	out	(#0x9A),a
	inc	c
	djnz	SPcoLoop
	ret
;src\intro.c:151: }
	ret
;src\intro.c:156: void RestorePalette(void) __naked
;	---------------------------------
; Function RestorePalette
; ---------------------------------
_RestorePalette::
;src\intro.c:182: __endasm;
	ld	hl, #__msx_palette
	jp	_SetPalette
;---------------------------------------------------
;	colour R G B bright 0..7 Name
;---------------------------------------------------
	__msx_palette:
	.db	#0,#0,#0 ;transparent
	.db	#0,#0,#0 ;black
	.db	#1,#6,#1 ;bright green
	.db	#3,#7,#3 ;light green
	.db	#1,#1,#7 ;deep blue
	.db	#2,#3,#7 ;bright blue
	.db	#5,#1,#1 ;deep red
	.db	#2,#6,#7 ;light blue
	.db	#7,#1,#1 ;bright red
	.db	#7,#3,#3 ;light red
	.db	#6,#6,#1 ;bright yellow
	.db	#6,#6,#3 ;pale yellow
	.db	#1,#4,#1 ;deep green
	.db	#6,#2,#5 ;purple
	.db	#5,#5,#5 ;grey
	.db	#7,#7,#7 ;white
;src\intro.c:183: }	
	.area _BANK8
_fire_palette:
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x02	; 2
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x03	; 3
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x04	; 4
	.db #0x01	; 1
	.db #0x00	; 0
	.db #0x05	; 5
	.db #0x02	; 2
	.db #0x00	; 0
	.db #0x06	; 6
	.db #0x02	; 2
	.db #0x00	; 0
	.db #0x06	; 6
	.db #0x03	; 3
	.db #0x00	; 0
	.db #0x06	; 6
	.db #0x03	; 3
	.db #0x00	; 0
	.db #0x06	; 6
	.db #0x04	; 4
	.db #0x00	; 0
	.db #0x06	; 6
	.db #0x04	; 4
	.db #0x00	; 0
	.db #0x05	; 5
	.db #0x04	; 4
	.db #0x00	; 0
	.db #0x05	; 5
	.db #0x05	; 5
	.db #0x01	; 1
	.db #0x05	; 5
	.db #0x05	; 5
	.db #0x01	; 1
	.db #0x06	; 6
	.db #0x06	; 6
	.db #0x04	; 4
	.db #0x07	; 7
	.db #0x07	; 7
	.db #0x07	; 7
_title_sprites:
	.db #0x3f	; 63
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x3f	; 63
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xe0	; 224
	.db #0xe0	; 224
	.db #0xe0	; 224
	.db #0xe0	; 224
	.db #0xe0	; 224
	.db #0xe1	; 225
	.db #0xe1	; 225
	.db #0xe1	; 225
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xe0	; 224
	.db #0xf0	; 240
	.db #0xf0	; 240
	.db #0xf0	; 240
	.db #0xf0	; 240
	.db #0xf0	; 240
	.db #0xf0	; 240
	.db #0xf8	; 248
	.db #0xf8	; 248
	.db #0xf8	; 248
	.db #0xf8	; 248
	.db #0xf8	; 248
	.db #0xf8	; 248
	.db #0xf8	; 248
	.db #0xf8	; 248
	.db #0xf8	; 248
	.db #0xf8	; 248
	.db #0xf8	; 248
	.db #0x70	; 112	'p'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x3f	; 63
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x3f	; 63
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0xfe	; 254
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xfe	; 254
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x03	; 3
	.db #0x07	; 7
	.db #0x07	; 7
	.db #0x07	; 7
	.db #0x03	; 3
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x3f	; 63
	.db #0x3f	; 63
	.db #0x3f	; 63
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x01	; 1
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x80	; 128
	.db #0xe0	; 224
	.db #0xf8	; 248
	.db #0xfc	; 252
	.db #0xfe	; 254
	.db #0xfe	; 254
	.db #0x3f	; 63
	.db #0x1f	; 31
	.db #0x1f	; 31
	.db #0x1f	; 31
	.db #0x3f	; 63
	.db #0x7e	; 126
	.db #0xfe	; 254
	.db #0xfc	; 252
	.db #0xf8	; 248
	.db #0xe0	; 224
	.db #0x07	; 7
	.db #0x0f	; 15
	.db #0x0f	; 15
	.db #0x0f	; 15
	.db #0x07	; 7
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x7c	; 124
	.db #0x7c	; 124
	.db #0x7c	; 124
	.db #0x7c	; 124
	.db #0x7c	; 124
	.db #0x7c	; 124
	.db #0x7c	; 124
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x1c	; 28
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0xfe	; 254
	.db #0xfe	; 254
	.db #0xfe	; 254
	.db #0xfe	; 254
	.db #0xfe	; 254
	.db #0xfe	; 254
	.db #0xfe	; 254
	.db #0xfe	; 254
	.db #0xfe	; 254
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x1c	; 28
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x3f	; 63
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x3f	; 63
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xe1	; 225
	.db #0xe1	; 225
	.db #0xe1	; 225
	.db #0xe0	; 224
	.db #0xe0	; 224
	.db #0xe0	; 224
	.db #0xe0	; 224
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xf0	; 240
	.db #0xf0	; 240
	.db #0xf0	; 240
	.db #0xf0	; 240
	.db #0xf0	; 240
	.db #0xe0	; 224
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xe0	; 224
	.db #0xf0	; 240
	.db #0xf0	; 240
	.db #0xf0	; 240
	.db #0xe0	; 224
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x3f	; 63
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x3f	; 63
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xfe	; 254
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xfe	; 254
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x03	; 3
	.db #0x07	; 7
	.db #0x07	; 7
	.db #0x07	; 7
	.db #0x03	; 3
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x3f	; 63
	.db #0x3f	; 63
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x07	; 7
	.db #0x03	; 3
	.db #0x01	; 1
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xf0	; 240
	.db #0xf8	; 248
	.db #0xf8	; 248
	.db #0xf8	; 248
	.db #0xf0	; 240
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x80	; 128
	.db #0xc0	; 192
	.db #0xe0	; 224
	.db #0xf0	; 240
	.db #0xf8	; 248
	.db #0xfc	; 252
	.db #0x7c	; 124
	.db #0x3e	; 62
	.db #0x3f	; 63
	.db #0x1f	; 31
	.db #0x0f	; 15
	.db #0x0f	; 15
	.db #0x07	; 7
	.db #0x03	; 3
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xe7	; 231
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xe7	; 231
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x7f	; 127
	.db #0x7c	; 124
	.db #0x7c	; 124
	.db #0x7c	; 124
	.db #0x7c	; 124
	.db #0x7c	; 124
	.db #0x7c	; 124
	.db #0x7c	; 124
	.db #0x7c	; 124
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xfe	; 254
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x1c	; 28
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x0e	; 14
	.db #0x1f	; 31
	.db #0x1f	; 31
	.db #0x1f	; 31
	.db #0x1f	; 31
	.db #0x1f	; 31
	.db #0x1f	; 31
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x01	; 1
	.db #0x01	; 1
	.db #0x01	; 1
	.db #0x01	; 1
	.db #0x01	; 1
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x01	; 1
	.db #0x07	; 7
	.db #0x1f	; 31
	.db #0x3f	; 63
	.db #0x7f	; 127
	.db #0xff	; 255
	.db #0xf8	; 248
	.db #0xf0	; 240
	.db #0xf0	; 240
	.db #0xf0	; 240
	.db #0xf8	; 248
	.db #0xf8	; 248
	.db #0xfc	; 252
	.db #0xfe	; 254
	.db #0x7e	; 126
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xf0	; 240
	.db #0xfe	; 254
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xfe	; 254
	.db #0x7c	; 124
	.db #0x10	; 16
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x87	; 135
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xe0	; 224
	.db #0x3f	; 63
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x3f	; 63
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0xfe	; 254
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xfe	; 254
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x01	; 1
	.db #0x01	; 1
	.db #0x01	; 1
	.db #0x01	; 1
	.db #0x01	; 1
	.db #0x01	; 1
	.db #0x00	; 0
	.db #0x03	; 3
	.db #0x07	; 7
	.db #0x1f	; 31
	.db #0x1f	; 31
	.db #0x3f	; 63
	.db #0x7f	; 127
	.db #0x7e	; 126
	.db #0xfc	; 252
	.db #0xf8	; 248
	.db #0xf8	; 248
	.db #0xf0	; 240
	.db #0xf0	; 240
	.db #0xf0	; 240
	.db #0xf0	; 240
	.db #0xf0	; 240
	.db #0x7f	; 127
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xc0	; 192
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x87	; 135
	.db #0xef	; 239
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x3f	; 63
	.db #0x0f	; 15
	.db #0x0f	; 15
	.db #0x0f	; 15
	.db #0x07	; 7
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x07	; 7
	.db #0x8f	; 143
	.db #0x8f	; 143
	.db #0x8f	; 143
	.db #0x87	; 135
	.db #0x80	; 128
	.db #0x80	; 128
	.db #0x80	; 128
	.db #0x80	; 128
	.db #0x80	; 128
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x7c	; 124
	.db #0x7c	; 124
	.db #0x7c	; 124
	.db #0x7c	; 124
	.db #0x7c	; 124
	.db #0x7c	; 124
	.db #0x7c	; 124
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x1c	; 28
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0xfe	; 254
	.db #0xfe	; 254
	.db #0xfe	; 254
	.db #0xfe	; 254
	.db #0xfe	; 254
	.db #0xfe	; 254
	.db #0xfe	; 254
	.db #0xfe	; 254
	.db #0xfe	; 254
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x1c	; 28
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x03	; 3
	.db #0x07	; 7
	.db #0x07	; 7
	.db #0x0f	; 15
	.db #0x0f	; 15
	.db #0x0f	; 15
	.db #0x0f	; 15
	.db #0x0f	; 15
	.db #0x0f	; 15
	.db #0x07	; 7
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xe7	; 231
	.db #0xc3	; 195
	.db #0x81	; 129
	.db #0x81	; 129
	.db #0x80	; 128
	.db #0x80	; 128
	.db #0xe0	; 224
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x3f	; 63
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xc7	; 199
	.db #0xef	; 239
	.db #0xef	; 239
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x7f	; 127
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xf7	; 247
	.db #0xc0	; 192
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xf0	; 240
	.db #0xf0	; 240
	.db #0xf0	; 240
	.db #0xe0	; 224
	.db #0x80	; 128
	.db #0x80	; 128
	.db #0x80	; 128
	.db #0x00	; 0
	.db #0xe0	; 224
	.db #0xf0	; 240
	.db #0xf0	; 240
	.db #0xf0	; 240
	.db #0xe0	; 224
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x3f	; 63
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x3f	; 63
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xfe	; 254
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xfe	; 254
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x01	; 1
	.db #0x01	; 1
	.db #0x01	; 1
	.db #0x01	; 1
	.db #0x01	; 1
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xf0	; 240
	.db #0xf0	; 240
	.db #0xf0	; 240
	.db #0xf0	; 240
	.db #0xf8	; 248
	.db #0xf8	; 248
	.db #0xfc	; 252
	.db #0xfe	; 254
	.db #0x7f	; 127
	.db #0x3f	; 63
	.db #0x1f	; 31
	.db #0x0f	; 15
	.db #0x07	; 7
	.db #0x01	; 1
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xc0	; 192
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x3f	; 63
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x03	; 3
	.db #0x07	; 7
	.db #0x0f	; 15
	.db #0x3f	; 63
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xfe	; 254
	.db #0xf8	; 248
	.db #0xc0	; 192
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x80	; 128
	.db #0xc0	; 192
	.db #0xc0	; 192
	.db #0xc7	; 199
	.db #0x8f	; 143
	.db #0x0f	; 15
	.db #0x0f	; 15
	.db #0x07	; 7
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x7f	; 127
	.db #0x7c	; 124
	.db #0x7c	; 124
	.db #0x7c	; 124
	.db #0x7c	; 124
	.db #0x7c	; 124
	.db #0x7c	; 124
	.db #0x7c	; 124
	.db #0x7c	; 124
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xfe	; 254
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x1c	; 28
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x0e	; 14
	.db #0x1f	; 31
	.db #0x1f	; 31
	.db #0x1f	; 31
	.db #0x1f	; 31
	.db #0x1f	; 31
	.db #0x1f	; 31
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
_title_sat:
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x09	; 9
	.db #0x0f	; 15
	.db #0x10	; 16
	.db #0x24	; 36
	.db #0x09	; 9
	.db #0x1f	; 31
	.db #0x20	; 32
	.db #0x48	; 72	'H'
	.db #0x09	; 9
	.db #0x2f	; 47
	.db #0x30	; 48	'0'
	.db #0x6c	; 108	'l'
	.db #0x09	; 9
	.db #0xff	; 255
	.db #0x10	; 16
	.db #0x04	; 4
	.db #0x09	; 9
	.db #0x0f	; 15
	.db #0x00	; 0
	.db #0x20	; 32
	.db #0x09	; 9
	.db #0x1f	; 31
	.db #0x30	; 48	'0'
	.db #0x4c	; 76	'L'
	.db #0x09	; 9
	.db #0x2f	; 47
	.db #0x20	; 32
	.db #0x68	; 104	'h'
	.db #0x09	; 9
	.db #0xff	; 255
	.db #0x20	; 32
	.db #0x08	; 8
	.db #0x09	; 9
	.db #0x0f	; 15
	.db #0x30	; 48	'0'
	.db #0x2c	; 44
	.db #0x09	; 9
	.db #0x1f	; 31
	.db #0x00	; 0
	.db #0x40	; 64
	.db #0x09	; 9
	.db #0x2f	; 47
	.db #0x10	; 16
	.db #0x64	; 100	'd'
	.db #0x09	; 9
	.db #0xff	; 255
	.db #0x30	; 48	'0'
	.db #0x0c	; 12
	.db #0x09	; 9
	.db #0x0f	; 15
	.db #0x20	; 32
	.db #0x28	; 40
	.db #0x09	; 9
	.db #0x1f	; 31
	.db #0x10	; 16
	.db #0x44	; 68	'D'
	.db #0x09	; 9
	.db #0x2f	; 47
	.db #0x00	; 0
	.db #0x60	; 96
	.db #0x09	; 9
	.db #0xff	; 255
	.db #0x40	; 64
	.db #0x10	; 16
	.db #0x09	; 9
	.db #0x0f	; 15
	.db #0x50	; 80	'P'
	.db #0x34	; 52	'4'
	.db #0x09	; 9
	.db #0x1f	; 31
	.db #0x60	; 96
	.db #0x58	; 88	'X'
	.db #0x09	; 9
	.db #0x2f	; 47
	.db #0x70	; 112	'p'
	.db #0x7c	; 124
	.db #0x09	; 9
	.db #0xff	; 255
	.db #0x50	; 80	'P'
	.db #0x14	; 20
	.db #0x09	; 9
	.db #0x0f	; 15
	.db #0x40	; 64
	.db #0x30	; 48	'0'
	.db #0x09	; 9
	.db #0x1f	; 31
	.db #0x70	; 112	'p'
	.db #0x5c	; 92
	.db #0x09	; 9
	.db #0x2f	; 47
	.db #0x60	; 96
	.db #0x78	; 120	'x'
	.db #0x09	; 9
	.db #0xff	; 255
	.db #0x60	; 96
	.db #0x18	; 24
	.db #0x09	; 9
	.db #0x0f	; 15
	.db #0x70	; 112	'p'
	.db #0x3c	; 60
	.db #0x09	; 9
	.db #0x1f	; 31
	.db #0x40	; 64
	.db #0x50	; 80	'P'
	.db #0x09	; 9
	.db #0x2f	; 47
	.db #0x50	; 80	'P'
	.db #0x74	; 116	't'
	.db #0x09	; 9
	.db #0xff	; 255
	.db #0x70	; 112	'p'
	.db #0x1c	; 28
	.db #0x09	; 9
	.db #0x0f	; 15
	.db #0x60	; 96
	.db #0x38	; 56	'8'
	.db #0x09	; 9
	.db #0x1f	; 31
	.db #0x50	; 80	'P'
	.db #0x54	; 84	'T'
	.db #0x09	; 9
	.db #0x2f	; 47
	.db #0x40	; 64
	.db #0x70	; 112	'p'
	.db #0x09	; 9
_gradient_colrs:
	.db #0x10	; 16
	.db #0x21	; 33
	.db #0x32	; 50	'2'
	.db #0x43	; 67	'C'
	.db #0x54	; 84	'T'
	.db #0x65	; 101	'e'
	.db #0x76	; 118	'v'
	.db #0x87	; 135
	.db #0x98	; 152
	.db #0xa9	; 169
	.db #0xba	; 186
	.db #0xcb	; 203
	.db #0xdc	; 220
	.db #0xed	; 237
	.db #0xfe	; 254
	.db #0xff	; 255
_gradient_tiles:
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x88	; 136
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x88	; 136
	.db #0x00	; 0
	.db #0x22	; 34
	.db #0x00	; 0
	.db #0x88	; 136
	.db #0x00	; 0
	.db #0x22	; 34
	.db #0x00	; 0
	.db #0x88	; 136
	.db #0x00	; 0
	.db #0x22	; 34
	.db #0x00	; 0
	.db #0xaa	; 170
	.db #0x00	; 0
	.db #0x22	; 34
	.db #0x00	; 0
	.db #0xaa	; 170
	.db #0x00	; 0
	.db #0xaa	; 170
	.db #0x00	; 0
	.db #0xaa	; 170
	.db #0x00	; 0
	.db #0xaa	; 170
	.db #0x00	; 0
	.db #0xaa	; 170
	.db #0x00	; 0
	.db #0xaa	; 170
	.db #0x44	; 68	'D'
	.db #0xaa	; 170
	.db #0x00	; 0
	.db #0xaa	; 170
	.db #0x44	; 68	'D'
	.db #0xaa	; 170
	.db #0x11	; 17
	.db #0xaa	; 170
	.db #0x44	; 68	'D'
	.db #0xaa	; 170
	.db #0x11	; 17
	.db #0xaa	; 170
	.db #0x45	; 69	'E'
	.db #0xaa	; 170
	.db #0x11	; 17
	.db #0xaa	; 170
	.db #0x55	; 85	'U'
	.db #0xaa	; 170
	.db #0x11	; 17
	.db #0xaa	; 170
	.db #0x55	; 85	'U'
	.db #0xaa	; 170
	.db #0x55	; 85	'U'
	.db #0xaa	; 170
	.db #0x55	; 85	'U'
	.db #0xaa	; 170
	.db #0x55	; 85	'U'
	.db #0xaa	; 170
	.db #0x55	; 85	'U'
	.db #0xaa	; 170
	.db #0x55	; 85	'U'
	.db #0xaa	; 170
	.db #0x55	; 85	'U'
	.db #0xee	; 238
	.db #0x55	; 85	'U'
	.db #0xaa	; 170
	.db #0x55	; 85	'U'
	.db #0xee	; 238
	.db #0x55	; 85	'U'
	.db #0xbb	; 187
	.db #0x55	; 85	'U'
	.db #0xee	; 238
	.db #0x55	; 85	'U'
	.db #0xbb	; 187
	.db #0x55	; 85	'U'
	.db #0xee	; 238
	.db #0x55	; 85	'U'
	.db #0xbb	; 187
	.db #0x55	; 85	'U'
	.db #0xff	; 255
	.db #0x55	; 85	'U'
	.db #0xbb	; 187
	.db #0x55	; 85	'U'
	.db #0xff	; 255
	.db #0x55	; 85	'U'
	.db #0xff	; 255
	.db #0x55	; 85	'U'
	.db #0xff	; 255
	.db #0x55	; 85	'U'
	.db #0xff	; 255
	.db #0x55	; 85	'U'
	.db #0xff	; 255
	.db #0x55	; 85	'U'
	.db #0xff	; 255
	.db #0xdd	; 221
	.db #0xff	; 255
	.db #0x55	; 85	'U'
	.db #0xff	; 255
	.db #0xdd	; 221
	.db #0xff	; 255
	.db #0x77	; 119	'w'
	.db #0xff	; 255
	.db #0xdd	; 221
	.db #0xff	; 255
	.db #0x77	; 119	'w'
	.db #0xff	; 255
	.db #0xdd	; 221
	.db #0xff	; 255
	.db #0x77	; 119	'w'
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x77	; 119	'w'
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.area _INITIALIZER
__xinit__g_RandomSeed8:
	.dw #0x0005
	.area _CABS (ABS)
