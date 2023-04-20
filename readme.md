# Running the project
Using bochs as an x86 emulator, this is setup with .bochsrc to boot with `os-image`, so you just have to run `bochs`, run the default option when it gives you a CLI menu, then press `c` for continue once it's loaded up to open the gui.

Once loaded you can leave bochs running when you make code changes, just press restart in the gui to boot with the latest os-image

# Exploring older code
Compile a single C file by running `./compile.sh <filename>.c`

Assemble low level code by running `nasm <filename>.asm -f bin -o boot_sect.bin`

# Development

## Prerequisite
We need the GNU linker with i386-elf as the target, as the mac version of ld is very different from the linux one. Usually you'd have to compile this yourself, however someone made homebrew formula to automate this.

Install the cross-linker by running:
`brew tap nativeos/i386-elf-toolchain`
`brew install i386-elf-binutils`

The linker is included in the binutils. On mac, gcc has a target option which is set to 1386 & elf so we don't need the 1386-elf-gcc included (1386-elf-gcc also had issues cross-compiling on M1 mac)

## Build
Build by running `make` or `make os-image`

Build and start bochs by running `make run`