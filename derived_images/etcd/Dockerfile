FROM opensuse:leap
MAINTAINER SUSE Containers Team <containers@suse.com>

RUN zypper ar -Gf http://download.opensuse.org/repositories/Virtualization:/containers/openSUSE_Leap_42.2/ containers && \
    zypper ref && \
    zypper -n in etcd && \
    zypper clean -a

CMD etcd
