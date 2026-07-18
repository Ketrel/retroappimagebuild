#!/bin/sh

#02 build appimagetool
cd /work/appimagetool
cmake -B _build -DCMAKE_INSTALL_PREFIX=/ .
cmake --build _build -j$(nproc)
DESTDIR=/work/staging cmake --install _build
