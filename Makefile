debug_flag:=

.PHONY: all debug disassemble
all: main

main: main.asm
	nasm -f elf64 -w-zeroing ${debug_flag} main.asm
	ld -o main main.o

debug:
	${MAKE} all  debug_flag="-g"

disassemble:
	objdump -das -M intel main

clean:
	rm main.o main