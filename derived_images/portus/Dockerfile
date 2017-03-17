FROM opensuse/amd64:42.2
MAINTAINER SUSE Containers Team <containers@suse.com>

# Install some helper scripts:
#   1. init: contains the entrypoint of this image.
#   2. check_db.rb: a rails runner used by the `init` script that checks
#      if the database is up and running.
#   3. rpm-import-repo-key: temporary script that makes it easier to download
#      and import gpg keys from trusted key servers. This is used later on to
#      import the OBS key used to sign all the contents of the
#      Virtualization:containers project.
COPY init check_db.rb rpm-import-repo-key /

# Install Portus and prepare the /certificates directory.
RUN /rpm-import-repo-key 55A0B34D49501BB7CA474F5AA193FBB572174FC2 && \
    zypper ar -f obs://Virtualization:containers:Portus/openSUSE_Leap_42.2 portus && \
    zypper ref && \
    zypper -n in portus && \
    zypper -n rm kbd-legacy && \
    zypper clean -a && \
    rm /rpm-import-repo-key && \
    rm -rf /etc/pki/trust/anchors && \
    ln -sf /certificates /etc/pki/trust/anchors

EXPOSE 3000
ENTRYPOINT ["/init"]
