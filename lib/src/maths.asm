;; ----------------------------------------------------------------------
;; Multiply an n-byte number with an m-byte number and add to a target
;;
;; Inputs:
;;  BC -- Target buffer (must be n+m bytes long)
;;  DE -- n-byte number (with n as the first byte)
;;  HL -- m-byte number (with m as the first byte)
;;
;;  n must be 8 or less
;;
;; Outputs:
;;
;;  BC -- (BC[0..n+m-1]) + (DE[0..n-1])*(HL[0..m-1])
;; ----------------------------------------------------------------------

:mula_n_m
    ;; The second register bank needs to be set up with:
    ;;  HL    -- target buffer (BC from input)
    ;;  DE    -- hold buffer (.hold)
    ;;  B = C -- n = size of number in hold buffer

    push hl
    push de
    push bc

    ld a, (de)
    ld (.loop_counter), a
    inc de
    push bc                ; Put BC (target) onto the stack: HL DE BC BC
    exx
    ex (sp), hl            ; Switch target off the stack into HL: HL DE BC HL'
    push de
    push bc                ; Stack now HL DE BC HL' DE' BC'
    ld de, .hold
    ld b, a                ; Set B and C to the length of the n+1-byte number
    ld c, a
    exx

    ;; The first register bank needs to be set up with:
    ;;  B  -- m = size of number to multiply
    ;;  HL -- number to multiply in each step
    ;;  DE -- list of numbers to multiply by (plus 1-byte length header)
    ;;  IX -- hold buffer
    ld a, (hl)
    ld (.m), a
    inc hl
    ld a, (.loop_counter)   ; Instead, could jump into the loop at the ld a,(.m)
    ld b, a

.loop
    ld a, b
    ld (.loop_counter), a
    ld a, (.m)
    ld b, a
    ld a, (de)
    ld c, a
    ld ix, .hold

    call :mul_8n            ; Multiply 
                            ; .hold now contains m+1 bytes of (HL)*C
    exx
    call :add_n             ; Add the hold buffer to the target
    inc hl                  ; Shift the target up by one place
    ld b, c                 ; Restore B'
    exx

    inc de                  ; Move to the next byte of DE
    ld a, (.loop_counter)
    ld b, a
    djnz .loop

    exx
    pop bc                  ; Restore the second register bank
    pop de
    pop hl
    exx
    pop bc                  ; Restore the first register bank
    pop de
    pop hl
    ret

.m
    byte 0
.loop_counter
    byte 0
.hold
    byte 0*9


;; ----------------------------------------------------------------------
;; Multiply an n-byte number with a 1-byte number
;;
;; Inputs:
;;   HL -- Points to the n-byte buffer to multiply (p)
;;   B  -- length of the buffer (n)
;;   C  -- number to multiply by (q)
;;   IX -- buffer to store the result in (must be n+1 bytes in length)
;;
;; Outputs:
;;   A is modified
;;   Buffer at (IX) is filled with p*q (n+1 bytes)
;; ----------------------------------------------------------------------

:mul_8n
    push ix
    push hl
    push de
    push bc
    ld a, 0

    scf
    ccf

.loop
    ld d, (hl)
    ld e, c
    mul d, e
    adc a, e
    ld (ix+0), a
    ld a, d

    inc ix
    inc hl
    djnz .loop

    adc a, 0
    ld (ix+0), a

    pop bc
    pop de
    pop hl
    pop ix
    ret


;; ----------------------------------------------------------------------
;; Add two n-byte numbers
;;
;; Inputs:
;;  B  -- Size of numbers to add (n)
;;  DE -- Pointer to n-byte buffer containing p
;;  HL -- Pointer to n-byte buffer containing q
;;
;; Outputs:
;;  A is modified
;;  Buffer at HL is updated with p+q
;;  C flag is set as appropriate
;; ----------------------------------------------------------------------

:add_n
    push bc
    push de
    push hl

    scf
    ccf

.loop
    ld a, (de)
    adc a, (hl)
    ld (hl), a
    inc hl
    inc de
    djnz .loop

    pop hl
    pop de
    pop bc
    ret
