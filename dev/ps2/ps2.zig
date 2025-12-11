extern fn inb(port: u16) u8;
extern fn printc(c: u8) void;

const left_alt: u16 = 0b1000000000000;
const right_alt: u16 = 0b0100000000000;
const left_ctrl: u16 = 0b0010000000000;
const right_ctrl: u16 = 0b0001000000000;
const left_shift: u16 = 0b0000100000000;
const right_shift: u16 = 0b0000010000000;

var ctrl: u16 = 0;

fn convertToASCII(char: u16) u16
{
  var ret: u8 = char;
  if ( char == 0x1 ) ret += 0x1A;
  if ( char >= 0x2 and char <= 0x0A ) ret += 0x2F;
  if ( char == 0x0B ) ret += 0x25;
  if ( char == 0x0C ) ret += 0x21;
  if ( char == 0x0D ) ret += 0x30;
  if ( char >= 0x0E and char <= 0x0F ) ret -= 0x6;

  if ( char == 0x10 ) ret = 0x71;  
  if ( char == 0x11 ) ret = 0x77;
  if ( char == 0x12 ) ret = 0x45;
  if ( char == 0x13 ) ret = 0x52;
  if ( char == 0x14 ) ret = 0x54;
  if ( char == 0x15 ) ret = 0x59;
  if ( char == 0x16 ) ret = 0x55;
  if ( char == 0x17 ) ret = 0x49;
  if ( char == 0x18 ) ret = 0x4F;
  if ( char == 0x19 ) ret = 0x50;
  
  return ret;
}

export fn ps2Controller() u16
{
  while ( (inb(0x64) & 1) == 0 ) {}
  var c: u16 = @intcast(convertToASCII(inb(0x60)));
  c = c | ctrl;
  return ;
}
