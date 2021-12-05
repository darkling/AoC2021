all: aoc01a.bin aoc01b.bin

aoc01%.bin: solution-%.asm
	../asm_z80n --verbose $< -o $@

solution-%.asm: code-%.asm data.asm
	cat $^ >$@

data.asm: input.txt
	./build-data

.PHONY: load
load: aoc01a.bin aoc01a.bas aoc01b.bin aoc01b.bas
	mount /media/sdcard
	cp $^ /media/sdcard/hugo/aoc2021/01/
	umount /media/sdcard

.PHONY: clean
clean:
	rm solution-[ab].asm aoc01[ab].bin *~
