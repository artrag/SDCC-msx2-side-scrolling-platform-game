
_FireIteration::
	ld	bc, #0x02e0
	add	hl, bc
	ld	c, #0x17
00110$:
	ex	de, hl
	ld	b,#0x20
00107$:
	push	de
	call	_MyRand
	pop	de
	and	a, #0x0f
	ld	iyh, a
	ld	a, (de)
	ld	iyl, a
	ld hl,#0xffde
	add hl,de
	ld	a, iyh
	and	a, #0x03
	add	a, l
	ld	l, a
	ld	a, 0
	adc	a, h
	ld	h, a
	ld	a, iyh
	sub	a,iyl
	jr	NC, 00102$
	neg
	ld	(hl), a
	jp	00103$
00102$:
	ld	(hl), #0x00
00103$:
	inc	de
	djnz 00107$
	ld	hl, #0xffc0
	add	hl, de
	dec	c
	jp	nz,00110$
	ret
	