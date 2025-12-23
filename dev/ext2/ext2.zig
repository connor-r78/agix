//! ext2 Driver
//! Copyright (C) 2025 Connor Rakov
//!
//! This program is free software: you can redistribute it and/or modify
//! it under the terms of the GNU General Public License as published by
//! the Free Software Foundation, either version 3 of the License, or
//! (at your option) any later version.
//!
//! This program is distributed in the hope that it will be useful,
//! but WITHOUT ANY WARRANTY; without even the implied warranty of
//! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//! GNU General Public License for more details.
//!
//! You should have received a copy of the GNU General Public License
//! along with this program.  If not, see <https://www.gnu.org/licenses/>.

extern fn inb(port: u16) u8;
extern fn outb(port: u16, val: u8) i32;

const READ: u8 = 0;
const WRITE: u8 = 1;

const err = error{EINVAL};

const Superblock = struct {
    inodes: u32,
    blocks: u32,
    su_blocks: u32,
    unalloc_blocks: u32,
    unalloc_inodes: u32,
    block: u32,
    block_size_log: u32,
    fragment_size_log: u32,
    blocks_per_group: u32,
    fragments_per_group: u32,
    inodes_per_group: u32,
    last_mount_time: u32,
    last_written_time: u32,
    mounts_since_check: u16,
    mounts_allowed_before_check: u16,
    signature: u16,
    state: u16,
    error_now_what: u16,
    minor_version: u16,
    last_check_time: u32,
    os: u32,
    major_version: u32,
    user_id: u16,
    group_id: u16,

    first_nonreserved_inode: u32,
    inode_size: u16,
    block_group: u16,
    opt_features: u32,
    req_features: u32,
    read_only_features: u32,
    blkid: [16]u8,
    vol_name: [16]u8,
    path_last_mounted: [64]u8,
    compression_used: u32,
    blocks_to_prealloc_files: u8,
    blocks_to_prealloc_dirs: u8,
    journal_id: [16]u8,
    journal_inode: u32,
    journal_dev: u32,
    head_orphan_inodes: u32,
};

const Block = struct {
    addr_block_usage: u32,
    addr_inode_usage: u32,
    starting_inode_addr: u32,
    unalloc_blocks: u32,
    unalloc_inodes: u32,
    dirs: u32,
};

fn insw(port: u16, buffer: [*]u16, count: u32) void {
    asm volatile (
        \\ rep insw
        :
        : [port] "{dx}" (port),
          [buf] "{di}" (buffer),
          [cnt] "{cx}" (count),
        : .{ .memory = true });
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

fn _fio(mode: u8, lba: u64, sectorcount: u16) ![*]u16 {
    _ = outb(0x1F6, 0x40);
    _ = outb(0x1F2, @as(u8, @intCast(sectorcount >> 8)));
    _ = outb(0x1F3, @as(u8, @intCast(lba & 0xFF)));
    _ = outb(0x1F4, @as(u8, @intCast((lba >> 8) & 0xFF)));
    _ = outb(0x1F5, @as(u8, @intCast((lba >> 16) & 0xFF)));
    _ = outb(0x1F2, @as(u8, @intCast(sectorcount & 0xFF)));
    _ = outb(0x1F3, @as(u8, @intCast((lba >> 24) & 0xFF)));
    _ = outb(0x1F4, @as(u8, @intCast((lba >> 32) & 0xFF)));
    _ = outb(0x1F5, @as(u8, @intCast((lba >> 40) & 0xFF)));

    _ = switch (mode) {
        READ => outb(0x1F7, 0x24),
        WRITE => outb(0x1F7, 0x34),
        else => return err.EINVAL,
    };

    var buf: [256]u16 = undefined;
    insw(0x1F0, &buf, 256);

    return &buf;
}

export fn fio(mode: u8, lba: u64, sectorcount: u16) ?[*]u16 {
    return _fio(mode, lba, sectorcount) catch null;
}
