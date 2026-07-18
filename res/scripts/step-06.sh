#!/bin/sh

#06 assemble appimage
cd /work/staging/retro
sed -i 's/^Version=1.5/Version=1.4/ ; s/^SingleMainWindow/X-SingleMainWindow/' AppDir/usr/share/applications/com.libretro.RetroArch.desktop
PATH="${PATH}:/work/staging/bin" /work/staging/bin/linuxdeploy \
    --appdir AppDir \
    -e ./AppDir/usr/bin/retroarch \
    -i ./retroarch.png \
    --icon-filename=com.libretro.RetroArch \
    --output appimage
mv -n *.AppImage RetroArch-$(date +"%Y%m%d-%H%M%S").AppImage
mv -n *.AppImage /output/

