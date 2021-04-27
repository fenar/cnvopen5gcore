FROM ubuntu:focal

MAINTAINER Fatih Nar <fenari@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

USER root

RUN apt-get update && \
   apt-get -yq dist-upgrade && \
   apt-get install iputils-ping dnsutils && \
   apt-get --no-install-recommends -qqy install make g++ libsctp-dev lksctp-tools iproute2 python3-pip && \
   mkdir UERANSIM 

COPY build/ /UERANSIM/

WORKDIR /UERANSIM
