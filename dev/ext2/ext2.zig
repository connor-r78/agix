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

const Superblock = struct {
  inodes: u32,
  blocks: u32,
  suBlocks: u32,
  unAllocBlocks: u32,
  unAllocInodes: u32,
  superblockBlock: u32,
  blockSizeLog: u32,
  fragmentSize: u32,
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
}

const Block = struct {
  addrBlockUsage: u32,
  addrInodeUsage: u32,
  startingInodeAddr: u32,
  unallocBlocks: u32,
  unallocInodes: u32,
  dirs: u32,
}
