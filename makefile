# $^ is all dependencies
# $< is first dependency
# $@ is target file

C_SOURCES = $(wildcard src/kernel/*.c src/drivers/*.c)
HEADERS = $(wildcard src/kernel/*.h src/drivers/*.h)
OBJ = ${C_SOURCES:.c=.o} # Generate list of object files by replacing file extensions in list of C files

all : os-image clean# Fake target, first rule is run if make is called without a target so running just 'make' will target os-image

run : all # command to startup bochs, not needed if you leave bochs running and restart it from the gui
	bochs


%.o : %.c # Compile all C files in place 
	gcc -target i386-none-elf -ffreestanding -c $< -o $@

%.bin : %.asm
	nasm $< -f bin -o $@

src/kernel/kernel_entry.o : src/kernel/kernel_entry.asm
	nasm $< -f elf -o $@

src/kernel/kernel.bin : src/kernel/kernel_entry.o ${OBJ}
	i386-elf-ld -o $@ -Ttext 0x1000 $^ --oformat binary

os-image : src/boot/boot_sect.bin src/kernel/kernel.bin
	cat $^ > $@


clean : 
	rm src/**/*.bin src/**/*.o