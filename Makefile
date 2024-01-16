debug_flag:=

.PHONY: all debug disassemble
all: main

main: main.asm
	nasm -f elf64 ${debug_flag} main.asm
	ld -o main main.o -lc -dynamic-linker /lib/x86_64-linux-gnu/ld-linux-x86-64.so.2

debug:
	${MAKE} all  debug_flag="-g"

disassemble:
	objdump -das -M intel main

clean:
	rm main.o main
