TEST_FILES := $(addprefix build/, \
			    $(addsuffix .bin, \
				  $(basename \
				    $(wildcard test/*.asm))))

.PHONY: test
test: $(TEST_FILES) $(addsuffix .bas,$(basename $(TEST_FILES)))

build/test/%.bas: test/%.bas
	encode-basic -p $< -a 1010 -o build/test/$*.bas -l build/test/$*.lbl

build/test/%.bin build/test/%.lbl: test/%.asm src/maths.asm
	../asm_z80n --verbose $< -o build/test/$*.bin -l build/test/$*.lbl
