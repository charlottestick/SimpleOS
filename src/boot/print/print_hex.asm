; Usage:
;	mov dx, hex_byte
;	call print_hex
;
;	%include "print_hex.asm"
%ifndef PRINT_HEX_H
%define PRINT_HEX_H

print_hex:
	pusha
	mov ah, 0x0e

	mov cx, dx
	and ch, 0x0f ; ax ahould hold lower nibble of both bytes, ax: 0f 06
	and cl, 0x0f
	
	and dh, 0xf0 ; dx should hold upper nibble of both bytes, dx: 10 b0
	and dl, 0xf0
	shr dx, 4 ; dx: 01 0b
	
	; Convert hex nibbles to ascii, should be basic addition
	mov al, "0"
	int 0x10
	mov al, "x"
	int 0x10
	
	mov al, dh
	call hex_loop
	mov al, ch
	call hex_loop
	mov al, dl
	call hex_loop
	mov al, cl
	call hex_loop
	
	jmp hex_end
	
print_hex_loop:
	cmp al, 0x0a
	jge hex_letters
	jmp hex_convert
	
print_hex_letters:
	add al, 0x07
	jmp hex_convert
	
print_hex_convert:
	add al, "0"
	int 0x10
	ret
	
print_hex_end:
	popa
	ret

%endif