10 bank 1346 usr
20 clear 32767
30 load "maths-1.bin" code {{t}}
40 ;let z=usr {{t}}
50 for %i=0 to 1
60 let %a=%{{t.q}}+i
70 let %d=%peek a
80 print "+";%i,%d
90 next %i
