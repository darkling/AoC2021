$origin &8000

:t
    ld b, 2
	ld de, .p
	ld hl, .q
	call :add_n
	ret

.p
	byte 2
	word 2

.q
	byte 2
	word 2

$include "src/maths.asm"
