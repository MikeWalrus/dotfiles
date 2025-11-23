#! /usr/bin/bash

kernel_params=(
    root=LABEL=archlinux rw
    loglevel=3
    i8042.dumbkbd
    nowatchdog
    'initrd=\initramfs-linux-mainline-uring-mock.img'
)
# 'initrd=\intel-ucode.img' This is not needed anymore.
# See https://archlinux.org/news/mkinitcpio-hook-migration-and-early-microcode/

efibootmgr --create \
    --disk /dev/nvme0n1 \
    --part 1 \
    --label "Arch Linux linux-mainline-uring-mock" \
    --loader '\vmlinuz-linux-mainline-uring-mock' \
    --unicode \
    "${kernel_params[*]}"
