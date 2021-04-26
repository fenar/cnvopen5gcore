FROM ubuntu:focal

MAINTAINER Fatih Nar <fenari@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

USER root

RUN apt-get update && \
   apt-get -yq dist-upgrade && \
   apt-get --no-install-recommends -qqy install make g++ libsctp-dev lksctp-tools iproute2 python3-pip 
   
RUN apt-get update &&\
 DEBIAN_FRONTEND=noninteractive\
 apt-get install -y fuse snapd snap-confine squashfuse sudo init &&\
 apt-get clean &&\
 dpkg-divert --local --rename --add /sbin/udevadm &&\
 ln -s /bin/true /sbin/udevadm

RUN systemctl enable snapd

VOLUME ["/sys/fs/cgroup"]

STOPSIGNAL SIGRTMIN+3

CMD ["/sbin/init"]

RUN snap install cmake --classic && \
   git clone https://github.com/aligungr/UERANSIM && \
   cd UERANSIM && make

WORKDIR /UERANSIM/build
