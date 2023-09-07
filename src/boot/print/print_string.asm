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
	; when calling interrupt 0x10 for video functions, set ah to the function we want
	; setting ah to 0x0e means the teletype output, i.e. printing text
	mov ah, 0x0e

	; ah = 0x01 can be used to hide the cursor, maybe when we switch to 32 bit and are no longer using the BIOS to print
	; set ch to the scan row start and cl to the scan row end, or hide by setting ch > cl or ch += 0x20
	; x10000 = 0x10
	
print_string_loop:
	mov al, [bx] ; [bx] takes the contents of bx as an address to follow, therefore [0x45ef] contents at address 0x45ef

	cmp al, 0 ; String must be 0 terminated
	je print_string_end

	int 0x10

	add bx, 1
	jmp print_string_loop
	
print_string_end:
	; Newline and carriage return before printing next string
	mov al, [newline]
	int 0x10
	mov al, [newline + 1]
	int 0x10

	popa
	ret

newline:
	db `\n\r`