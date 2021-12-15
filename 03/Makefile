all: aoc03a.bin aoc03a.bas #aoc03b.bin aoc03b.bas

%.bin %.lbl &: %.asm data.asm
	../asm_z80n --verbose --labels $*.lbl --output $@ $<

%.bas: %.txt %.lbl
	encode-basic --plus3 --autostart 1010 --labels $*.lbl --output $@ $<

data.asm: input.txt
	./build-data

.PHONY: clean
clean:
	rm -f aoc03[ab].bas aoc03[ab].bin data.asm *~
