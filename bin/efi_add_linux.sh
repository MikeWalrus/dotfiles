#! /usr/bin/bash

kernel_params=(
    root=LABEL=archlinux rw
    loglevel=3
    i8042.dumbkbd
    nowatchdog
    'initrd=\initramfs-linux.img'
)
# 'initrd=\intel-ucode.img' This is not needed anymore.
# See https://archlinux.org/news/mkinitcpio-hook-migration-and-early-microcode/

echo efibootmgr --create \
    --disk /dev/nvme0n1 \
    --part 4 \
    --label "Arch Linux linux" \
    --loader '\vmlinuz-linux' \
    --unicode \
    "${kernel_params[*]}"
