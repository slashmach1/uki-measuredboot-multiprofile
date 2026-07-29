#!/bin/bash
#snapper setup
dnf install snapper libdnf5-plugin-actions btrfs-assistant inotify-tools git make -y
snapper -c root create-config /
snapper -c home create-config /home
restorecon -RFv /.snapshots
restorecon -RFv /home/.snapshots
snapper -c root set-config ALLOW_USERS=$USER SYNC_ACL=yes
snapper -c home set-config ALLOW_USERS=$USER SYNC_ACL=yes
echo 'PRUNENAMES = ".snapshots"' | tee -a /etc/updatedb.conf
snapper -c home set-config TIMELINE_CREATE=no
systemctl enable --now snapper-cleanup.timer
systemctl enable --now snapper-boot.timer
