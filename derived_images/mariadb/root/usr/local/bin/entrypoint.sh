#!/bin/bash
                                                                                
# Copyright (c) 2017 SUSE LLC 
# Copyright (c) 2002, 2012, Oracle and/or its affiliates.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; version 2 of the License.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301  USA


config=".my.cnf.$$"
command=".mysql.$$"

trap "interrupt" 1 2 3 6 15

rootpass=""
basedir=
defaults_file=
defaults_extra_file=
no_defaults=

print_defaults="/usr/bin/my_print_defaults"
mysql_command="/usr/bin/mysql"
mysqld_command="/usr/sbin/mysqld"
mysqld_systemd_helper="/usr/lib/mysql/mysql-systemd-helper"
mysqld_config="/etc/my.cnf"
init_sql_scripts_folder="/docker-entrypoint-initdb.d"

parse_arg()
{
  echo "$1" | sed -e 's/^[^=]*=//'
}

parse_arguments()
{
  # We only need to pass arguments through to the server if we don't
  # handle them here.  So, we collect unrecognized options (passed on
  # the command line) into the args variable.
  pick_args=
  if test "$1" = PICK-ARGS-FROM-ARGV
  then
    pick_args=1
    shift
  fi

  for arg
  do
    case "$arg" in
      --basedir=*) basedir=`parse_arg "$arg"` ;;
      --defaults-file=*) defaults_file="$arg" ;;
      --defaults-extra-file=*) defaults_extra_file="$arg" ;;
      --no-defaults) no_defaults="$arg" ;;
      *)
        if test -n "$pick_args"
        then
          args="$args $arg"
        fi
        ;;
    esac
  done
}


cannot_find_file()
{
  echo
  echo "FATAL ERROR: Could not find $1"

  shift
  if test $# -ne 0
  then
    echo
    echo "The following directories were searched:"
    echo
    for dir in "$@"
    do
      echo "    $dir"
    done
  fi
}

prepare() {
    touch $config $command
    chmod 600 $config $command
}

do_query() {
    echo "$1" >$command
    #sed 's,^,> ,' < $command  # Debugging
    $mysql_command --defaults-file=$config $defaults_extra_file $no_defaults $args <$command
    return $?
}

# Simple escape mechanism (\-escape any ' and \), suitable for two contexts:
# - single-quoted SQL strings
# - single-quoted option values on the right hand side of = in my.cnf
#
# These two contexts don't handle escapes identically.  SQL strings allow
# quoting any character (\C => C, for any C), but my.cnf parsing allows
# quoting only \, ' or ".  For example, password='a\b' quotes a 3-character
# string in my.cnf, but a 2-character string in SQL.
#
# This simple escape works correctly in both places.
basic_single_escape () {
    # The quoting on this sed command is a bit complex.  Single-quoted strings
    # don't allow *any* escape mechanism, so they cannot contain a single
    # quote.  The string sed gets (as argv[1]) is:  s/\(['\]\)/\\\1/g
    #
    # Inside a character class, \ and ' are not special, so the ['\] character
    # class is balanced and contains two characters.
    echo "$1" | sed 's/\(['"'"'\]\)/\\\1/g'
}

make_config() {
    echo "# mysql_secure_installation config file" >$config
    echo "[mysql]" >>$config
    echo "user=root" >>$config
    esc_pass=`basic_single_escape "$rootpass"`
    echo "password='$esc_pass'" >>$config
    #sed 's,^,> ,' < $config  # Debugging

    if test -n "$defaults_file"
    then
        dfile=`parse_arg "$defaults_file"`
        cat "$dfile" >>$config
    fi
}

set_root_password() {
    password1=$MYSQL_ROOT_PASSWORD

    if [ "$password1" == "" ]; then
    	echo "Sorry, you can't use an empty password here."
	    echo
    	clean_and_exit
    fi
    
    if [ "$password1" == "$rootpass" ]; then 
        echo "Root password already set, nothing to do here"
        echo
        return 0
    fi

    esc_pass=`basic_single_escape "$password1"`
    do_query "UPDATE mysql.user SET Password=PASSWORD('$esc_pass') WHERE User='root';"
    if [ $? -eq 0 ]; then
	    echo "Password updated successfully!"
    	echo "Reloading privilege tables.."
	    reload_privilege_tables
    	if [ $? -eq 1 ]; then
	    	clean_and_exit
    	fi
    	rootpass=$password1
    	make_config
    else
    	echo "Password update failed!"
	    clean_and_exit
    fi

    return 0
}

remove_anonymous_users() {
    do_query "DELETE FROM mysql.user WHERE User='';"
    if [ $? -eq 0 ]; then
    	echo " ... Success!"
    else
    	echo " ... Failed!"
	    clean_and_exit
    fi

    return 0
}

remove_remote_root() {
    do_query "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"
    if [ $? -eq 0 ]; then
    	echo " ... Success!"
    else
    	echo " ... Failed!"
    fi
}

remove_test_database() {
    echo " - Dropping test database..."
    do_query "DROP DATABASE IF EXISTS test;"
    if [ $? -eq 0 ]; then
	    echo " ... Success!"
    else
	    echo " ... Failed!  Not critical, keep moving..."
    fi

    echo " - Removing privileges on test database..."
    do_query "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%'"
    if [ $? -eq 0 ]; then
    	echo " ... Success!"
    else
    	echo " ... Failed!  Not critical, keep moving..."
    fi

    return 0
}

reload_privilege_tables() {
    do_query "FLUSH PRIVILEGES;"
    if [ $? -eq 0 ]; then
	    echo " ... Success!"
    	return 0
    else
	    echo " ... Failed!"
	return 1
    fi
}

interrupt() {
    echo
    echo "Aborting!"
    echo
    cleanup
    #stty echo
    exit 1
}

cleanup() {
    echo "Cleaning up..."
    rm -f $config $command
}

# Remove the files before exiting.
clean_and_exit() {
	cleanup
	exit 1
}

datadir() {
    $mysqld_command --verbose --help --log-bin-index="$(mktemp -u)" 2>/dev/null | awk '$1 == "datadir" { print $2; exit }'
}

# usage: file_env VAR [DEFAULT]
#    ie: file_env 'XYZ_DB_PASSWORD' 'example'
# (will allow for "$XYZ_DB_PASSWORD_FILE" to fill in the value of
#  "$XYZ_DB_PASSWORD" from a file, especially for Docker's secrets feature)
file_env() {
	local var="$1"
	local fileVar="${var}_FILE"
	local def="${2:-}"
	if [ "${!var:-}" ] && [ "${!fileVar:-}" ]; then
		echo >&2 "error: both $var and $fileVar are set (but are exclusive)"
		exit 1
	fi
	local val="$def"
	if [ "${!var:-}" ]; then
		val="${!var}"
	elif [ "${!fileVar:-}" ]; then
		val="$(< "${!fileVar}")"
	fi
	export "$var"="$val"
	unset "$fileVar"
}

if test ! -x "$print_defaults"
then
  cannot_find_file "$print_defaults"
  exit 1
fi

if test ! -x "$mysql_command"
then
  cannot_find_file "$mysql_command"
  exit 1
fi

if test ! -x "$mysqld_command"
then
  cannot_find_file "$mysqld_command"
  exit 1
fi

if test ! -x "$mysqld_systemd_helper"
then
  cannot_find_file "$mysqld_systemd_helper"
  exit 1
fi

# Now we can get arguments from the group [client] and [client-server]
# in the my.cfg file.
parse_arguments $($print_defaults $defaults_file $defaults_extra_file $no_defaults client client-server client-mariadb)

# The actual script starts here

prepare

DATADIR=$(datadir)
if [ -z "$DATADIR" ]; then
    echo "Data directory is not defined"
    echo
    clean_and_exit
fi

$mysqld_systemd_helper install
if [ $? -ne 0 ]; then
    clean_and_exit
fi
$mysqld_systemd_helper upgrade
if [ $? -ne 0 ]; then
    clean_and_exit
fi

file_env 'MYSQL_ROOT_PASSWORD'
file_env 'MYSQL_ROOT_PASSWORD_FILE'
if [ -z "$MYSQL_ROOT_PASSWORD" ] && [ -z "$MYSQL_ROOT_PASSWORD_FILE" ]; then
    echo >&2 "Error: Database uninitialized and the root password is not specified"
    echo >&2 "You need to specify MYSQL_ROOT_PASSWORD or MYSQL_ROOT_PASSWORD_FILE"
    clean_and_exit
fi

if [ -n "$MYSQL_ROOT_PASSWORD_FILE" ]; then
    MYSQL_ROOT_PASSWORD=`cat "$MYSQL_ROOT_PASSWORD_FILE"`
fi

su mysql -s /bin/bash -c "$mysqld_command --defaults-file=$mysqld_config --skip-networking" &
parent=$!

for i in {30..0}; do
    status=1
    rootpass=""
    make_config
    do_query ""
   	if [ $? -eq 0 ]; then
        break
    else
        rootpass="$MYSQL_ROOT_PASSWORD"
        make_config
        do_query ""
        if [ $? -eq 0 ]; then
            break
        fi
    fi
    echo 'MySQL init process in progress...'
	sleep 1
done

if [ "$i" = 0 ]; then
    echo >&2 'MySQL init process failed.'
    clean_and_exit
fi

echo "Setting root password..."
set_root_password

echo "Removing anonymous users..."
remove_anonymous_users

if [ "$MYSQL_DISABLE_REMOTE_ROOT" == "true" ]; then
    echo "Removing remote root access..."
    remove_remote_root
fi

echo "Removing test database..."
remove_test_database

echo "Reloading privileges..."
reload_privilege_tables

for f in "${init_sql_scripts_folder}/*"; do
    case "$f" in
	    # This might be run as root, so better disable shell scripts here
        #*.sh) echo "$0: running $f"; . "$f" ;;
        *.sql) echo "$0: running $f";
            "$mysql_command --defaults-file=$config $defaults_extra_file $no_defaults $args" < "$f";
            echo ;;
        *.sql.gz) echo "$0: running $f";
            gunzip -c "$f" | "$mysql_command --defaults-file=$config $defaults_extra_file $no_defaults $args";
            echo ;;
        *) echo "$0: ignoring $f" ;;
    esac
    echo
done

pid=$(pgrep -P $parent)
if ! kill -s TERM $pid || ! wait $parent; then
    echo >&2 'MySQL init process failed.'
    clean_and_exit
fi

echo
echo 'MySQL init process done. Ready for start up.'
echo

cleanup

exec "$@"
