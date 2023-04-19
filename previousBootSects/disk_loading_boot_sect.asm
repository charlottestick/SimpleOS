[org 0x7c00] ; Tells the processor where code will be loaded, actual address offset

; Main code
	mov [BOOT_DRIVE], dl ; The drive BIOS boots us from is stroed in dl, so we can grab it here for later
	mov bp, 0x8000 ; Stack base pointer
	mov sp, bp ; Stack pointer, set to same as base as stack is empty

	mov dh, 5 ; Sectors to read
	mov bx, 0x9000 ; Data will be read to es:bx
	mov dl, [BOOT_DRIVE] ; Which drive to read
	call disk_load

	mov dx, [0x9000]
	call print_hex

	mov dx, [0x9000 + 512]
	call print_hex
	
; System hang
	jmp $ 

; Importing function modules
%include "../print/print_string.asm"
%include "../print/print_hex.asm"
%include "../disk/disk_load.asm"

;Variables
BOOT_DRIVE: db 0

;Defining end of boot sector
	times 510-($-$$) db 0 ; Padding to make 512 byte file size
	dw 0xaa55 ; "Magic number" indicates this is the boot section

; More sectors
	times 256 dw 0xdada ; Test data
	times 256 dw 0xface