FROM opensuse:42.1
MAINTAINER Evgeny Shmarnev "eshmarnev@suse.com" \
	   Paul Gonin "pgonin@opensuse.org"
ENV REFRESHED_AT 2016-14-07

RUN set -x \
&&  zypper ar http://download.opensuse.org/repositories/server:/database/openSUSE_Leap_42.1/server:database.repo \
&&  zypper -n --gpg-auto-import-keys refresh \
&&  zypper -n --gpg-auto-import-keys update \
&&  zypper -n --gpg-auto-import-keys install mongodb

RUN mkdir -p /data/db

EXPOSE 27017
ENTRYPOINT ["/usr/sbin/mongod"]
