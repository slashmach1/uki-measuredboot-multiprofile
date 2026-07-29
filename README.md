# uki-measuredboot-multiprofile
A set of scripts and configuration files for setting up BTRFS snapshots utilizing both multi-profile UKI and measured boot on fedora

HOW IT WORKS:
Everytime the system boots the tpm2_rearm service runs to ensure the tpm is tracking the currently booted kernel version.  
DNF installations or updates each create a new snapshot and incorporates this snapshot into new uki as a UKI profile.  This allows one kernel UKI binary to boot any of your most recent snapshots (specified by the CHECKPOINTS variable in the uki_post_generate script).    
The only time you should have to reenter your luks password is when the booted kernel version or config changes.

Requirements:
1.  Fedora btrfs layout must have root and home partitions labeled root and home as distinct subvolumes (this is the default for fedoras parition installation on fedora 44).  any changes or customizations to those two partitions may break this guide.

2. Systemd boot configured with /efi as the boot partition.  the /etc/kernel/install.conf within the repo needs to be updated to your current efi parititon location if you have customized this or left it at the /boot/efi default for fedora.

3. Install sbctl however you choose.

Installation:
1. Clone this repo and execute:
cd uki-measuredboot-multiprofile && chmod +x usr/bin/* 
to allow you to execute all the scripts contained in the repo.  

2. execute this to copy the functional scripts (meaning not one time setup scripts):
sudo cp !(*.sh) /usr/bin/ -v

3. run the following for setting up LUKS prerequisites:
sudo usr/bin/generate_cryptsetup_keys.sh

4. run the snapper setup script:
sudo usr/bin/snapper_setup.sh

5. install necessary configs:
sudo cp etc/* /etc/ -rv

6. refresh dracut and kernel installation to generate the first UKI for your following boot:
sudo dracut -vf --regenerate-all && sudo dnf reinstall kernel*

7. OPTIONAL: refresh systemd and enable tpm2_rearm service if you wish to auto unlock when booting the same kernel version
sudo systemctl daemon-reload && sudo systemctl enable --now tpm2_rearm.service

8. OPTIONAL: add or update the following lines in /efi/loader/loader.conf so that you are able to view available snapshots upon booting
timeout  4
console-mode max

Configuration:
The uki_post_generate script contains a variable at the top labeled CHECKPOINTS.  This sets the number of snapshots you wish to keep.
