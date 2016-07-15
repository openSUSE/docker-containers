dockerfiles-opensuse-mongodb
=============================

openSUSE Dockerfile for MongoDB - an open-source document database, and the leading NoSQL database.  


To build:

```
# docker build -t <username>/mongodb .
```

To run:

```
# docker run -d -p 27107 <username>/mongodb
```

To test:
Check mongodb ports in container

```
# docker ps

CONTAINER ID        IMAGE                   COMMAND              CREATED             STATUS              PORTS            
9402b10e37eb        evalle/mongodb:latest   "/usr/sbin/mongod"   12 minutes ago      Up 12 minutes       0.0.0.0:49153->27017/tcp
```
and connect to port via mongo:

```
# mongo --host localhost --port 49153
```
