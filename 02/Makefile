all: aoc02a.bin aoc02a.bas aoc02b.bin aoc02b.bas

aoc02%.bin: solution-%.asm
	../asm_z80n --verbose $< -o $@

aoc02%.bas: aoc02%.txt
	../encode-basic $< $@

solution-%.asm: code-%.asm data.asm
	cat $^ >$@

data.asm: input.txt
	./build-data

.PHONY: load
load: aoc02a.bin aoc02a.bas aoc02b.bin aoc02b.bas
	mount /media/sdcard
	mkdir -p /media/sdcard/hugo/aoc2021/02/
	cp $^ /media/sdcard/hugo/aoc2021/02/
	umount /media/sdcard

.PHONY: clean
clean:
	rm -f solution-[ab].asm aoc02[ab].bin *~
