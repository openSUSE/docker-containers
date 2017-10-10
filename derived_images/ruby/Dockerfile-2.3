FROM opensuse/amd64:42.3
MAINTAINER SUSE Containers Team <containers@suse.com>

COPY rpm-import-repo-key /

RUN chmod +x /rpm-import-repo-key && \
    sync && /rpm-import-repo-key A9EA39C49B6B9E93B6863F849AF0C9A20E9AF123 && \
    zypper ar -f obs://devel:languages:ruby/openSUSE_Leap_42.3 ruby && \
    zypper -n in --no-recommends ruby2.3 && \
    zypper clean -a && \
    rm /rpm-import-repo-key
