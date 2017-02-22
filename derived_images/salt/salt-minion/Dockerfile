FROM opensuse:leap
MAINTAINER SUSE Containers Team <containers@suse.com>

RUN zypper ref && \
    zypper -n in salt-minion python-M2Crypto && \
    zypper clean -a

ADD salt-minion.sh /

CMD /salt-minion.sh
