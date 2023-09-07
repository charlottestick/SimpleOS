; Usage:
;   mov ebx, string label
;   mov edx, screen position
;   call print_string_pm
;
;   %include "print_string_pm.asm"
;
;string_label:
;	db "String to print", 0

; Could potentially implement position parameter by setting edx to the position and 
; adding VIDEO_MEMORY to edx instead of overwriting it
; Param would have to be required to ensure that we aren't interpreting junk left in the register as a position

; How wide is each character, i.e. what mulitples represent each position on the screen?
; edx is incremented by 2, must be mulitples of 2
; Calling code could store position to print x 2 as base 10 and it should figure out what the number will be in 
; base 2 when adding a base 2 number

; What are the dimensions of the screen, i.e. what mulitples represent one line below and what is off screen?
; 80 characters wide, add 160 to jump to same position on next line, integer divide result by 160 to get start of next line?
; 25 characters tall, but don't forget zero index
%ifndef PRINT_STRING_PM_H
%define PRINT_STRING_PM_H

[bits 32]
VIDEO_MEMORY equ 0xb8000 ; Defining constants, VIDEO_MEMORY is the start address of video memory
WHITE_ON_BLACK equ 0x0f ; This is the attribute value for a white character on a black backgound

print_string_pm:
    pusha
    mov eax, 2
    mul edx ; mulitpies by and stores to eax
    mov edx, eax
    add edx, VIDEO_MEMORY ; Set edx to the position in video memory we want to write to
    mov ah, WHITE_ON_BLACK ; store the character attribute to ah

print_string_pm_loop:
    mov al, [ebx] ; store the character value in ebx to al

    cmp al, 0 ; exit if zero
    je print_string_pm_end

    mov [edx], ax ; store the character and attribute to the address held by edx

    add ebx, 1 ; Increment to get next character in string
    add edx, 2 ; Increment to get next position in video memory
    jmp print_string_pm_loop

print_string_pm_end:
    popa
    ret

%endif