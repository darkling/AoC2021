$origin &8000

:t
	ld bc, .tgt
	ld de, .src1
	ld hl, .src2
	call :mula_n_m
	ret

.src1
	byte 2
	word 0x6

.src2
	byte 2
	word 0x9

.tgt
	byte 0x01, 0x00, 0x00

$include "src/maths.asm"
