[bits 16] ; Tell assembler that instructions are to be encoded as 16 bit from here onwards
    
switch_to_pm:
    cli ; Tell CPU to ignore interrupts so tht we can handle them differently in 32 bit mode
	lgdt [gdt_descriptor] ; Tell CPU the location of our gdt descriptor

	mov eax, cr0 ; Get copy of control register contents
	or eax, 0x1 ; OR mask to set the first bit to 1
	mov cr0, eax ; move modified contents back to conrtol register, CPU is now in 32 bit protected mode

	jmp CODE_SEG:init_pm ; We make a far jump to force the CPU to flush the pipeline and ensure that all code is 32 bit when we enter 32 bit mode


[bits 32] ; Now we can switch to 32 bit instruction encoding

init_pm:
    mov ax, DATA_SEG ; Segment method has changed so old segments need to be overwritten
    mov ds, ax ; For now everything can point to the data segment
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov ebp, 0x90000 ; Change the stack to sit at the top of our free space
    mov esp, ebp

    call BEGIN_PM