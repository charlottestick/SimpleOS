; Usage:
;   mov dh, number_of_sectors
;   mov dl, boot_drive
;   mov bx, segment_to_load_to
;   mov es, bx
;   mov bx, address_to_load_to
;   call disk_load
;
;   %include "disk_load.asm"
%ifndef DISK_LOAD_H
%define DISK_LOAD_H

disk_load:
	push dx ; push dx to stack so we can check number of sectors read later
    mov al, dh ; sectors to read

	mov ch, 0x00 ; Cylinder, 1 is first
	mov dh, 0x00 ; Head, 0 is first
	mov cl, 0x02 ; Sector, 1 is first, 0x02 is the next sector after the boot sector


	mov ah, 0x02
	int 0x13

	jc disk_error ; jump if carry flag set, set on general error
	pop dx
	cmp dh, al
	jne read_error ; jump if number of sectors read is less than we asked for
    ret

disk_error:
	mov bx, DISK_ERROR_MSG
	call print_string
    jmp $

read_error:
    mov bx, READ_ERROR_MSG
    call print_string
    jmp $

DISK_ERROR_MSG:
	db "Disk error!", 0

READ_ERROR_MSG:
    db "Read error!", 0

%endif