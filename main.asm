global _start
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
mov r8, rax

; allocate mem with mmap
%define ENOMEM 12

mov rax, 9
mov rdi, 0
mov rsi, 10000000000000; Intentionally cause ENOMEM
mov rsi, 1000
mov rdx, 2; prot=PROT_WRITE
mov r10, 2; flags=MAP_PRIVATE
syscall

cmp rax, -ENOMEM
jne alloc_OK
mov rax, 60; Exit
mov rdi, 1; Status 1
syscall
alloc_OK:
mov r9, rax


mov rax, 0
mov rdi, r8
mov rsi, r9
mov rdx, 100
syscall

mov rax, 1
mov rdi, 1
mov rsi, r9
mov rdx, 100
syscall

mov rax, 60
mov rdi, 0
syscall

section .data
message:  db "Hello, World!", 10
filename: db "./Makefile", 0