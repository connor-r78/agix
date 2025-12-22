/* Agix Kernel I/O Library
   Copyright (C) 2025 Connor Rakov

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>. 

   The I/O library is intended to be used by device drivers. It is the main 
   method of gaining access to kernel space. */

#include "io.h"

extern void terminalPutChar(char c);

unsigned char inb(unsigned short port)
{
  unsigned char ret;
  __asm__ volatile ( "inb %w1, %b0"
    : "=a" (ret)
    : "Nd" (port)
    : "memory");
  return ret;
}
 
int outb(unsigned short port, unsigned char val)
{
  __asm__ volatile ("outb %b0, %w1" : : "a" (val), "Nd" (port) : "memory");
  return 0;
}

int printc(char c)
{
  terminalPutChar(c);
  return 0;
}

int print(char* str, int length)
{
  for ( int i = 0; i < length; ++i ) {
    printc(str[i]);
  }
}
