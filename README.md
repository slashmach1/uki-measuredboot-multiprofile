# uki-measuredboot-multiprofile
A set of scripts and configuration files for setting up BTRFS snapshots utilizing both multi-profile UKI and measured boot on fedora
NOTE: not written with the help of any online or local AI although it may have been better or cleaner with some assistance.... XD

Workflow:
Everytime the system boots or a new package is installed/updated it creates a new snapshot with a new uki incorporating the latest snapshots as UKI profiles.  This allows one kernel binary to boot any of your most recent snapshots while preserving measured/verified boot in most cases.  For existing kernels the tpm-rearm service updates the pcr values for measured/verified boot so you no longer have to enter the password so long as you are booting the same kernel version.  The only time you should have to is when the booted kernel changes.  

Installation:
This guide makes a few assumptions.
1. You are utilizing fedora, systemd-boot for uki handling, snapper, and the DNF package manager.  Adaptions must be made for this to work if it is not the case for you.
  
2. The btrfs root filesystem is its own subvolume labeled root.  If you are using timeshift vs snapper please change this to @root and come up with your own timeshift config for the snapshots.  The UKI services and systemd may need some fixes for timeshift as well but I have not looked at that.
  
3. You are using sbctl to sign the kernel and uki for secure boot.  Also the necessary keys specified in the uki.conf must be created by you.  This can be done in the terminal by executing the following

 sudo ukify genkey --pcr-private-key=/etc/systemd/tpm2-pcr-private-key.pem --pcr-public-key=/etc/systemd/tpm2-pcr-public-key.pem
 
 sudo ukify genkey --pcr-private-key=/etc/systemd/pcr_policy_initrd_private.key --pcr-public-key=/etc/systemd/pcr_policy_initrd_public.key

4. install the package yq.  This is used for some json parsing the snapshot labels.

The directory structure for the necessary configs has been preserved in the repo.  Simply copy the files in the /usr/bin folder to the corresponding folder on your machine and chmod +x all those files you copy.  Copy the configs (making updates changes as needed if any of 1,2,3, or 4 are not the case for you and your chosen distro. to the corresponding /etc directories.  Enable the systemd service tpm2-rearm.service.

Configuration:
The uki_post_generate script variable at the top labeled CHECKPOINTS is the number of snapshots you wish to keep.  Feel free to change that if you need.

Closing:
Feel free to adapt or change this to suite your needs.  I will offer support off the top of my head but please do not expect 1:1 troubleshooting or package maintenance for your use case.  
