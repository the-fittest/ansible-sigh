# docker build -t sigh/latest .
# docker run -it --privileged --rm=true -v $(pwd):/mnt/host sigh/latest

FROM brandfrisch/ubuntu-16.04
MAINTAINER Alexander Jaeger <alexander.jaeger@proudmail.de>
RUN apt-get update && apt-get install -y \
    libssl-dev \
    build-essential \
    libmilter-dev \
    libmilter1.0.1 \
    libboost1.58-dev \
    libboost-filesystem-dev \
    libboost-system-dev \
    libboost-program-options-dev \
    tar \
    wget \
    ruby-dev

WORKDIR /usr/local/src/

RUN gem install fpm
RUN wget https://cmake.org/files/v3.8/cmake-3.8.0-rc2-Linux-x86_64.tar.gz && tar xfvz cmake-3.8.0-rc2-Linux-x86_64.tar.gz
RUN wget https://github.com/croessner/sigh/archive/v1607.1.6.tar.gz && tar xfvz v1607.1.6.tar.gz

WORKDIR /usr/local/src/sigh-1607.1.6/

RUN mkdir /usr/local/src/sigh-package
RUN /usr/local/src/cmake-3.8.0-rc2-Linux-x86_64/bin/cmake . && make && make DESTDIR=/usr/local/src/sigh-package install
RUN fpm -s dir -t deb -C /usr/local/src/sigh-package --name sigh --version 1607.1.6 --iteration 1 --depends libmilter1.0.1 --depends openssl --depends libboost-system1.58.0 --depends libboost-filesystem1.58.0 --depends libboost-program-options1.58.0  --description "S/MIME signing milter" .