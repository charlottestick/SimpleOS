[bits 32]
VIDEO_MEMORY equ 0xb8000 ; Defining constants, VIDEO_MEMORY is the start address of video memory
WHITE_ON_BLACK equ 0x0f ; This is the attribute value for a white character on a black backgound

print_string_pm:
    pusha
    mov edx, VIDEO_MEMORY ; Set edx to the position in video memory we want to write to

print_string_pm_loop:
    mov al, [ebx] ; store the character value in ebx to al
    mov ah, WHITE_ON_BLACK ; store the attribute to ah

    cmp al, 0 ; exit if zero
    je print_string_pm_done

    mov [edx], ax ; store the character and attribute to the address held by edx
    add ebx, 1 ; Increment to get next character in string
    add edx, 2 ; Increment to get next position in video memory

    jmp print_string_pm_loop

print_string_pm_done:
    popa
    ret