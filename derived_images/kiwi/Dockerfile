FROM opensuse:13.1
MAINTAINER Flavio Castelli <fcastelli@suse.com>

# Latest KIWI packages
RUN zypper ar -f http://download.opensuse.org/repositories/Virtualization:/Appliances/openSUSE_13.1/ virtualization:appliances

# make sure the package repository is up to date
RUN zypper --non-interactive --gpg-auto-import-keys ref

# Install kiwi and remove the conflicting packages, otherwise zypper will stop here
RUN zypper in -y kiwi -libudev-mini1 -udev-mini

# Required to build SLE11 images on a recent system like 13.1
RUN zypper in -y  db45-utils

# Required to access Novell Customer Center servers over HTTPS
RUN zypper in -y ca-certificates

# Required by KIWI to compress the image
RUN zypper in -y tar bzip2

# Always start kiwi
ENTRYPOINT ["/usr/sbin/kiwi"]
