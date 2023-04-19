gdt_start: ; end and start are marked so we can calculate the size

gdt_null: ; Necessary null segment, contains 8 bytes of zeros
	dd 0x0 ; dd means define double word, or 4 bytes
	dd 0x0

gdt_code:
	; base = 0x0, limit = 0xffff, both are split between different parts of the descriptor, base must add up to 32 buts & limit must add up to 20 bits
	; 1st flags: 1(present) 00(privilege) 1(descriptor type) = 1001b
	; type flags: 1(code) 0(conforming) 1(readable) 0(accessed) = 1010b
	; 2nd flag: 1(granularity) 1(32 bit default) 0(64 bit segment) 0(general purpose) = 1100b
	dw 0xffff 	 ; Limit (bits 0-15)
	dw 0x0 		 ; Base (bits 0-15)
	db 0x0 		 ; Base (bits 16-23)
	db 10011010b ; 1st flags and type flags
	db 11001111b ; 2nd flags and Limit (bits 16-19)
	db 0x0 		 ; Base (bits 24-31)

gdt_data:
	; Same as code except for type flags
	; type flags: 0(code) 0(expand down) 1(writable) 0(accessed) = 0010
	dw 0xffff 	 ; Limit (bits 0-15)
	dw 0x0 		 ; Base (bits 0-15)
	db 0x0 		 ; Base (bits 16-23)
	db 10010010b ; 1st flags and type flags
	db 11001111b ; 2nd flags and Limit (bits 16-19)
	db 0x0 		 ; Base (bits 24-31)

gdt_end:

gdt_descriptor:
	dw gdt_end - gdt_start - 1 ; Size of our GDT always one less than actual size
	dd gdt_start ; Start address of our GDT

	; Defining constants for gdt segment descriptor offsets, which the segment registers will hold to reference a segment
	; If a segment register holds 0x0 it references the null segment, if it holds 0x10 it references the data segment
	CODE_SEG equ gdt_code - gdt_start
	DATA_SEG equ gdt_data - gdt_start