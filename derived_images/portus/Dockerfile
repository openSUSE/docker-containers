FROM opensuse/amd64:42.3
MAINTAINER SUSE Containers Team <containers@suse.com>

# Install some helper scripts:
#   1. init: contains the entrypoint of this image.
#   2. rpm-import-repo-key: temporary script that makes it easier to download
#      and import gpg keys from trusted key servers. This is used later on to
#      import the OBS key used to sign all the contents of the
#      Virtualization:containers project.
COPY init rpm-import-repo-key /

# Install Portus and prepare the /certificates directory.
RUN chmod +x /rpm-import-repo-key /init && \
    /rpm-import-repo-key 55A0B34D49501BB7CA474F5AA193FBB572174FC2 && \
    zypper ar -f obs://Virtualization:containers:Portus/openSUSE_Leap_42.3 portus && \
    zypper ref && \
    zypper -n in portus && \
    zypper -n rm kbd-legacy && \
    zypper clean -a && \
    rm /rpm-import-repo-key && \
    rm -rf /etc/pki/trust/anchors && \
    ln -sf /certificates /etc/pki/trust/anchors

EXPOSE 3000
ENTRYPOINT ["/init"]
