#!/bin/sh
efibootmgr --disk /dev/sda --part 1 --create --label "Arch Linux" --loader /vmlinuz-linux --unicode 'root=/dev/JCoMcLZBook/root rw initrd=\intel-ucode.img initrd=\initramfs-linux.img' --verbose
#PARTUUID=52dbbef8-dcc1-4e26-8531-37cfb5b3f272 

