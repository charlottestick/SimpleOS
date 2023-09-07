; Usage:
;   call clear_screen
;
;   %include "clear_screen.asm"
%ifndef CLEAR_SCREEN_H
%define CLEAR_SCREEN_H

[bits 32]
VIDEO_MEMORY equ 0xb8000
WHITE_ON_BLACK equ 0x0f

clear_screen:
    pusha
    mov al, 0x0 ; Space character
    mov ah, WHITE_ON_BLACK
    mov ebx, 0 ; Counter variable
    mov edx, VIDEO_MEMORY

clear_screen_loop:
	cmp ebx, 2000 ; 80 * 25, number of empty characters to fill the screen
	je clear_screen_end

    ; Reimplemented so that we don't need to depend on print_string_pm to be loaded in boot sect
    ; and also reduces cycles as we know what's being printed and where ahead of time
    mov [edx], ax ; Write into video memory

	add ebx, 1
    add edx, 2
	jmp clear_screen_loop

clear_screen_end:
    popa
    ret

%endif