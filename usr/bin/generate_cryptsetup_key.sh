#!/bin/bash
# Re-run the script with sudo if not already root
if [[ $EUID -ne 0 ]]; then
   echo "Elevating privileges..."
   exec sudo "$0" "$@"
fi

# Your actual script logic goes here
echo "Success: Running with root privileges."

# check secureboot state
if mokutil --sb-state | grep -q "enabled"; then
    echo "Secure Boot is enabled. Doing action..."
    # Put your action here
else
    echo "Secure Boot is disabled. Please enable secureboot to allow luks tpm unlock..."
fi

##generate uki.conf keys
echo "Generating uki.conf keys..."
ukify genkey --pcr-private-key=/etc/systemd/tpm2-pcr-private-key.pem --pcr-public-key=/etc/systemd/tpm2-pcr-public-key.pem
ukify genkey --pcr-private-key=/etc/systemd/pcr_policy_initrd_private.key --pcr-public-key=/etc/systemd/pcr_policy_initrd_public.key

##setup tpm rearm key to avoid entering the password when the service runs
echo "Generating cryptsetup key for passwordless root..."
LUKS_DEVICE="/dev/$(findmnt / -rvno SOURCE | xargs realpath --relative-to /dev | xargs -I{} ls /sys/block/{}/slaves/)"
LUKS_UUID=$(blkid -s UUID -o value $LUKS_DEVICE)
mkdir -v /etc/cryptsetup-keys.d
dd if=/dev/random of=/etc/cryptsetup-keys.d/luks-${LUKS_UUID}.key bs=512 count=8
chmod -c 0400 /etc/cryptsetup-keys.d/luks-${LUKS_UUID}.key
cryptsetup luksAddKey /dev/disk/by-uuid/${LUKS_UUID} /etc/cryptsetup-keys.d/luks-${LUKS_UUID}.key

##update crypttab to append tpm2 parameters
sed -i '0,/x-initrd.attach/s//x-initrd.attach,tpm2-device=auto,tpm2-measure-pcr=yes/' /etc/crypttab
