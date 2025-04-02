# syntax=docker/dockerfile:1

FROM ubuntu:22.04
SHELL ["/bin/bash", "-c"]

RUN apt update \
    && apt install -y \
    autoconf \
    automake \
    build-essential \
    cmake \
    git \
    lbzip2 \
    libtool \
    make \
    python-is-python3 \
    qt6-base-dev \
    xz-utils

WORKDIR /

ENV QT_SELECT=qt6
RUN qtchooser -install ${QT_SELECT} $(which qmake6)

RUN <<EOF
set -eux
git clone https://github.com/google/gumbo-parser.git
pushd /gumbo-parser
git checkout aa91b2
./autogen.sh
./configure
make -j$(nproc)
make install
popd
rm -rf /gumbo-parser
EOF

RUN <<EOF
set -eux
git clone https://github.com/jasenhuang/katana-parser.git
pushd /katana-parser
git checkout be6df4
./autogen.sh
./configure
make -j$(nproc)
make install
popd
rm -rf /katana-parser
EOF

RUN <<EOF
set -eux
git clone https://github.com/boostorg/boost.git
pushd /boost
git checkout boost-1.84.0
git submodule update --init --recursive
CXXFLAGS=-fms-extensions cmake '-DBOOST_EXCLUDE_LIBRARIES=context;cobalt;coroutine;fiber;log;thread;wave;type_erasure;serialization;locale;contract;graph'
make -j$(nproc)
make install
popd
rm -rf /boost
EOF

RUN <<EOF
set -eux
git clone https://github.com/unicode-org/icu.git -b maint/maint-58 --depth 1
pushd /icu/icu4c/source
sed -i 's/xlocale/locale/g' i18n/digitlst.cpp
./configure
make -j$(nproc)
make install
popd
rm -rf /icu
EOF

VOLUME [ "/core" ]
WORKDIR /core

COPY dobuild.sh /bin/dobuild.sh
