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
%define buflen 1000
%define buflen 1000*1000*1000  ; Intentionally cause ENOMEM
%define buflen 100*1000*1000*1000  ; Intentionally cause ENOMEM
mov rax, 9
mov rdi, 0
mov rsi, buflen

%define PROT_WRITE 0x2; https://github.com/torvalds/linux/blob/master/include/linux/mman.h
mov rdx, PROT_WRITE

%define MAP_ANONYMOUS 0x20
%define MAP_PRIVATE 0x2; https://github.com/torvalds/linux/blob/c25b24fa72c734f8cd6c31a13548013263b26286/include/uapi/linux/mman.h#L18
mov r10, MAP_ANONYMOUS + MAP_PRIVATE; flags=MAP_PRIVATE
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
mov r10, buflen
loop:
mov [rax+r9], rax
add rax, 8
cmp rax, r10
jne loop

; Sleep
%define syscall_nanosleep 0x23
mov rax, syscall_nanosleep
push dword 5; Seconds
push dword 0; Millisecond
mov rdi, rsp
add rdi, 8
mov rsi, 0
syscall

mov rax, 0
mov rdi, r8
mov rsi, r9
mov rdx, buflen
syscall

mov rax, 1
mov rdi, 1
mov rsi, r9
mov rdx, buflen
syscall

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
cannot: db "Couldn't allocate the requested memory!", 10
cannot_len: equ $-cannot
filename: db "./Makefile", 0