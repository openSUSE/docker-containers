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
# Disable recommends
#--------------------------------------
sed -i 's/.*installRecommends.*/installRecommends = no/g' /etc/zypp/zypper.conf

#======================================
# Remove locale files
#--------------------------------------
(cd /usr/share/locale && find -name '*.mo' | xargs rm)

#======================================
# Add repo depending on the arch
#--------------------------------------

case $( arch ) in
    x86_64 ) echo "Adding repos for x86_64"
        zypper ar http://download.opensuse.org/tumbleweed/repo/oss/ oss
        zypper ar http://download.opensuse.org/tumbleweed/repo/non-oss/ non-oss
        ;;
    s390x ) echo "Adding repos for s390x"
        zypper ar http://download.opensuse.org/ports/zsystems/tumbleweed/repo/oss/ oss
        zypper ar http://download.opensuse.org/ports/zsystems/tumbleweed/repo/non-oss/ non-oss
        ;;
    * )     echo "No repos for $arch"
        ;;
esac


exit 0
