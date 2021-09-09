FROM ubuntu:18.04

RUN apt-get update -y

RUN apt-get install -y git python g++ ccache gawk make wget cmake python-pip iproute2 python-future python3-future libtool autoconf pkg-config

RUN useradd --create-home pilot

USER pilot

WORKDIR /home/pilot

WORKDIR /home/pilot

RUN git clone https://github.com/mavlink-router/mavlink-router.git

WORKDIR /home/pilot/mavlink-router

RUN git submodule update --init --recursive

RUN ./autogen.sh && ./configure CFLAGS='-g -O2' --sysconfdir=/etc --localstatedir=/var --libdir=/usr/lib64 --prefix=/usr --disable-systemd

RUN make

USER root

RUN make install

USER pilot