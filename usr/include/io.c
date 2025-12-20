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
   along with this program.  If not, see <https://www.gnu.org/licenses/>. */

#include "io.h"

extern void terminalPutChar(char c);

uint8_t inb(uint16_t port)
{
  uint8_t ret;
  __asm__ volatile ( "inb %w1, %b0"
    : "=a" (ret)
    : "Nd" (port)
    : "memory");
  return ret;
}
 
void outb(uint16_t port, uint8_t val)
{
   __asm__ volatile ("outb %b0, %w1" : : "a" (val), "Nd" (port) : "memory");
}

void printc(char c)
{
  terminalPutChar(c);
}
