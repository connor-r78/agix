cd ../dev/ext2
./ext2.zsh

cd ../ps2
./ps2.zsh

cd ../../usr/include
./io.zsh

cd ../../kernel
i686-elf-as boot.s -o boot.o
i686-elf-gcc -c kernel.c -o kernel.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra
i686-elf-gcc -T linker.ld -o agix.bin -ffreestanding -O2 -nostdlib boot.o kernel.o ../usr/include/io.o ../dev/ps2/ps2.o ../dev/ext2/ext2.o -lgcc
