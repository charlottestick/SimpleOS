# $^ is all dependencies
# $< is first dependency
# $@ is target file

all : os-image # Fake target, first rule is run if make is called without a target so running just 'make' will target os-image

run : all # command to startup bochs, not needed if you leave bochs running and restart it from the gui
	bochs


boot_sect.bin : boot_sect.asm
	nasm $< -f bin -o $@

kernel_entry.o : kernel_entry.asm
	nasm $< -f elf -o $@

kernel.o : kernel.c
	gcc -target i386-none-elf -ffreestanding -c $< -o $@

kernel.bin : kernel_entry.o kernel.o
	i386-elf-ld -o $@ -Ttext 0x1000 $^ --oformat binary

os-image : boot_sect.bin kernel.bin
	cat $^ > $@


clean : 
	rm *.bin *.o