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
# Import Virtualization:containers key
#--------------------------------------
/rpm-import-repo-key 55A0B34D49501BB7CA474F5AA193FBB572174FC2
rm /rpm-import-repo-key

#======================================
# Clean trusted anchors
#--------------------------------------
rm -rf /etc/pki/trust/anchors
ln -sf /certificates /etc/pki/trust/anchors

#======================================
# Umount kernel filesystems
#--------------------------------------
baseCleanMount

exit 0
