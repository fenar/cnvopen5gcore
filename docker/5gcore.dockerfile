FROM ubuntu:jammy as efatnar_step

ENV DEBIAN_FRONTEND=noninteractive
ENV LD_LIBRARY_PATH=/open5gs/install/lib/x86_64-linux-gnu

# Install updates and dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        python3-pip \
        python3-setuptools \
        python3-wheel \
        ninja-build \
        build-essential \
        flex \
        bison \
        git \
        libsctp-dev \
        libgnutls28-dev \
        libgcrypt-dev \
        libssl-dev \
        libidn11-dev \
        libmongoc-dev \
        libbson-dev \
        libyaml-dev \
        meson \
        mongodb \
        curl \
        gnupg \
        ca-certificates \
        libmicrohttpd-dev \
        libcurl4-gnutls-dev \
        libnghttp2-dev \
        libtins-dev \
        libidn11-dev \
        libtalloc-dev

RUN curl -fsSL https://deb.nodesource.com/setup_14.x | bash - && apt-get install -y nodejs

# Get open5gs code and install
RUN git clone --recursive https://github.com/open5gs/open5gs && cd open5gs && \
    git checkout main && meson build --prefix=`pwd`/install && \
    ninja -C build && cd build && ninja install && \
    mkdir -p /open5gs/install/include

# Building WebUI of open5gs
RUN cd open5gs/webui && npm ci --no-optional

# Build final image
FROM ubuntu:jammy

ENV DEBIAN_FRONTEND=noninteractive
ENV LD_LIBRARY_PATH=/open5gs/install/lib/x86_64-linux-gnu

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        curl \
        ca-certificates \
        libssl-dev \
        libyaml-dev \
        libmicrohttpd-dev \
        libmongoc-dev \
        libsctp-dev \
        libcurl4-gnutls-dev \
        libtins-dev \
        libidn11-dev \
        libtalloc-dev \
        netbase \
        ifupdown \
        net-tools \
        iputils-ping \
        python3-setuptools \
        python3-wheel \
        python3-pip \
        iptables && \
    apt-get autoremove -y && apt-get autoclean

RUN pip3 install click

RUN curl -fsSL https://deb.nodesource.com/setup_14.x | bash - && apt-get install -y nodejs && \
    apt-get remove -y curl && apt-get autoremove -y && apt-get autoclean

RUN update-ca-certificates

COPY --from=efatnar_step /open5gs/install/bin /open5gs/install/bin
COPY --from=efatnar_step /open5gs/install/etc /open5gs/install/etc
COPY --from=efatnar_step /open5gs/install/include /open5gs/install/include
COPY --from=efatnar_step /open5gs/install/lib /open5gs/install/lib
COPY --from=efatnar_step /open5gs/webui /open5gs/webui

# Set the working directory to open5gs
WORKDIR open5gs

COPY open5gs_init.sh /
CMD /open5gs_init.sh
