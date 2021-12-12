$origin &8000

:t
    ld b, 4
	ld de, .p
	ld hl, .q
	call :add_n
	ret

.p
	byte 0x90, 0x89, 0xfe, 0x4e  ; 1325304208

.q
	byte 0x1d, 0x8c, 0x46, 0xac  ; 2890304541

$include "src/maths.asm"
