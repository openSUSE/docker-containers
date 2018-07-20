FROM opensuse/amd64:42.3
MAINTAINER SUSE Containers Team <containers@suse.com>

RUN mkdir -m 0600 /tmp/build && \
    gpg --homedir /tmp/build --keyserver ha.pool.sks-keyservers.net --recv-keys 55A0B34D49501BB7CA474F5AA193FBB572174FC2 && \
    gpg --homedir /tmp/build --export --armor 55A0B34D49501BB7CA474F5AA193FBB572174FC2 > /tmp/build/repo.key && \
    rpm --import /tmp/build/repo.key && \
    rm -rf /tmp/build && \
    # Now add the repository and install yarn.
    zypper ar -f obs://Virtualization:containers:Portus/openSUSE_Leap_42.3 portus && \
    zypper ref && \
    zypper -n in --from portus nodejs6 yarn && \
    # Remove unneeded packages and clean stuff.
    zypper -n rm kbd-legacy && \
    zypper clean -a
