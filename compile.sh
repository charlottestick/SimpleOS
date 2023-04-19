#!/bin/zsh

# May need to modify later to allow passing the start address to gobjcopy,
# either a second required parameter or optional with a flag 

# Could also pass the output filename as parameter

# Usage: ./compile.sh filename.c addressOffset

sourceFileName=$1
addressOffset=$2
stringLength=${#sourceFileName}

if [ ${#addressOffset} -lt 1 ]; then
    addressOffset=0x0
fi

if [ ${stringLength} -gt 0 ]; then # Check argument is passed
    if [ ${sourceFileName:${stringLength}-2} = '.c' ]; then # Check file extension is .c
        objectFileName="${sourceFileName:0:${stringLength}-2}.o"
        binFileName="${sourceFileName:0:${stringLength}-2}.bin"
        gcc -target i386-none-elf -ffreestanding -c ${sourceFileName} -o ${objectFileName}
        gobjcopy -O binary --change-section-address ".text"=${addressOffset} ${objectFileName} ${binFileName}
    else
        echo 'Pass a C source code file to compile to raw binary'
        exit 1
    fi
else
    echo 'Pass a C source code file to compile to raw binary'
    exit 1
fi