FROM opensuse/amd64:42.2
MAINTAINER Flavio Castelli <fcastelli@suse.com>

# TODO: this is full of ugly hacks. Clean !

# This script makes it easier to download and import gpg keys from trusted key
# servers.
# This is used later on to import the OBS key used to sign all the contents
# of the Virtualization:containers project.
COPY rpm-import-repo-key /usr/sbin/

# TODO: puma!!!
RUN rpm-import-repo-key 55A0B34D49501BB7CA474F5AA193FBB572174FC2 && \
    zypper ar -f obs://Virtualization:containers:Portus:2.2/openSUSE_Leap_42.2 portus && \
    zypper ar -f --no-gpgcheck obs://devel:languages:ruby:extensions/openSUSE_Leap_42.2 ruby-extensions && \
    zypper ref && \
    zypper -n in portus sudo ruby2.1-rubygem-puma && \
    zypper clean -a

# Configure sudo to not wipe out all the existing env variables,
# this would cause lots of troubles when starting Portus via our init
# script
# TODO
RUN sed -i -e 's/Defaults env_reset/Defaults !env_reset/' /etc/sudoers

# Custom certificates must be placed inside of /certificates,
# TODO
RUN rm -rf /etc/pki/trust/anchors && \
    ln -sf /certificates /etc/pki/trust/anchors

COPY database.yml secrets.yml /srv/Portus/config/

COPY init /
COPY check_db.rb /check_db.rb

# TODO
COPY puma.rb /puma.rb

EXPOSE 3000

ENTRYPOINT ["/init"]
