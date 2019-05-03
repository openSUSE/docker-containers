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
    for key in 55A0B34D49501BB7CA474F5AA193FBB572174FC2 \
               A9EA39C49B6B9E93B6863F849AF0C9A20E9AF123; do \
      found=''; \
      for server in \
        hkp://keys.gnupg.net:80 \
        ha.pool.sks-keyservers.net \
        hkp://keyserver.ubuntu.com:80 \
        hkp://p80.pool.sks-keyservers.net:80 \
        pgp.mit.edu \
      ; do \
        echo "Fetching GPG key $GPG_KEY from $server"; \
        gpg --homedir $TMPDIR --keyserver "$server" --keyserver-options timeout=10 --recv-keys "$key" && found=yes && break; \
      done; \
      test -z "$found" && echo >&2 "error: failed to fetch GPG key $key" && exit 1; \
      gpg --homedir $TMPDIR --export --armor $key > $TMPDIR/repo.key && \
      rpm --import $TMPDIR/repo.key ; \
    done; \
    rm -rf $TMPDIR && \
    # Now add the repository and install portus.
    zypper ar -f obs://devel:languages:ruby/openSUSE_Leap_15.0 ruby && \
    zypper ar -p 1 -f obs://Virtualization:containers:Portus:2.5/openSUSE_Leap_15.0 portus && \
    zypper ref -f && \
    zypper -n in --from portus --details ruby-common portus && \
    zypper clean -a && \
    # Prepare the certificates directory.
    rm -rf /etc/pki/trust/anchors && \
    ln -sf /certificates /etc/pki/trust/anchors

EXPOSE 3000
ENTRYPOINT ["/init"]
