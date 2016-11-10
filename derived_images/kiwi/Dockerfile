FROM opensuse:13.2
MAINTAINER Flavio Castelli <fcastelli@suse.com>

# Latest KIWI packages
RUN zypper ar -f http://download.opensuse.org/repositories/Virtualization:/Appliances/openSUSE_13.2/ virtualization:appliances

# make sure the package repository is up to date
RUN zypper --non-interactive --gpg-auto-import-keys ref

# Install kiwi and remove the conflicting packages, otherwise zypper will stop here
RUN zypper in -y kiwi kiwi-tools -libudev-mini1 -udev-mini

# Install kiwi boot image descriptions
RUN zypper in -y kiwi-desc-isoboot kiwi-desc-netboot kiwi-desc-oemboot kiwi-desc-vmxboot

# Install kiwi templates
RUN zypper in -y kiwi-templates

# Install core tool chain for image building
RUN zypper in -y tar bzip2 grub2 dracut cpio lvm2 parted rsync btrfsprogs genisoimage squashfs

# Install sudo, not for docker but because kiwi calls it in code
RUN zypper in -y sudo

# Required to build SLE11 images on a recent system like 13.1
RUN zypper in -y db45-utils

# Required to access Novell Customer Center servers over HTTPS
RUN zypper in -y ca-certificates

# start kiwi by default if no other entrypoint is set
ENTRYPOINT ["/usr/sbin/kiwi"]
