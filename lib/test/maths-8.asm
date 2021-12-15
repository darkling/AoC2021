$origin &8000

:t
    ld bc, 4
	ld de, .tgt
	ld hl, .tgt_orig
	ldir                      ; Set up: Copy original value to target space

	ld bc, .tgt
	ld de, .src1
	ld hl, .src2
	call :mula_n_m
	ret

.src1
	byte 2
	word 0x0a67

.src2
	byte 2
	word 0x0598

.tgt
	byte 0 * 4

.tgt_orig
	byte 0 * 4

$include "src/maths.asm"
