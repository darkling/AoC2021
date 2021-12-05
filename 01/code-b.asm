$origin &8010

    ld hl, 0
    ld (:count), hl             ; Zero the counter (for multiple runs)
    ld ix, :data

	;; Set up the initial window: HL is our accumulator and current value
    ld d, (ix+1)
	ld e, (ix+0)
	add hl, de

    ld d, (ix+3)
	ld e, (ix+2)
	add hl, de

    ld d, (ix+5)
	ld e, (ix+4)
	add hl, de

:mainloop
    ld bc, hl                   ; BC is the previous entry

    ;; Test for zero in the input and stop
    ld a, (ix+7)
    or (ix+6)
    jp z, :done

	;; Update HL
	scf
	ccf							; Clear the carry flag
	ld d, (ix+1)
	ld e, (ix+0)
	sbc hl, de
	ld d, (ix+7)
	ld e, (ix+6)
	add hl, de
	inc ix
	inc ix

    ;; Compare
    ld a, b
    cp h
    jp m, .add                 ; High byte: second value is larger: add one
    jp nz, :mainloop           ;            second value is smaller: loop again

    ld a, c                    ;            second value is equal: test low byte
    cp l
    jp p, :mainloop            ; Low byte:  second value is smaller or equal:
                               ;            loop again
	
.add
    ;; Increment our counter
    ld bc, (:count)
    inc bc
    ld (:count), bc

	jp :mainloop

:done
    ld bc, (:count)
    ret

:count
    word 0
