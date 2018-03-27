This repository contains the source files used to build derived images
from the official openSUSE images for Docker.

# Repository layout

The source code of the derived openSUSE images is organized inside of dedicated
directories kept in derived_images under the root of the repository.

# Requirements

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

