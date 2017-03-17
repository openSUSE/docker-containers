FROM opensuse/amd64:42.2
MAINTAINER Flavio Castelli <fcastelli@suse.com>

# This script makes it easier to download and import gpg keys from trusted key
# servers.
# This is used later on to import the OBS key used to sign all the contents
# of the Virtualization:containers project.
ADD rpm-import-repo-key /usr/sbin/

RUN rpm-import-repo-key 55A0B34D49501BB7CA474F5AA193FBB572174FC2 && \
    zypper ar -f obs://Virtualization:containers:Portus:2.2/openSUSE_Leap_42.2 portus-2.2 && \
    zypper ref && \
    zypper -n in portus sudo && \
    zypper clean -a

# Add sudo rule that allows the wwwrun user to invoke update-ca-certificates
ADD update-ca-certificates-sudoers /etc/sudoers.d/
# Add sudo rule that allows the wwwrun user to invoke start_apache2; this
# program is maintained by SUSE and will initialize Apache2 and ensure the httpd
# daemon is run as wwwrun user.
ADD start_apache2-sudoers /etc/sudoers.d/
# Configure sudo to not wipe out all the existing env variables,
# this would cause lots of troubles when starting Portus via our init
# script
RUN sed -i -e 's/Defaults env_reset/Defaults !env_reset/' /etc/sudoers

# apache configuration
RUN a2enmod passenger
RUN a2enmod rewrite
RUN a2enmod ssl
RUN a2enflag SSL
ADD apache.conf /etc/apache2/vhosts.d/portus.conf

# Custom certificates must be placed inside of /certificates,
RUN rm -rf /etc/pki/trust/anchors && \
    ln -sf /certificates /etc/pki/trust/anchors

# Portus will log everything to stdout and stderr by default,
# however Apache will capture everything and send it to text file.
# This would break commands like `docker logs` and `kubectl logs`.
# That's why we use this trick.
RUN ln -sf /dev/stdout /var/log/apache2/access_log
RUN ln -sf /dev/stderr /var/log/apache2/error_log
# The stable release of Portus is not logging to STDOUT by default when
# used in production mode. We have to use this temporary workaround
RUN ln -sf /dev/stdout /srv/Portus/log/production.log

# portus configuration
ADD database.yml secrets.yml /srv/Portus/config/

ADD init /
ADD check_db.rb /check_db.rb

EXPOSE 80 443

ENTRYPOINT ["/init"]

# Disable password login for the root user
RUN passwd --lock root
USER wwwrun
