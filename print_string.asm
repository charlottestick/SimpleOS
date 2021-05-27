; Usage:
;	mov bx, string_label
;	call print_string
;
;	%include "print_string.asm"
;
;string_label:
;	db "String to print", 0

print_string:
	pusha
	mov ah, 0x0e
	
string_loop:
	mov al, [bx] ; [bx] takes the contents of bx as an address to follow, therefore [0x45ef] contents at address 0x45ef
	cmp al, 0 ; String must be 0 terminated
	je string_return	
	int 0x10
	add bx, 1
	jmp string_loop
	
string_return:
	popa
	ret
