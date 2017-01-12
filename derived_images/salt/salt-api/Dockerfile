FROM opensuse:leap
MAINTAINER SUSE Containers Team <containers@suse.com>

RUN zypper ref && \
    zypper -n in salt-api && \
    zypper clean -a

CMD salt-api
