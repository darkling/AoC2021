$origin &8000

	ld hl, 0
	ld (:x), hl
	ld (:y), hl
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
	ld bc, (:x)
	ld a, (hl)
	add bc, a
	ld (:x), bc
	inc hl
	jp :loop

.down
	ld bc, (:y)
	ld a, (hl)
	add bc, a
	ld (:y), bc
	inc hl
	jp :loop

.up
	ld e, (hl)
	ld a, (:y)
	sub e
	ld (:y), a
	ld a, (:y+1)
	sbc 0
	ld (:y+1), a
	inc hl
	jp :loop

:gen_output
	ret 				; Start with just getting the :x, :y data with peek

	ld bc, :x
	ld de, :y
	call :mul32
	ld b, 4
	ld hl, :mul_result
	jp :print_hex
	ret

:mul32
	;; Multiply two 16-bit numbers, in bc and de. The result is stored
	;; in the four bytes of :mul_result, little-endian
	push ix
	;; Compute (bc)*(de) = ce + be << 8 + cd << 8 + bd << 16
	ld ix, :mul_result
	ld (ix+7), d
	ld (ix+6), e
	;; ce
	ld d, c
	mul d, e
	ld (ix+1), d
	ld (ix+0), e
	;; be
	ld d, b
	ld e, (ix+7)
	mul d, e
	ld (ix+3), d
	ld (ix+2), e
	;; cd
	ld e, c
	ld d, (ix+6)
	mul d, e
	ld (ix+5), d
	ld (ix+4), e
	;; bd
	ld e, b
	ld d, (ix+6)
	mul d, e
	ld (ix+7), d
	ld (ix+6), e
	;; Now add it all together:
	;;  r[0] <- r[0]
	;;  r[1] <- r[1] + r[2] + r[4]
	;;  r[2] <- r[3] + r[5] + r[6] + carry
	;;  r[3] <- r[7] + carry
	ld a, (ix+1)
	add a, (ix+2)
	ld (ix+1), a

	ld a, (ix+3)
	adc a, (ix+5)
	ld (ix+2), a

	ld a, (ix+7)
	adc a, 0
	ld (ix+3), a

	ld a, (ix+1)
	add a, (ix+4)
	ld (ix+1), a

	ld a, (ix+2)
	adc a, (ix+6)
	ld (ix+2), a

	ld a, (ix+7)
	adc a, 0
	ld (ix+3), a
	
	pop ix
	ret

:mul_result
	byte 0*8					; Includes scratch space

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
	word 0
:y
	word 0
