#!/bin/sh

DEBIAN_FRONTEND=noninteractive
apt update
apt install -y qt5base-dev qt6base-dev
cd /staging/retro
sed -i 's/^Version=1.5/Version=1.4/ ; s/^SingleMainWindow/X-SingleMainWindow/' AppDir/usr/share/applications/com.libretro.RetroArch.desktop
linuxdeploy \
    --appdir AppDir \
    -e ./AppDir/usr/bin/retroarch \
    -i ./retroarch.png \
    --icon-filename=com.libretro.RetroArch \
    --output appimage

if [ -n "${COMMIT}" ]; then
    mv -n *.AppImage RetroArch-${COMMIT}.AppImage
else
    mv -n *.AppImage RetroArch-$(date +"%Y%m%d-%H%M%S").AppImage
fi

mv -n *.AppImage /output/

