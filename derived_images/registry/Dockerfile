FROM opensuse/leap:15
MAINTAINER SUSE Containers Team <containers@suse.com>

# Install the entrypoint of this image.
COPY init /

RUN chmod +x /init && \
    zypper ref && \
    zypper -n in docker-distribution-registry && \
    zypper clean -a

VOLUME ["/var/lib/docker-registry"]
EXPOSE 5000
ENTRYPOINT ["/init"]
