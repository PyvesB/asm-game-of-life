build:
	nasm -f elf64 -o life.o life.asm
	ld -o life life.o
