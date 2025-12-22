dd if=/dev/zero of=disk.img bs=1m count=16
/opt/homebrew/Cellar/e2fsprogs/1.47.3/sbin/mkfs.ext2 disk.img

qemu-system-i386 -drive format=raw,file=disk.img -kernel agix.bin -m 128M
