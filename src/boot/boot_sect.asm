[org 0x7c00] ; Tells the processor where code will be loaded, actual address offset
KERNEL_OFFSET equ 0x1000

; Main code 16 bit
	mov [BOOT_DRIVE], dl ; The drive BIOS boots us from is stored in dl, so we can grab it here for later
	mov bp, 0x8000 ; Stack base pointer
	mov sp, bp ; Stack pointer, set to same as base as stack is empty

	mov bx, MSG_REAL_MODE
	call print_string

	call load_kernel

	call switch_to_pm

; System hang
	jmp $ 

; Importing function modules
%include "src/boot/disk/disk_load.asm"
%include "src/boot/print/print_string.asm"
%include "src/boot/print/print_string_pm.asm"
%include "src/boot/pm/gdt.asm"
%include "src/boot/pm/switch_to_pm.asm"

[bits 16] ; Why is this in the middle, can it be moved up?

load_kernel:
	mov bx, MSG_LOAD_KERNEL
	call print_string
	mov bx, 0x0 ; Extra newlines so the cursor doesn't get left in a funny place after 32 bit prints
	call print_string

	; Disk load params
	mov bx, KERNEL_OFFSET ; Start loading from kernel offset
	mov dh, 15 ; Load 15 sectors
	mov dl, [BOOT_DRIVE] ; Load from boot drive 
	call disk_load

	ret

; Main code 32 bit
[bits 32]
BEGIN_PM:
	mov eax, 80 ; Number of characters in one line on screen
	mov ebx, 19 ; Number of lines down to print at
	mul ebx ; Find the number of characters along the screen to print at, wrapping round every 80
	mov edx, eax
	mov ebx, MSG_PROT_MODE
	call print_string_pm

	call KERNEL_OFFSET

	jmp $


;Variables
MSG_REAL_MODE: db `Started successfully in 16-bit mode`, 0
MSG_LOAD_KERNEL: db `Loading the kernel into memory`, 0
MSG_PROT_MODE: db "Successfully landed in 32-bit protected mode", 0
BOOT_DRIVE: db 0

;Defining end of boot sector
	times 510-($-$$) db 0 ; Padding to make 512 byte file size
	dw 0xaa55 ; "Magic number" indicates this is the boot section