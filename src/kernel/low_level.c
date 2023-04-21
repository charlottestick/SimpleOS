#include "low_level.h"

unsigned char port_byte_in(unsigned short port) {
    // C wrapper for some assembly codeto read a byte from the given port

    // This assembly is in GAS syntax not NASM syntax, destination register comes before target
    // in reads the contents of the port in dx (always dx) 
    // "=a" (result) says to put the value of ax in result after running the assembly
    // "d" (port) says to store the value of port in dx before running the assembly
    // %% is because percent symbol is a C escape character and GAS syntax prefixes registers with %
    unsigned char result;
    __asm__("in %%dx, %%al" : "=a" (result) : "d" (port));
    return result;
}

unsigned short port_word_in(unsigned short port)
{
    //  Wrapper to read a word from the given port
    unsigned short result;
    __asm__("in %%dx, %%ax" : "=a"(result) : "d"(port));
    return result;
}

void port_byte_out(unsigned short port, unsigned char data) {
    // Wrapper to write a byte to the given port
    // Weird argument syntax below
    // code : registerOutputs : registerInputs
    // Therefore we have empty double colons below as we're not reading anything from the registers
    __asm__("out %%al, %%dx" : : "a" (data), "d" (port));
}

void port_word_out(unsigned short port, unsigned short data)
{
    // Wrapper to write a byte to the given port
    __asm__("out %%ax, %%dx" : : "a"(data), "d"(port));
}