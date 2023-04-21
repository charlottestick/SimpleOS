#ifndef LOW_LEVEL_H // Only include header contents once even if the header file is included more than once
#define LOW_LEVEL_H

unsigned char port_byte_in(unsigned short port);
unsigned short port_word_in(unsigned short port);
void port_byte_out(unsigned short port, unsigned char data);
void port_word_out(unsigned short port, unsigned short data);

#endif