#!/bin/zsh

# May need to modify later to allow passing the start address to gobjcopy,
# either a second required paramter or optional with a flag 

sourceFileName=$1
stringLength=${#sourceFileName}
if [ ${stringLength} -gt 0 ]; then # Check argument is passed
    if [ ${sourceFileName:${stringLength}-2} = '.c' ]; then # Check file extension is .c
        objectFileName="${sourceFileName:0:${stringLength}-2}.o"
        binFileName="${sourceFileName:0:${stringLength}-2}.bin"
        gcc -target i386-none-elf -ffreestanding -c ${sourceFileName} -o ${objectFileName} 2> /dev/null
        gobjcopy -O binary ${objectFileName} ${binFileName}
    else
        echo 'Pass a C source code file to compile to raw binary'
        exit 1
    fi
else
    echo 'Pass a C source code file to compile to raw binary'
    exit 1
fi