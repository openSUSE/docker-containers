This repository contains the source files used to build the official
openSUSE image for Docker and the Docker images derived from them.

# Repository layout

The source code of the official openSUSE images is organized inside of dedicated
directories kept under the root of the repository.

All the images derived from the official ones are stored under the
`derived_images` directory.

# Requirements

## Official openSUSE images:

  * [KIWI](https://github.com/openSUSE/kiwi) version 5.06.87 or higher is required.
  * The `make` package.
  * The `sudo` package.
  * The `docker` package (optional).

## Derived images

  * The `docker` package.

#Build instructions

## Official openSUSE images

Each directory contains a Makefile. To build the image use the following
command:

```
make build
```

**Note well:** the root password is going to be prompted since KIWI requires
administrator privileges.

To import the final image use the following command:

```
make import
```

This assumes Docker is running and the user executing the make command is a
member of the `docker` group.

## Derived images

Each directory contains a Dockerfile. To build the image use the following
commands:

```
cd <directory containing the Dockerfile>
docker build -t <name of the image> .
```

It's also recommended to associate these images to an
[automated build](https://docs.docker.com/docker-hub/builds/) on
[Docker Hub](https://hub.docker.com/).

In order to do that you must be a member of the
[openSUSE organization](https://registry.hub.docker.com/repos/opensuse/) on
Docker Hub.

