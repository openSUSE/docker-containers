FROM opensuse:leap
MAINTAINER SUSE Containers Team <containers@suse.com>

RUN zypper ref && \
    zypper -n in salt-master && \
    zypper clean -a

RUN useradd -MNrs /bin/false saltapi
RUN echo "saltapi:saltapi" | chpasswd

CMD salt-master
