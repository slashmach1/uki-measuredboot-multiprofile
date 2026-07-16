# uki-measuredboot-multiprofile
A set of scripts and configuration files for setting up BTRFS snapshots utilizing both multi-profile UKI and measured boot on fedora
NOTE: not written with the help of any online or local AI although it may have been better or cleaner with some assistance.... XD

This guide makes a few assumptions.
1. You are utilizing fedora, systemd-boot for uki handling, snapper, and the DNF package manager.  Adaptions must be made for this to work if it is not the case for you.
  
2. The btrfs root filesystemm is its own subvolume labeled root.  If you are using timeshift vs snapper please change this to @root and come up with your own timeshift config for the snapshots.  The UKI services and systemd may need some fixes for timeshift as well but I have not looked at that.
  
3. You are using sbctl to sign the kernel and uki for secure boot.  Also the necessary keys specified in the uki.conf must be created by you.  This can be done in the terminal by executing the following
   
sudo ukify genkey --pcr-private-key=/etc/systemd/tpm2-pcr-private-key.pem --pcr-public-key=/etc/systemd/tpm2-pcr-public-key.pem

The directory structure for the necessary configs has been preserved in the repo.  Simply copy the files in the /usr/bin folder to the corresponding folder on your machine and chmod +x all those files you copy.  Copy the configs (making updates changes as needed if any of 1,2,or 3 are not the case for you and your chosen distro.
