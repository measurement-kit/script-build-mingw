FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

RUN apt-get update
RUN apt-get install -y build-essential libtool libtool-bin automake pkg-config git curl gettext-base

COPY . /mk-build
WORKDIR /mk-build

