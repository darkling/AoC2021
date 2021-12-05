$origin &8010

    ld hl, 0
    ld (:count), hl             ; Zero the counter (for multiple runs)
    ld hl, :data
    ld de, &7fff                ; DE is the current entry
:mainloop
    ld bc, de                   ; BC is the previous entry
    ld e, (hl)
    inc hl
    ld d, (hl)
    inc hl

    ;; Test for zero in the input and stop
    ld a, e
    or d
    jp z, :done
	
    ;; Compare
    ld a, b
    cp d
    jp m, .add                 ; High byte: second value is larger: add one
    jp nz, :mainloop           ;            second value is smaller: loop again

    ld a, c                    ;            second value is equal: test low byte
    cp e
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
