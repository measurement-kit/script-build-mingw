FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

RUN apt-get update
RUN apt-get install -y \
    build-essential libtool libtool-bin \
    automake pkg-config git curl gettext-base

COPY . /mk-build

## Golang setup
ENV GOLANG_VERSION "1.11.4"
ENV GOLANG_PLATFORM "linux-amd64"

RUN set -eux; \
	url="https://golang.org/dl/go${GOLANG_VERSION}.${GOLANG_PLATFORM}.tar.gz"; \
	curl -fsSLo go.tgz "$url"; \
	tar -C /usr/local -xzf go.tgz; \
	rm go.tgz; \
	export PATH="/usr/local/go/bin:$PATH"; \
	go version

ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"

ENV GO_MK_DIR "$GOPATH/src/github.com/measurement-kit/go-measurement-kit"

RUN git clone \
    --branch update/mk-0.9.1 \
    https://github.com/measurement-kit/go-measurement-kit.git \
    "$GO_MK_DIR" \
    && mkdir -p "$GO_MK_DIR/libs"

# Build mk for linux
RUN cd /mk-build \
    && ./build-linux `./all-deps.sh`

RUN cd /mk-build \
    && ./build-linux measurement-kit

RUN cp -R /mk-build/MK_DIST "$GO_MK_DIR/libs/MK_DIST"

RUN cd "$GO_MK_DIR" \
    && make test
