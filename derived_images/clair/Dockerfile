FROM opensuse/amd64:42.3
MAINTAINER SUSE Containers Team <containers@suse.com>

VOLUME /config
EXPOSE 6060 6061

# Install Portus and prepare the /certificates directory.
RUN mkdir -m 0600 /tmp/build && \
    # Fetch the key from the obs://Virtualization:containers:Portus project.
    gpg --homedir /tmp/build --keyserver ha.pool.sks-keyservers.net --recv-keys 55A0B34D49501BB7CA474F5AA193FBB572174FC2 && \
    gpg --homedir /tmp/build --export --armor 55A0B34D49501BB7CA474F5AA193FBB572174FC2 > /tmp/build/repo.key && \
    rpm --import /tmp/build/repo.key && \
    rm -rf /tmp/build && \
    # Now add the repository and installa clair.
    zypper ar -f obs://Virtualization:containers/openSUSE_Leap_42.3 "Virtualization:containers" && \
    zypper ref && \
    zypper -n in clair && \
    # Remove unneeded packages and clean stuff.
    zypper -n rm kbd-legacy && \
    zypper clean -a && \
    # Prepare the certificates directory.
    rm -rf /etc/pki/trust/anchors && \
    ln -sf /certificates /etc/pki/trust/anchors

ENTRYPOINT ["/usr/bin/clair"]
