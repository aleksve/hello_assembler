Assembler program that does the following:

* Print "Hello, World!"
* Opens a file, specified by buffer ```filename``` in the .data section
* Allocates a chunk of memory using mmap
* Checks if allocation was a success, or if it was an error
* Reads the contents of the file into that buffer
* Prints the buffer
* Exits


# References
Overview over system calls:
https://chromium.googlesource.com/chromiumos/docs/+/master/constants/syscalls.md
mmap: https://man7.org/linux/man-pages/man2/mmap.2.html