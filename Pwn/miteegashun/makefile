all:assemble compile link
CFLAGS=-g --static

assemble:
	nasm -f elf *.s

link:
	gcc -m32 *.o -o mitigation  $(CFLAGS)
	strip mitigation

compile:

clean:
	rm -f mitigation
	rm -f *.o
