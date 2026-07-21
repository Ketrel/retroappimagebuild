#!/bin/sh

cd /git/RetroArch

git clean -dxf
git reset --hard HEAD

if [ -n "${COMMIT}" ]; then
    git checkout "${COMMIT}" && git reset --hard HEAD || \
    (printf 'Could not check out specified commit or tag: %s\n' "${COMMIT}"; exit 5)
else
    git checkout master && git reset --hard HEAD
fi

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
make install DESTDIR=/staging/retro/AppDir
cp ./media/retroarch-96x96.png /staging/retro/retroarch.png

