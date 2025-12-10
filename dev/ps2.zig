const io = @cImport({
  @cInclude("io.h");
});

pub fn main() void
{
  while ( (io.inb(0x64) & 1) == 0 ) {}
  return io.inb(0x60);
}
