

void sprite_patterns(void) __banked __naked
{
__asm
    .incbin "data\knight_frm.bin"
__endasm;	
}

void sprite_colors(void) __banked __naked
{
__asm
    .incbin "data\knight_clr.bin"
__endasm;	
}

void DataLevelMap(void) __banked __naked 
{
    __asm
    .incbin "data\datamap.bin"
    __endasm;
}


