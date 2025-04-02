#!/usr/bin/bash

set -eo pipefail

POSITIONAL_ARGS=()

QMAKE_ARGS="INCLUDEPATH+=/boost/libs/functional/include/"
QMAKE_LFLAGS="-Wl,--unresolved-symbols=ignore-all"
CFLAGS="-w"

if [ -n "$DEV_MODE" ]; then
  SANITIZE="-fsanitize=address -fsanitize=undefined -Wcast-align -Wover-aligned -sWARN_UNALIGNED=1"
  QMAKE_LFLAGS+=" -sINITIAL_MEMORY=400MB"
fi

while [[ $# -gt 0 ]]; do
  case $1 in
    -q)
      QMAKE_ARGS+=" $2"
      shift # past argument
      shift # past value
      ;;
    -c)
      CFLAGS+=" $2"
      shift # past argument
      shift # past value
      ;;
    -l)
      QMAKE_LFLAGS+=" $2"
      shift # past argument
      shift # past value
      ;;
    --no-sanitize)
      SANITIZE=""
      shift # past argument
      ;;
    *)
      POSITIONAL_ARGS+=("$1") # save positional arg
      shift # past argument
      ;;
  esac
done

echo "# $POSITIONAL_ARGS"

qmake \
    "QMAKE_CXXFLAGS_RELEASE -= -O2" \
    "QMAKE_CXXFLAGS_RELEASE *= -Os" \
    "QMAKE_CFLAGS+=$SANITIZE $CFLAGS" \
    "QMAKE_CXXFLAGS+=$SANITIZE $CFLAGS" \
    "QMAKE_LFLAGS+=$QMAKE_LFLAGS $SANITIZE $CFLAGS" \
    "DEFINES+=__linux__ HAVE_UNISTD_H _RWSTD_NO_SETRLIMIT" \
    $QMAKE_ARGS \
    $POSITIONAL_ARGS

make -j$(nproc)
