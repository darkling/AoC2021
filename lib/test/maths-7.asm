$origin &8000

:t
    ld bc, 10
	ld de, .tgt
	ld hl, .tgt_orig
	ldir                      ; Set up: Copy original value to target space

	ld bc, .tgt
	ld de, .src1
	ld hl, .src2
	call :mula_n_m
	ret

.src1
	byte 6
	byte 0xf8, 0x25, 0xbf, 0x26, 0x4b, 0xa0

.src2
	byte 4
	byte 0x71, 0x6b, 0x50, 0x52

.tgt
	byte 0 * 10

.tgt_orig
	byte 0x90, 0xc4, 0x7f, 0x17, 0xe2, 0x57, 0x42, 0x78, 0x92, 0x78

$include "src/maths.asm"
