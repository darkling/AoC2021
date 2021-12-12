$origin &8000

:t
    ld b, 4
	ld hl, .src
	ld c, 2
	ld ix, .tgt
	call :mul_8n
	ret

.src
	byte 0x55, 0xaa, 0x33, 0xcc

.tgt
	byte 0 * 5

$include "src/maths.asm"
