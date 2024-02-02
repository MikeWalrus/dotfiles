#! /usr/bin/bash

kernel_params=(
    root=LABEL=archlinux rw
    loglevel=3
    i8042.dumbkbd
    nowatchdog
    'initrd=\intel-ucode.img'
    'initrd=\initramfs-linux.img'
)

efibootmgr --create \
    --disk /dev/nvme0n1 \
    --part 4 \
    --label "Arch Linux linux" \
    --loader '\vmlinuz-linux' \
    --unicode \
    "${kernel_params[*]}"
