#! /usr/bin/bash

kernel_params=(
    root=LABEL=archlinux rw
    loglevel=3
    i8042.dumbkbd
    nowatchdog
    'initrd=\initramfs-linux-lts.img'
)
# 'initrd=\intel-ucode.img' This is not needed anymore.
# See https://archlinux.org/news/mkinitcpio-hook-migration-and-early-microcode/

efibootmgr --create \
    --disk /dev/nvme0n1 \
    --part 1 \
    --label "Arch Linux linux-lts" \
    --loader '\vmlinuz-linux-lts' \
    --unicode \
    "${kernel_params[*]}"
