;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.2.0 #13049 (MINGW64)
;--------------------------------------------------------
	.module data_levels
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl b_DataLevelMap
	.globl _DataLevelMap
	.globl b_sprite_colors
	.globl _sprite_colors
	.globl b_sprite_patterns
	.globl _sprite_patterns
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
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
	.area _BANK6
;src\data_levels.c:3: void sprite_patterns(void) __banked __naked
;	---------------------------------
; Function sprite_patterns
; ---------------------------------
	b_sprite_patterns	= 6
_sprite_patterns::
;src\data_levels.c:7: __endasm;	
	.incbin	"data\knight_frm.bin"
;src\data_levels.c:8: }
;src\data_levels.c:10: void sprite_colors(void) __banked __naked
;	---------------------------------
; Function sprite_colors
; ---------------------------------
	b_sprite_colors	= 6
_sprite_colors::
;src\data_levels.c:14: __endasm;	
	.incbin	"data\knight_clr.bin"
;src\data_levels.c:15: }
;src\data_levels.c:17: void DataLevelMap(void) __banked __naked 
;	---------------------------------
; Function DataLevelMap
; ---------------------------------
	b_DataLevelMap	= 6
_DataLevelMap::
;src\data_levels.c:21: __endasm;
	.incbin	"data\datamap.bin"
;src\data_levels.c:22: }
	.area _BANK6
	.area _INITIALIZER
	.area _CABS (ABS)
