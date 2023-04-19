# Running the project
Using bochs as an x86 emulator, this is setup with .bochsrc to boot with `boot_sect.bin` or `os-image`, so you just have to run `bochs`, run the default option when it gives you a CLI menu, then press `c` for continue once it's loaded up to open the gui

Assemble low level code to boot_sect.bin to run the different programs from different points in the tutorial.

Compile high level code by running `./compile.sh <filename>.c`

Assemble low level code by running `nasm <filename>.asm -f bin -o boot_sect.bin`

Combine into an os image by running `cat boot_sect.bin kernel.bin > os-image`