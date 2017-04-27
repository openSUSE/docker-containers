FROM opensuse:42.2
LABEL maintainer "Hart Simha <hart.simha@suse.com>"

COPY rpm-import-repo-key /
RUN /rpm-import-repo-key 55A0B34D49501BB7CA474F5AA193FBB572174FC2 && \
    zypper ar obs://Virtualization:containers/openSUSE_Leap_42.2 Virtualization:containers && \
    zypper -n in -f kubernetes-client-1.6.1-17.3 && \
    zypper clean -a && \
    rm /rpm-import-repo-key
