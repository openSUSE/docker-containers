FROM opensuse/leap:15.0
MAINTAINER Henne Vogelsang <hvogel@suse.com>

RUN zypper ref && \
    zypper -n in --no-recommends mariadb hostname && \
    zypper clean -a

# Set mariadb password
RUN /usr/lib/mysql/mysql-systemd-helper install; \
    /usr/lib/mysql/mysql-systemd-helper start & \
    /usr/lib/mysql/mysql-systemd-helper wait; \
    /usr/bin/mysql -u root -e "SELECT @@version; CREATE USER 'root'@'%' IDENTIFIED BY 'opensuse'; GRANT ALL ON *.* TO 'root'@'%' WITH GRANT OPTION;"; \
    kill `cat /var/lib/mysql/*.pid`; \
    sleep 10

CMD ["/usr/lib/mysql/mysql-systemd-helper", "start"]
