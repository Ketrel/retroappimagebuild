#!/bin/sh

#00 make work env
mkdir /work
cd /work
mkdir staging
mkdir staging/retro

#01 clone the initial repos
git clone https://github.com/AppImage/appimagetool
git clone https://github.com/linuxdeploy/linuxdeploy
git clone https://github.com/linuxdeploy/linuxdeploy-plugin-qt
git clone https://github.com/linuxdeploy/linuxdeploy-plugin-appimage
git clone https://github.com/libretro/RetroArch

#02 build appimagetool
cd /work/appimagetool
cmake -B _build -DCMAKE_INSTALL_PREFIX=/ .
cmake --build _build -j$(nproc)
DESTDIR=/work/staging cmake --install _build


#03 build linuxdeploy
cd /work/linuxdeploy
git submodule update --init --recursive
cmake -B _build -DCMAKE_INSTALL_PREFIX=/ .
cmake --build _build -j$(nproc)
DESTDIR=/work/staging cmake --install _build

#04 build linuxdeploy appimage plugin
cd /work/linuxdeploy-plugin-appimage
git submodule update --init --recursive
cmake -B _build -DCMAKE_INSTALL_PREFIX=/ .
cmake --build _build -j$(nproc)
DESTDIR=/work/staging cmake --install _build

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

#06 assemble appimage
cd /work/staging/retro
PATH="${PATH}:/work/staging/bin" /work/staging/bin/linuxdeploy \
    --appdir AppDir \
    -e ./AppDir/usr/bin/retroarch \
    -i ./retroarch.png \
    --icon-filename=com.libretro.RetroArch \
    --output appimage

