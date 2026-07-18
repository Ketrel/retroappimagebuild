#!/bin/sh

#05 build retroarch
cd /work/RetroArch
./configure \
    --prefix=/usr \
    --disable-cdrom \
    --enable-ffmpeg \
    --enable-ssa \
    --enable-qt \
    --enable-lua \
    --enable-vulkan \
    --enable-hid
make -j$(nproc)
make install DESTDIR=/work/staging/retro/AppDir
cp ./media/retroarch-96x96.png /work/staging/retro/retroarch.png

