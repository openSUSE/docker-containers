# MariaDB

This images contains a MariaDB installation on openSUSE OS.

No custom configuration is applied as it is meant to be generic.

It expects a `MYSQL_ROOT_PASSWORD` environment variable to set the
root password.

By default it has defined `MYSQL_DISABLE_REMOTE_ROOT=true` environment
variable to disable any remote root connection. Any other value results
on bypassing this restriction.

SQL scripts to initialize databases are expected to be hosted
on `/docker-entrypoint-initdb.d` volume. It expects `*.sql` and
`*.sql.gz` files.

Any specific configuration can be mounted on each container.
