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

#=======================================
# Add repositories
#---------------------------------------

zypper -n --gpg-auto-import-keys ar -r http://download.opensuse.org/distribution/13.2/repo/oss/ OSS
zypper -n --gpg-auto-import-keys ar -r http://download.opensuse.org/update/13.2/ OSS-Updates

#======================================
# Import repositories' keys
#--------------------------------------
suseImportBuildKey

#======================================
# Activate services
#--------------------------------------
suseActivateDefaultServices

#======================================
# Umount kernel filesystems
#--------------------------------------
baseCleanMount

exit 0
