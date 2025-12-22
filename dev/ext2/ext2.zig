//! ext2 Driver
//! Copyright (C) 2025 Connor Rakov
//! This program is free software: you can redistribute it and/or modify
//! it under the terms of the GNU General Public License as published by
//! the Free Software Foundation, either version 3 of the License, or
//! (at your option) any later version.
//! This program is distributed in the hope that it will be useful,
//! but WITHOUT ANY WARRANTY; without even the implied warranty of
//! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//! GNU General Public License for more details.
//! You should have received a copy of the GNU General Public License
//! along with this program.  If not, see <https://www.gnu.org/licenses/>.

extern fn inb(port: u16) u8;
extern fn outb(port: u16, val: u8) i32;

const Superblock = struct {
    inodes: u32,
    blocks: u32,
    suBlocks: u32,
    unAllocBlocks: u32,
    unAllocInodes: u32,
    superblockBlock: u32,
    blockSizeLog: u32,
    fragmentSizeLog: u32,
    blocksPerGroup: u32,
    fragmentsPerGroup: u32,
    inodesPerGroup: u32,
    lastMountTime: u32,
    lastWrittenTime: u32,
    mountsSinceCheck: u16,
    mountsAllowedBeforeCheck: u16,
    signature: u16,
    state: u16,
    errorNowWhat: u16,
    minorVersion: u16,
    lastCheckTime: u32,
    os: u32,
    majorVersion: u32,
    userID: u16,
    groupID: u16,

    firstNonreservedInode: u32,
    inodeSize: u16,
    blockGroup: u16,
    optFeatures: u32,
    reqFeatures: u32,
    readonlyFeatures: u32,
    blkid: [16]u8,
    volName: [16]u8,
    pathLastMounted: [64]u8,
    compressionUsed: u32,
    blocksToPreallocFiles: u8,
    blocksToPreallocDirs: u8,
    journalID: [16]u8,
    journalInode: u32,
    journalDev: u32,
    headOrphanInodes: u32,
};

const Block = struct {
    addrBlockUsage: u32,
    addrInodeUsage: u32,
    startingInodeAddr: u32,
    unallocBlocks: u32,
    unallocInodes: u32,
    dirs: u32,
};

fn insw(port: u16, buffer: [*]u16, count: u32) void {
    asm volatile (
        \\ rep insw
        :
        : [port] "{dx}" (port),
          [buf] "{di}" (buffer),
          [cnt] "{cx}" (count),
        : .{ .memory = true }
    );
}

export fn finit() u8 {
    _ = outb(0x1F6, 0xA0);
    _ = outb(0x1F2, 0x0);
    _ = outb(0x1F3, 0x0);
    _ = outb(0x1F4, 0x0);
    _ = outb(0x1F5, 0x0);
    _ = outb(0x1F7, 0xEC);
    while ((inb(0x1F7) & 0b1000_0000) != 0) {}
    return inb(0x1F7);
}

export fn fread(lba: u8, sectorcount: u16) [*]u16 {
    _ = outb(0x1F6, 0xE0);
    _ = outb(0x1F2, @as(u8, @intCast(sectorcount >> 8)));
    _ = outb(0x1F3, lba & 0b0000_1000);
    _ = outb(0x1F4, lba & 0b0001_0000);
    _ = outb(0x1F5, lba & 0b0010_0000);
    _ = outb(0x1F2, @as(u8, @intCast(sectorcount & 0xFF_00)));
    _ = outb(0x1F3, lba & 0b0000_0001);
    _ = outb(0x1F4, lba & 0b0000_0010);
    _ = outb(0x1F5, lba & 0b0000_0100);
    _ = outb(0x1F7, 0x24);

    var buf: [256]u16 = undefined;
    insw(0x1F0, &buf, 256);

    return &buf;
}
