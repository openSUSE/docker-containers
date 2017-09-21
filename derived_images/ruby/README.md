# Ruby

This image is just a base openSUSE 42.3 Docker image with Ruby installed in
it. There's one Dockerfile which takes the default version, and then Dockerfiles
with `-$version` appended to their names to specify the ruby version being
installed.
