# Running the project
Copy one of the example bochsrc files to create a bochsrc depending on your host OS, the main difference is that mac needs a different display library setting.

The project uses bochs as an x86 emulator and is setup to boot with `os-image` so you just have to run `bochs`, accept the default option when it gives you a CLI menu, then enter `c` for continue once it's loaded up to open the gui.

Once loaded you can leave bochs running when you make code changes, just press restart in the gui to boot with the latest os-image

# Exploring older code
Compile a single C file by running `./compile.sh <filename>.c`

Assemble low level code by running `nasm <filename>.asm -f bin -o boot_sect.bin`

# Development

## Prerequisite
- nasm
- make
- bochs
- i386-elf-ld
- gcc with -target option or i386-elf-gcc

We need the GNU linker with i386-elf as the target, as the mac version of ld is very different from the linux one. Usually you'd have to compile this yourself, however someone made homebrew formula to automate this.

Install the cross-linker by running:
`brew tap nativeos/i386-elf-toolchain`
`brew install i386-elf-binutils`

The linker is included in the binutils. On mac, gcc has a target option which is set to 1386 & elf so we don't need the i386-elf-gcc included (i386-elf-gcc also had issues cross-compiling on M1 mac)

On linux, gcc doesn't have a target option so we need the cross compiled i386-elf version. The included brew formula for this may be broken and need `gmp`, `mpfr`, and `mpc` paths added to the config using `brew edit i386-elf-gcc` and adding `--with-{library}-lib=/usr/lib` options for all three

Install the cross compiled gcc by running:
`brew install i386-elf-gcc`

## Build
Build by running `make` or `make os-image`

Build and start bochs by running `make run`