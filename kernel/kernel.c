/* Agix Kernel
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

#include <stdbool.h>
#include <stddef.h>

#include "../usr/include/io.h"

#define VGA_WIDTH 80
#define VGA_HEIGHT 25
#define VGA_MEMORY 0xB8000

extern unsigned short ps2Controller();

enum vgaColor {
  BLACK = 0,
  BLUE = 1,
  GREEN = 2,
  CYAN = 3,
  RED = 4,
  MAGENTA = 5,
  BROWN = 6,
  LIGHT_GREY = 7,
  DARK_GREY = 8,
  LIGHT_BLUE = 9,
  LIGHT_GREEN = 10,
  LIGHT_CYAN = 11,
  LIGHT_RED = 12,
  LIGHT_MAGENTA = 13,
  LIGHT_BROWN = 14,
  WHITE = 15,
};

size_t terminalRow;
size_t terminalColumn;
unsigned char terminalColor;
unsigned short* terminalBuffer = (unsigned short*) VGA_MEMORY;

static inline unsigned char vgaEntryColor(enum vgaColor foreground, enum vgaColor background)
{
  return foreground | background << 4;
}

static inline unsigned short vgaEntry(unsigned char uc, unsigned char color)
{
  return (unsigned short) uc | (unsigned short) color << 8;
}

size_t strlen(const char* str)
{
  size_t len = 0;
  while ( str[len] ) len++;
  return len;
}

void terminalInitialize(void)
{
  terminalRow = 0;
  terminalColumn = 0;
  terminalColor = vgaEntryColor(LIGHT_GREY, BLACK);

  for ( size_t y = 0; y < VGA_HEIGHT; ++y ) {
    for ( size_t x = 0; x < VGA_WIDTH; ++x ) {
      const size_t index = y * VGA_WIDTH + x;
      terminalBuffer[index] = vgaEntry(' ', terminalColor);
    }
  }
}

void terminalSetColor(uint8_t color)
{
  terminalColor = color;
}

void terminalPutEntryAt(char c, unsigned char color, size_t x, size_t y)
{
  const size_t index = y * VGA_WIDTH + x;
  terminalBuffer[index] = vgaEntry(c, color);
}

void terminalPutChar(char c)
{
  switch ( c ) {
  case '\0':
    return;
  case '\a':
    terminalSetColor(RED);
    return;
  case '\b':
    if ( terminalColumn > 0 ) {
      --terminalColumn;
      terminalPutChar(' ');
      --terminalColumn;
    }
    else if ( terminalRow > 0 ) {
      --terminalRow;
      terminalColumn = 80;
      terminalPutChar(' ');
      --terminalRow;
      terminalColumn = 80;
    }
    return;
  case '\t':
    for ( int i = 0; i < 8; ++i ) terminalPutChar(' ');
    return;
  case '\n':
    terminalColumn = 0;
    ++terminalRow;
    return;
  case '\v':
    ++terminalColumn;
    ++terminalRow;
    return;
  case '\f':
    terminalColumn = 0;
    terminalRow = 0;
    return;
  case '\r':
    terminalColumn = 0;
    return;
  }

  terminalPutEntryAt(c, terminalColor, terminalColumn, terminalRow);
  if ( ++terminalColumn == VGA_WIDTH ) {
    terminalColumn = 0;
    if ( ++terminalRow == VGA_HEIGHT ) terminalRow = 0;
  }
}

void terminalWrite(const char* data, size_t size)
{
  for ( size_t i = 0; i < size; ++i ) terminalPutChar(data[i]);
}

void terminalWriteString(const char* data)
{
  terminalWrite(data, strlen(data));
}

void kernel_main(void)
{
  terminalInitialize();

  while ( true ) {
    unsigned short ps2Ret = ps2Controller();
    ps2Ret >>= 8;
    unsigned char ascii = (unsigned char) ps2Ret;
    ascii &= 0b01111111;
    terminalPutChar(ascii); 
  }
}
