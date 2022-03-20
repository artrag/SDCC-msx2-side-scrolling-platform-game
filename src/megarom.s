.globl _main
.globl l__DATA
.globl s__DATA
.globl l__INITIALIZER
.globl s__INITIALIZED
.globl s__INITIALIZER

.area _BANK0
.area _BANK2
.area _BANK4
.area _BANK6
.area _BANK8
.area _BANK10
.area _BANK12
.area _BANK14
.area _BANK16
.area _BANK18
.area _BANK20
.area _BANK22
.area _BANK24
.area _BANK26
.area _BANK28
.area _BANK30
.area _BANK32
.area _BANK34
.area _BANK36
.area _BANK38
.area _BANK40
.area _BANK42
.area _BANK44
.area _BANK46
.area _BANK48
.area _BANK50
.area _BANK52
.area _BANK54
.area _BANK56
.area _BANK58
.area _BANK60
.area _BANK62


.area _HEADER (ABS)

.globl init

;; megarom header
.org 0x4000
.db  0x41
.db  0x42
.dw  init
.dw  0x0000
.dw  0x0000
.dw  0x0000
.dw  0x0000
.dw  0x0000
.dw  0x0000

init:
        ld   sp,(0xfc4a) 	; Stack at the top of memory.
        call gsinit 		; Initialise global variables
        call megarom
        call _main
        call #0x0000; call CHKRAM

megarom::
        ;; locate 32k
        call #0x00138
        rrca
        rrca
        and #0x003
        ld c,a
        ld hl,#0x0fcc1
        add a,l
        ld l,a
        ld a,(hl)
        and #0x080
        or c
        ld c,a
        inc l
        inc l
        inc l
        inc l
        ld a,(hl)
        and #0x00c
        or c
        ld h,#0x080
        call #0x00024

        ; default pages for Konami with SCC
        xor a
        ld (#0x5000),a
        inc a
        ld (#0x7000),a
        inc a
        ld (#0x9000),a
        inc a
        ld (#0xb000),a
        ret

;;set_bank::
		;;ld (#0x9000),a
		;;ld (#_curr_bank),a
		;;inc a
		;;ld (#0xb000),a
		;;ret

;;get_bank::
		;;ld a,(#_curr_bank)
		;;ret

gsinit:
        ; Default-initialized global variables.
        ld      bc, #l__DATA
        ld      a, b
        or      a, c
        jr      Z, zeroed_data
        ld      hl, #s__DATA
        ld      (hl), #0x00
        dec     bc
        ld      a, b
        or      a, c
        jr      Z, zeroed_data
        ld      e, l
        ld      d, h
        inc     de
        ldir
zeroed_data:

        ; Explicitly initialized global variables.
        ld      bc, #l__INITIALIZER
        ld      a, b
        or      a, c
        ret     z
        ld      hl, #s__INITIALIZER        
		ld      de, #s__INITIALIZED
        ldir
        ret


;
; trampoline to call banked functions
; used when legacy banking is enabled only
; Usage:
;   call ___sdcc_bcall
;   .dw  <function>
;   .dw  <function_bank>
;
___sdcc_bcall::
        ex      (sp), hl
        ld      c, (hl)
        inc     hl
        ld      b, (hl)
        inc     hl
        ld      a, (hl)
        inc     hl
        inc     hl
        ex      (sp), hl
;
; trampoline to call banked functions with __z88dk_fastcall calling convention
; Usage:
;  ld   a, #<function_bank>
;  ld   bc, #<function>
;  call ___sdcc_bcall_abc
;
___sdcc_bcall_abc::
        push    hl
        ld      l, a
        ;;call    get_bank        ;must return A as current bank number, other registers expected to be unchanged
		ld 		a,(#_curr_bank)
        ld      h, a
        ld      a, l
        ex      (sp), hl
        inc     sp
        call    ___sdcc_bjump_abc
        dec     sp
        pop     af
        ;;jp      set_bank
		ld (#0x9000),a
		ld (#_curr_bank),a
		inc a
		ld (#0xb000),a
		ret

___sdcc_bjump_abc:
        ;;call    set_bank        ;set current bank to A, other registers expected to be unchanged
		ld (#0x9000),a
		ld (#_curr_bank),a
        inc a
		ld (#0xb000),a
        push    bc
        ret
;
; default trampoline to call banked functions
; Usage:
;  ld   e, #<function_bank>
;  ld   hl, #<function>
;  call ___sdcc_bcall_ehl
;
___sdcc_bcall_ehl::
        ;;call    get_bank
		ld a,(#_curr_bank)
        push    af
        inc     sp
        call    ___sdcc_bjump_ehl
        dec     sp
        pop     af
        ;;jp      set_bank
		ld (#0x9000),a
		ld (#_curr_bank),a
		inc a
		ld (#0xb000),a
		ret

___sdcc_bjump_ehl:
		ld      a, e
		;;call    set_bank
		ld (#0x9000),a
		ld (#_curr_bank),a
		inc a
		ld (#0xb000),a
		jp      (hl)
        

.globl	__mulint

__mulint:
        ld	c, l
        ld	b, h

		;; 16-bit multiplication
		;;
		;; Entry conditions
		;; bc = multiplicand
		;; de = multiplier
		;;
		;; Exit conditions
		;; de = less significant word of product
		;;
		;; Register used: AF,BC,DE,HL
__mul16::
		xor	a,a
		ld	l,a
		or	a,b
		ld	b,#16

        ;; Optimise for the case when this side has 8 bits of data or
        ;; less.  This is often the case with support address calls.
        jr      NZ,2$
        ld      b,#8
        ld      a,c
1$:
        ;; Taken from z88dk, which originally borrowed from the
        ;; Spectrum rom.
        add     hl,hl
2$:
        rl      c
        rla                     ;DLE 27/11/98
        jr      NC,3$
        add     hl,de
3$:
        djnz    1$
        ex	de, hl
        ret


.globl	__divuint
.globl	__divuchar


__divuchar:
	ld	e, l
	ld	l, a

        ;; Fall through
__divu8::
        ld      h,#0x00
        ld      d,h
        ; Fall through to __divu16

        ;; unsigned 16-bit division
        ;;
        ;; Entry conditions
        ;;   HL = dividend
        ;;   DE = divisor
        ;;
        ;; Exit conditions
        ;;   DE = quotient
        ;;   HL = remainder
        ;;   carry = 0
        ;;   If divisor is 0, quotient is set to "infinity", i.e HL = 0xFFFF.
        ;;
        ;; Register used: AF,B,DE,HL
__divuint:
__divu16::
        ;; Two algorithms: one assumes divisor <2^7, the second
        ;; assumes divisor >=2^7; choose the applicable one.
        ld      a,e
        and     a,#0x80
        or      a,d
        jr      NZ,.morethan7bits
        ;; Both algorithms "rotate" 24 bits (H,L,A) but roles change.

        ;; unsigned 16/7-bit division
.atmost7bits:
        ld      b,#16           ; bits in dividend and possible quotient
        ;; Carry cleared by AND/OR, this "0" bit will pass trough HL.[*]
        adc     hl,hl
.dvloop7:
        ;; HL holds both dividend and quotient. While we shift a bit from
        ;;  MSB of dividend, we shift next bit of quotient in from carry.
        ;; A holds remainder.
        rla

        ;; If remainder is >= divisor, next bit of quotient is 1.  We try
        ;;  to compute the difference.
        sub     a,e
        jr      NC,.nodrop7     ; Jump if remainder is >= dividend
        add     a,e             ; Otherwise, restore remainder
        ;; The add above sets the carry, because sbc a,e did set it.
.nodrop7:
        ccf                     ; Complement borrow so 1 indicates a
                                ;  successful substraction (this is the
                                ;  next bit of quotient)
        adc     hl,hl
        djnz    .dvloop7
        ;; Carry now contains the same value it contained before
        ;; entering .dvloop7[*]: "0" = valid result.
        ld      e,a             ; DE = remainder, HL = quotient
        ex	de, hl
        ret

.morethan7bits:
        ld      b,#9            ; at most 9 bits in quotient.
        ld      a,l             ; precompute the first 7 shifts, by
        ld      l,h             ;  doing 8
        ld      h,#0
        rr      l               ;  undoing 1
.dvloop:
        ;; Shift next bit of quotient into bit 0 of dividend
        ;; Shift next MSB of dividend into LSB of remainder
        ;; A holds both dividend and quotient. While we shift a bit from
        ;;  MSB of dividend, we shift next bit of quotient in from carry
        ;; HL holds remainder
        adc     hl,hl           ; HL < 2^(7+9), no carry, ever.

        ;; If remainder is >= divisor, next bit of quotient is 1. We try
        ;;  to compute the difference.
        sbc     hl,de
        jr      NC,.nodrop      ; Jump if remainder is >= dividend
        add     hl,de           ; Otherwise, restore remainder
	;; The add above sets the carry, because sbc hl,de did set it.
.nodrop:
        ccf                     ; Complement borrow so 1 indicates a
                                ;  successful substraction (this is the
                                ;  next bit of quotient)
        rla
        djnz    .dvloop
        ;; Take care of the ninth quotient bit! after the loop B=0.
        rl      b               ; BA = quotient
        ;; Carry now contains "0" = valid result.
        ld      d,b
        ld      e,a             ; DE = quotient, HL = remainder
        ret


        .area _DATA
_curr_bank::
        .ds 2



	.area _BANK0
	
