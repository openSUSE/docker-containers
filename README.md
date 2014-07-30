This repository contains the source files used to build the official
openSUSE containers for Docker.

#Requirements

* KIWI version 5.06.87 or higher is required.
* The `make` package.
* The `sudo` package.
* The `docker` package (optional).

#Build instructions

Each directory contains a Makefile. To build the container use the following
command:

```
make build
```

The root password is going to be prompted since KIWI requires adminisrator
privileges.

To import the final container use the following command:

```
make import
```

This assumes Docker is running and the user executing the make command is a
member of the `docker` group.
