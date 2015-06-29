This repository contains the source files used to build the official
openSUSE image for Docker and the Docker images derived from them.

# Repository layout

The source code of the official openSUSE images is organized inside of dedicated
directories kept under the root of the repository.

All the images derived from the official ones are stored under the
`derived_images` directory.

# Requirements

## Official openSUSE images:

These images are not supposed to be built locally. The build is going to happen
inside of the [Open Build Service](http://openbuildservice.org/).

For each base image there's a dedicated OBS subproject under the
[Virtualization:containers:images](https://build.opensuse.org/project/subprojects/Virtualization:containers:images)
project.

The build results are automatically aggregated inside of
[this repository](http://download.opensuse.org/repositories/Virtualization:/containers/images/).

Unfortunately it is not possible to use the OBS service hook for OBS because
this repository contains the source code of more than 1 OBS project.

## Derived images

  * The `docker` package.

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

