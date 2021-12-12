10 restore 10
20 let z=usr {{t}}
30 for %i=0 to 5
40 let %a=%{{t.tgt}}+i
50 let %d=%peek a
60 read s
70 print "+";%i,%d;" s/b ";s
80 next %i
90 data 193, 192, 36, 194, 197, 67
990 stop
1010 bank 1346 usr
1020 clear 32767
1030 load "maths-4.bin" code {{t}}
1040 print "Loaded code"
1050 goto 10
