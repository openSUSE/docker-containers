FROM opensuse:42.1
MAINTAINER Paul Gonin "paul.gonin@suse.com"

ENV PKG_JSON_URL=https://raw.githubusercontent.com/sdelements/lets-chat/master/package.json \
    TAR_GZ_URL=https://github.com/sdelements/lets-chat/archive/master.tar.gz \
    BUILD_DEPS='gcc gcc-c++ git make python npm tar' \
    LCB_PLUGINS='lets-chat-ldap lets-chat-s3'

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

ADD $PKG_JSON_URL ./package.json

RUN set -x \
&&  zypper -n --gpg-auto-import-keys refresh \
&&  zypper -n --gpg-auto-import-keys update \
&&  zypper -n --gpg-auto-import-keys install $BUILD_DEPS \
&&  npm install --production \
&&  npm install $LCB_PLUGINS \
&&  npm dedupe \
&&  npm cache clean \
&&  rm -rf /tmp/npm*

ADD $TAR_GZ_URL ./master.tar.gz

RUN tar -xzvf master.tar.gz \
&&  cp -a lets-chat-master/. . \
&&  rm -rf lets-chat-master

RUN groupadd -r node \
&&  useradd -r -g node node \
&&  chown node:node uploads \
&&  mkdir -p builtAssets \
&&  chown node:node builtAssets

ENV LCB_DATABASE_URI=mongodb://mongo/letschat \
    LCB_HTTP_HOST=0.0.0.0 \
    LCB_HTTP_PORT=8080 \
    LCB_XMPP_ENABLE=true \
    LCB_XMPP_PORT=5222

USER node

EXPOSE 8080 5222

VOLUME ["/usr/src/app/config"]
VOLUME ["/usr/src/app/uploads"]

CMD ["npm", "start"]
