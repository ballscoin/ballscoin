FROM alpine:3.6
##FROM ubuntu
ADD . /ballscoin
RUN apk add --update bash && rm -rf /var/cache/apk/*
RUN \
  apk add --no-cache git go make gcc musl-dev linux-headers && \
  (cd ballscoin && make ballscoin)                             && \
  cp ballscoin/build/bin/ballscoin /usr/local/bin/             && \
  apk del git go make gcc musl-dev linux-headers            && \
  rm -rf /ballscoin
ADD start.sh /root/start.sh

EXPOSE 6588 30303 30303/udp

ENTRYPOINT /root/start.sh
