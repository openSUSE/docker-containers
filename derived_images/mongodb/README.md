Dockerfile - openSUSE 42.1 - Let's Chat
=======================================

openSUSE Dockerfile for Let's Chat - an open-source Web based chat platform  


To build:

```
# docker build -t <username>/lets-chat .
```

To run:

Start a Docker container with MongoDB as pre-requisite

```
docker run --name letschat-mongo -d pgonin/mongodb
```

Start a Docker container with Let's Chat connected to MongoDB container
```
docker run  --name some-letschat --link letschat-mongo:mongo -p 80:8080 -d pgonin/lets-chat
```

To test:
http://dockhost.fqdn/


```
# docker ps
CONTAINER ID        IMAGE               COMMAND              CREATED             STATUS              PORTS                            NAMES
ac54047b61a1        pgonin/lets-chat     "npm start"          22 hours ago        Up 22 hours         5222/tcp, 0.0.0.0:80->8080/tcp   some-letschat
4cd6d0288a8d        pgonin/mongodb      "/usr/sbin/mongod"   22 hours ago        Up 22 hours         27017/tcp                        letschat-mongo
```
