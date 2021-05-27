[org 0x7c00] ; Tells the processor where code will be loaded, actual address offset

; Main code 16 bit
	mov bp, 0x8000 ; Stack base pointer
	mov sp, bp ; Stack pointer, set to same as base as stack is empty

	mov bx, MSG_REAL_MODE
	call print_string

	call switch_to_pm

; System hang
	jmp $ 

; Importing function modules
%include "print_string.asm"
%include "print_string_pm.asm"
%include "gdt.asm"
%include "switch_to_pm.asm"

; Main code 32 bit
[bits 32]
BEGIN_PM:
	mov ebx, MSG_PROT_MODE
	call print_string_pm

	jmp $


;Variables
MSG_REAL_MODE: db "Started successfully in 16-bit mode ", 0
MSG_PROT_MODE: db "Successfully landed in 32-bit protected mode ", 0

;Defining end of boot sector
	times 510-($-$$) db 0 ; Padding to make 512 byte file size
	dw 0xaa55 ; "Magic number" indicates this is the boot section