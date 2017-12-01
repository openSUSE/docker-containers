#!/bin/bash
#================
# FILE          : config.sh
#----------------
# PROJECT       : OpenSuSE KIWI Image System
# COPYRIGHT     : (c) 2013 SUSE LLC
#               :
# AUTHOR        : Robert Schweikert <rjschwei@suse.com>
#               :
# BELONGS TO    : Operating System images
#               :
# DESCRIPTION   : configuration script for SUSE based
#               : operating systems
#               :
#               :
# STATUS        : BETA
#----------------
#======================================
# Functions...
#--------------------------------------
test -f /.kconfig && . /.kconfig
test -f /.profile && . /.profile

#======================================
# Greeting...
#--------------------------------------
echo "Configure image: [$kiwi_iname]..."

#======================================
# Setup baseproduct link
#--------------------------------------
suseSetupProduct

#======================================
# SuSEconfig
#--------------------------------------
suseConfig

#======================================
# Import repositories' keys
#--------------------------------------
suseImportBuildKey

#======================================
# Umount kernel filesystems
#--------------------------------------
baseCleanMount

#======================================
# Add repositories
#--------------------------------------
case $( arch ) in
    x86_64 ) echo "Adding repos for x86_64"
        zypper ar --refresh -K \
            http://download.opensuse.org/tumbleweed/repo/oss/ "OSS"
        zypper ar --refresh -K \
            http://download.opensuse.org/tumbleweed/repo/non-oss/ "NON OSS"
        ;;
    aarch64 ) echo "Adding repo for aarch64"
        zypper ar --refresh -K \
            http://download.opensuse.org/ports/aarch64/tumbleweed/repo/oss/ "OSS"
        ;;
    ppc64le ) echo "Adding repo for ppc64le"
        zypper ar --refresh -K \
            http://download.opensuse.org/ports/ppc/tumbleweed/repo/oss/ "OSS"
        zypper ar --refresh -K \
            http://download.opensuse.org/ports/ppc/tumbleweed/repo/non-oss/ "NON OSS"
    s390x ) echo "Adding repo for s390x"
        zypper ar --refresh -K \
            http://download.opensuse.org/ports/zsystems/tumbleweed/repo/oss/ "OSS"
        zypper ar --refresh -K \
            http://download.opensuse.org/ports/zsystems/tumbleweed/repo/non-oss/ "NON OSS"
    * ) echo "No repos for $arch"
        ;;
esac

#======================================
# Disable recommends
#--------------------------------------
sed -i 's/.*solver.onlyRequires.*/solver.onlyRequires = true/g' /etc/zypp/zypp.conf

#======================================
# Remove locale files
#--------------------------------------
(cd /usr/share/locale && find -name '*.mo' | xargs rm)


exit 0
