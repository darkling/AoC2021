all: aoc02a.bin aoc02a.bas aoc02b.bin aoc02b.bas

aoc02%.bin aoc02%.lbl &: aoc02%.asm data.asm
	../asm_z80n --verbose --labels aoc02$*.lbl --output $@ $<

aoc02%.bas: aoc02%.txt aoc02%.lbl
	encode-basic --plus3 --autostart 1010 --labels aoc02$*.lbl --output $@ $<

data.asm: input.txt
	./build-data

.PHONY: clean
clean:
	rm -f aoc02[ab].bas aoc02[ab].bin data.asm *~
