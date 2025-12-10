#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

#define VGA_WIDTH 80
#define VGA_HEIGHT 25
#define VGA_MEMORY 0xB8000

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
uint8_t terminalColor;
uint16_t* terminalBuffer = (uint16_t*) VGA_MEMORY;

static inline uint8_t vgaEntryColor(enum vgaColor foreground, enum vgaColor background)
{
  return foreground | background << 4;
}

static inline uint16_t vgaEntry(unsigned char uc, uint8_t color)
{
  return (uint16_t) uc | (uint16_t) color << 8;
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

void terminalPutEntryAt(char c, uint8_t color, size_t x, size_t y)
{
  const size_t index = y * VGA_WIDTH + x;
  terminalBuffer[index] = vgaEntry(c, color);
}

void terminalPutChar(char c)
{
  switch ( c ) {
  case '\0':
    ++terminalColumn;
    return;
  case '\a':
    terminalSetColor(RED);
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

  terminalPutChar(ps2ReadScancode());
}
