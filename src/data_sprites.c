

void sprite_patterns(void) __banked __naked
{
__asm
    .incbin "data\solider16x32_frm.bin"
    .incbin "data\solider32x32_frm.bin"
    .incbin "data\solider48x16_frm.bin"
__endasm;	
}

void sprite_colors(void) __banked __naked
{
__asm
    .incbin "data\solider16x32_clr.bin"
    .incbin "data\solider32x32_clr.bin"
    .incbin "data\solider48x16_clr.bin"
__endasm;	
}


