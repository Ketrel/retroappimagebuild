#!/bin/sh

#03 build linuxdeploy
cd /work/linuxdeploy
git submodule update --init --recursive
cmake -B _build -DCMAKE_INSTALL_PREFIX=/ .
cmake --build _build -j$(nproc)
DESTDIR=/work/staging cmake --install _build

