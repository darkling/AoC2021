$origin 0x8000

:entry
	ld hl, :bit_counts
	xor a
	ld b, 36
.clr
	ld (hl), a
	inc hl
	djnz .clr
	ld a, 2
	ld (:gamma), a
	ld (:epsilon), a
	
	ld ix, :data

	;; Loop over the data, accumulating counts of 1-bits
.loop
	ld a, (ix+0)
	or (ix+1)
	jp z, :build_result

	ld hl, :bit_counts
	call :inc_at_hl           ; Increase the total count and move HL on
	inc hl
	inc hl

	ld c, (ix+0)
	ld b, 8                   ; Handle all 8 bits of the low byte
.bit_loop_low
	rrc c
	jr nc, .next_loop_low
	call :inc_at_hl
.next_loop_low
	inc hl
	inc hl
	djnz .bit_loop_low

	ld c, (ix+1)
	ld b, 4                   ; Handle the low 4 bits of the high byte
.bit_loop_high
	rrc c
	jr nc, .next_loop_high
	call :inc_at_hl
.next_loop_high
	inc hl
	inc hl
	djnz .bit_loop_high

	inc ix
	inc ix
	jp .loop


:build_result
	ld hl, :bit_counts
	ld de, (:bit_counts)
	scf                       ; Divide DE by 2
	ccf
	rr d
	rr e

	inc hl
	inc hl

	;; First, compare each count (HL*) to half the total (DE) and set
    ;; it in the same array
	ld b, 12
.cmp_loop
    inc hl
	ld a, d
	cp (hl)
	jp nz, .cmp_set

    dec hl
	ld a, e
	cp (hl)
	inc hl

.cmp_set
	ld a, 0                         ; can't use XOR A here, because we need to preserve flags
    jp p, .set_zero
	inc a
.set_zero
	ld (hl), a                      ; 0/1 goes in the high (2nd) bytes of the :bit_counts array
	inc hl
    djnz .cmp_loop

	;; Then use the 0/1 values in the odd-numbered offsets of :bit_counts
	;; to build a 12-bit number in :p+1
	xor a
	ld e, 0
	ld b, 8
	ld hl, :bit_counts_low+15
.low_output_loop
	sla e
	cp (hl)
	jr z, .low_add_zero
	inc e
.low_add_zero
	dec hl
	dec hl
	djnz .low_output_loop

	ld d, 0
	ld b, 4
	ld hl, :bit_counts_high+7
.high_output_loop
	sla d
	cp (hl)
	jr z, .high_add_zero
	inc d
.high_add_zero
	dec hl
	dec hl
	djnz .high_output_loop

	ld (:gamma+1), de
	ld a, e
	cpl
	ld e, a
	ld a, d
	cpl
	and 0x0f
	ld d, a
	ld (:epsilon+1), de

	;; Now multiply gamma and epsilon together
	ld bc, :result
	ld de, :gamma
	ld hl, :epsilon
	jp :mula_n_m            ; Tail call optimisation

:inc_at_hl
	ld a, (hl)
	add a, 1
	ld (hl), a
	ret nc
	inc hl
	ld a, (hl)
	adc a, 0
	ld (hl), a
	dec hl
	ret

:bit_counts
	word 0x0000             ; Total number of items/threshold
:bit_counts_low
	word 0x0000 * 8         ; Bottom 8 bits, 0-7
:bit_counts_low_end
:bit_counts_high
	word 0x0000 * 4         ; Top 4 bits, 8-11
:bit_counts_high_end

:gamma
	byte 2
	byte 0 * 2
:epsilon
	byte 2
	byte 0 * 2

:result
	byte 0*4

$include "../lib/src/maths.asm"
$include "data.asm"
;$include "data-test.asm"
