#!/bin/sh

cd /staging/retro
sed -i 's/^Version=1.5/Version=1.4/ ; s/^SingleMainWindow/X-SingleMainWindow/' AppDir/usr/share/applications/com.libretro.RetroArch.desktop
QMAKE=/usr/bin/qmake6 linuxdeploy \
    --appdir AppDir \
    -e ./AppDir/usr/bin/retroarch \
    -i ./retroarch.png \
    --icon-filename=com.libretro.RetroArch \
    --plugin qt \
    --output appimage

if [ -n "${COMMIT}" ]; then
    mv -n *.AppImage RetroArch-${COMMIT}${SUFFIX:+"-${SUFFIX}"}.AppImage
else
    mv -n *.AppImage RetroArch-$(date +"%Y%m%d-%H%M%S")${SUFFIX:+"-${SUFFIX}"}.AppImage
fi

mv -n *.AppImage /output/

