global _start
extern printf
section .text

_start:
mov rax, 1; write
mov rdi, 1
mov rsi, message
mov rdx, 14
syscall

mov rax, 2; open
mov rdi, filename
mov rsi, 0; Read only
mov rdx, 0
syscall
mov r15, rax

; allocate mem with mmap
%define ENOMEM 12
%define buflen 1000
%define MAP_ANONYMOUS        0x20
%define MAP_PRIVATE        0x02
mov rax, 9
mov rdi, 0
;mov rsi, 1000000000000; Intentionally cause ENOMEM
mov rsi, buflen
mov rdx, 2; prot=PROT_WRITE
mov r10, MAP_ANONYMOUS + MAP_PRIVATE; flags=MAP_PRIVATE
mov r8, 0
mov r9, 0
syscall

cmp rax, -ENOMEM
jne alloc_OK
call cannot_allocate
mov rax, 60; Exit
mov rdi, 1; Status 1
syscall
alloc_OK:
mov r9, rax


mov rax, 0
mov rdi, r15
mov rsi, r9
mov rdx, buflen
syscall

; Less elegantly, print with printf
mov rdi, r9
call printf

; exit 0
mov rax, 60
mov rdi, 0
syscall

cannot_allocate:
mov rax, 1; write
mov rdi, 1
mov rsi, cannot
mov rdx, cannot_len
syscall
ret

section .data
message:  db "Hello, World!", 10
cannot: db "Cannot allocate!", 10
cannot_len: equ $-cannot
filename: db "./Makefile", 0