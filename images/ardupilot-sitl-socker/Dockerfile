FROM ubuntu:18.04

RUN apt-get update -y

RUN apt-get install -y git python g++ ccache gawk make wget cmake python-pip iproute2 python-future python3-future libtool autoconf meson ninja-build pkg-config gcc g++ systemd redis

RUN useradd --create-home pilot

USER pilot

WORKDIR /home/pilot

WORKDIR /home/pilot

RUN git clone https://github.com/mavlink-router/mavlink-router.git

WORKDIR /home/pilot/mavlink-router

RUN git submodule update --init --recursive

RUN meson setup build .

RUN ninja -C build

USER root

RUN make install

USER ninja -C build install

WORKDIR /home/pilot

RUN git clone --recursive --depth 1 https://github.com/ArduPilot/ardupilot.git

WORKDIR /home/pilot/ardupilot

RUN ./waf configure

RUN ./waf copter

RUN ./waf plane

WORKDIR /home/pilot

RUN mkdir app

COPY app app

WORKDIR /home/pilot/app

CMD ./launch.sh
