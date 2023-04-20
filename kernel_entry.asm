[bits 32]
[extern main] ; Declare an external symbol that the linker will substitute with the address of our main C function so that we can explicitly jump to it from here

_start: ; ld looks for this label as a start point, assumes start of .text segment if not found
    call main
    jmp $ ; Hang just in case the call to main fails or returns for whatever reason

; This file needs to be assembled into ELF not binary like the boot sect code
; nasm kernel_entry.asm -f elf -o kernel_entry.o
; This object code can then be linked with the kernel to produce a binary with this assembly gauranteed at the beginning to ensure we jump to wherever main is