#!/bin/zsh

# addressOffset might have to be the first param to allow mulitple files to be linked 
# Or it could just be hardcoded to the kernel offset

# Usage: ./compile.sh filename.c addressOffset

# Current setup can only comile one C file, there is no linking involved
# This is going to be migrated into a makefile instead of a script to abstract which files source files are expected etc
# I'll leave this script in as is to help woth comiling the understandingCCompilation experiments

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