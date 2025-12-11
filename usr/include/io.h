#ifndef _IO_H
#define _IO_H
#include <stdint.h>

uint8_t inb(uint16_t port);
void outb(uint16_t port, uint8_t val);
void printc(char c);

#endif
