FROM alpine:3.11

ARG DEV=no

ENV GOPATH /go

RUN apk update \
	&& apk add go git subversion libc-dev mercurial bzr openssh

COPY . /go/src/github.com/sluongng/hound

COPY default-config.json /data/config.json

RUN go install github.com/sluongng/hound/cmds/houndd

RUN [ "$DEV" = "yes" ] \
    && apk add npm make rsync || true

RUN [ "$DEV" = "no" ] \
    && apk del go \
    && rm -f /var/cache/apk/* \
    && rm -rf /go/src /go/pkg || true

VOLUME ["/data"]

EXPOSE 6080 9000

ENTRYPOINT ["/go/bin/houndd", "-conf", "/data/config.json"]
