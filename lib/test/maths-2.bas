10 bank 1346 usr
20 clear 32767
30 load "maths-2.bin" code {{t}}
40 ;let z=usr {{t}}
50 for %i=0 to 3
60 let %a=%{{t.q}}+i
70 let %d=%peek a
80 read %s
90 print "+";%i,%d;" s/b ";%s
100 next %i
110 data %$ad, %$15, %$45, %$fb
