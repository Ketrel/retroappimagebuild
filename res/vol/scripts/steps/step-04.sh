#!/bin/sh

#04 build linuxdeploy appimage plugin
cd /work/linuxdeploy-plugin-appimage
git submodule update --init --recursive
cmake -B _build -DCMAKE_INSTALL_PREFIX=/ .
cmake --build _build -j$(nproc)
DESTDIR=/work/staging cmake --install _build

