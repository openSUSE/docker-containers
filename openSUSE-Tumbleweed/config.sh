#!/bin/bash

# Copyright (c) 2018 SUSE LINUX GmbH, Nuernberg, Germany.
#
# All modifications and additions to the file contributed by third parties
# remain the property of their copyright owners, unless otherwise agreed
# upon. The license for this file, and modifications and additions to the
# file, is the same license as for the pristine package itself (unless the
# license for the pristine package is not an Open Source License, in which
# case the license is the MIT License). An "Open Source License" is a
# license that conforms to the Open Source Definition (Version 1.9)
# published by the Open Source Initiative.

test -f /.kconfig && . /.kconfig
test -f /.profile && . /.profile

echo "Configure image: [$kiwi_iname]..."

#======================================
# Setup baseproduct link
#--------------------------------------
suseSetupProduct

#======================================
# Import repositories' keys
#--------------------------------------
suseImportBuildKey

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
        ;;
    s390x ) echo "Adding repo for s390x"
        zypper ar --refresh -K \
            http://download.opensuse.org/ports/zsystems/tumbleweed/repo/oss/ "OSS"
        zypper ar --refresh -K \
            http://download.opensuse.org/ports/zsystems/tumbleweed/repo/non-oss/ "NON OSS"
        ;;
    * ) echo "No repos for $arch"
        ;;
esac

#======================================
# Disable recommends
#--------------------------------------
sed -i 's/.*solver.onlyRequires.*/solver.onlyRequires = true/g' /etc/zypp/zypp.conf

#======================================
# Exclude docs intallation
#--------------------------------------
sed -i 's/.*rpm.install.excludedocs.*/# rpm.install.excludedocs = yes/g' /etc/zypp/zypp.conf

#======================================
# Remove locale files
#--------------------------------------
find /usr/share/locale -name '*.mo' -delete

exit 0
