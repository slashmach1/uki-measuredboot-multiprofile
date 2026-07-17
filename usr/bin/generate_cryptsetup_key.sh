#!/bin/bash
LUKS_DEVICE="/dev/$(findmnt / -rvno SOURCE | xargs realpath --relative-to /dev | xargs -I{} ls /sys/block/{}/slaves/)"
LUKS_UUID=$(blkid -s UUID -o value $LUKS_DEVICE)
mkdir -v /etc/cryptsetup-keys.d
dd if=/dev/random of=/etc/cryptsetup-keys.d/luks-${LUKS_UUID}.key bs=512 count=8
chmod -c 0400 /etc/cryptsetup-keys.d/luks-${LUKS_UUID}.key
cryptsetup luksAddKey /dev/disk/by-uuid/${LUKS_UUID} /etc/cryptsetup-keys.d/luks-${LUKS_UUID}.key
