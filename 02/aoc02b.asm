$origin &8000

:entry
	ld hl, 0
	ld (:x), hl
	ld (:y), hl
	ld (:aim), hl
	ld hl, :data
:loop
	ld a, (hl)
	inc hl
	cp 0x66
	jp z, .forward
	cp 0x64
	jp z, .down
	cp 0x75
	jp z, .up
	jp :gen_output

.forward
	ld bc, (:x)       ; Increases horizontal position (:x) by N units
	ld a, (hl)
	add bc, a
	ld (:x), bc

    ; Increases depth by :aim * N
	;  - Multiply current aim by N, into .scratch
	push hl
	ld b, 2
	ld c, a
	ld hl, :aim
	ld ix, .scratch
	call :mul_8n

	;  - Add .scratch to current depth, :y
	ld b, 3
	ld d, ixh
	ld e, ixl
	ld hl, :y
	call :add_n

	pop hl
	inc hl
	jp :loop

.scratch
    byte 0 * 6

.down
	ld bc, (:aim)
	ld a, (hl)
	add bc, a
	ld (:aim), bc
	inc hl
	jp :loop

.up
	ld e, (hl)
	ld a, (:aim)
	sub e
	ld (:aim), a
	ld a, (:aim+1)
	sbc 0
	ld (:aim+1), a
	inc hl
	jp :loop

:gen_output
	ret 				; Start with just getting the :x, :y data with peek

;	ld bc, :x
;	ld de, :y
;	call :mul32
;	ld b, 4
;	ld hl, :mul_result
;	jp :print_hex
;	ret

:print_hex
	;; Takes an address in HL, and a byte count in B.
	;; Prints the (LE) hex number at that location to the screen
	;; Will destroy the number stored
	ld a, l						; Add b to hl
	add b
	ld l, a
	ld a, h
	adc 0
	ld h, a

.loop
	dec hl

	ld a, 0
	rld
	add a, 0x30
	cp 0x39
	jp m, .digit1
	add a, 0x27
.digit1
	rst 0x10

	and 0x0f
	rld
	add a, 0x30
	cp 0x39
	jp m, .digit2
	add a, 0x27
.digit2
	rst 0x10

	djnz .loop
	ret

:x
	byte 0 * 6
:y
	byte 0 * 6
:aim
	word 0

$include "../lib/src/maths.asm"
$include "data.asm"
; $include "test-data.asm"
