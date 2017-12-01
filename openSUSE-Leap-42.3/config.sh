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
            http://download.opensuse.org/distribution/leap/42.2/repo/oss/suse/ "OSS"
        zypper ar --refresh -K \
            http://download.opensuse.org/update/leap/42.2/oss/ "OSS Update"
        zypper ar --refresh -K \
            http://download.opensuse.org/distribution/leap/42.2/repo/non-oss/suse/ "NON OSS"
        zypper ar --refresh -K \
            http://download.opensuse.org/update/leap/42.2/non-oss/ "NON OSS Update"
        ;;
    aarch64 ) echo "Adding repo for aarch64"
        zypper ar --refresh -K \
            http://download.opensuse.org/ports/aarch64/distribution/leap/42.3/repo/oss/ "OSS"
        zypper ar --refresh -K \
            http://download.opensuse.org/ports/aarch64/distribution/leap/42.3/repo/oss/ "OSS Update"
        ;;
    ppc64le ) echo "Adding repo for ppc64le"
        zypper ar --refresh -K \
            http://download.opensuse.org/ports/ppc/distribution/leap/42.3/repo/oss/ "OSS"
        zypper ar --refresh -K \
            http://download.opensuse.org/ports/update/42.3/oss/ "OSS Update"
        ;;
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
