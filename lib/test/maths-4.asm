$origin &8000

:t
    ld b, 5
	ld hl, .src
	ld c, 0xbd
	ld ix, .tgt
	call :mul_8n
	ret

.src
	byte 0x55, 0xaa, 0x33, 0xcc, 0x5b

.tgt
	byte 0 * 6

$include "src/maths.asm"
