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

RUN <<EOF
set -eux
git clone https://github.com/emscripten-core/emsdk.git
cd /emsdk
git fetch -a && git checkout 3.1.56
./emsdk install 3.1.56
./emsdk activate 3.1.56
cd ..
EOF

RUN <<EOF
set -eux
. /emsdk/emsdk_env.sh
qtchooser -install qt6 $(which qmake6)
EOF
ENV QT_SELECT=qt6

RUN <<EOF
set -eux
. /emsdk/emsdk_env.sh
git clone https://github.com/google/gumbo-parser.git
pushd /gumbo-parser
git checkout aa91b2
./autogen.sh
emconfigure ./configure
emmake make
emmake make install
popd
rm -rf /gumbo-parser
EOF

RUN <<EOF
set -eux
. /emsdk/emsdk_env.sh
git clone https://github.com/jasenhuang/katana-parser.git
pushd /katana-parser
git checkout be6df4
./autogen.sh
emconfigure ./configure
emmake make
emmake make install
popd
rm -rf /katana-parser
EOF

RUN <<EOF
set -eux
. /emsdk/emsdk_env.sh
git clone https://github.com/boostorg/boost.git
pushd /boost
git checkout boost-1.84.0
git submodule update --init --recursive
CXXFLAGS=-fms-extensions emcmake cmake '-DBOOST_EXCLUDE_LIBRARIES=context;cobalt;coroutine;fiber;log;thread;wave;type_erasure;serialization;locale;contract;graph'
emmake make
emmake make install
popd
rm -rf /boost
EOF

VOLUME [ "/core", "/out" ]
WORKDIR /core

COPY embuild.sh /bin/embuild.sh
COPY pre-js.js wrap-main.cpp /
