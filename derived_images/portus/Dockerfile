FROM opensuse/leap:15.0
MAINTAINER SUSE Containers Team <containers@suse.com>

# Install the entrypoint of this image.
COPY init /

# Install Portus and prepare the /certificates directory.
RUN chmod +x /init && \
    # Fetch the key from the obs://Virtualization:containers:Portus
    # project. Sometimes the key server times out or has some other problem. In
    # that case, we fall back to alternative key servers.
    TMPDIR=/tmp/build && \
    mkdir -m 0600 $TMPDIR && \
    GPG_KEY=55a0b34d49501bb7ca474f5aa193fbb572174fc2 && \
    found=''; \
    for server in \
      hkp://keys.gnupg.net:80 \
      ha.pool.sks-keyservers.net \
      hkp://keyserver.ubuntu.com:80 \
      hkp://p80.pool.sks-keyservers.net:80 \
      pgp.mit.edu \
    ; do \
      echo "Fetching GPG key $GPG_KEY from $server"; \
      gpg --homedir $TMPDIR --keyserver "$server" --keyserver-options timeout=10 --recv-keys "$GPG_KEY" && found=yes && break; \
    done; \
    test -z "$found" && echo >&2 "error: failed to fetch GPG key $GPG_KEY" && exit 1; \
    gpg --homedir $TMPDIR --export --armor $GPG_KEY > $TMPDIR/repo.key && \
    rpm --import $TMPDIR/repo.key && \
    rm -rf $TMPDIR && \
    # Now add the repository and install portus.
    zypper ar -f obs://Virtualization:containers:Portus/openSUSE_Leap_15.0 portus && \
    zypper ref && \
    zypper -n in --from portus ruby-common portus && \
    zypper clean -a && \
    # Prepare the certificates directory.
    rm -rf /etc/pki/trust/anchors && \
    ln -sf /certificates /etc/pki/trust/anchors

EXPOSE 3000
ENTRYPOINT ["/init"]
