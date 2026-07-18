#!/bin/sh

#00 make work env
./step-00.sh

#01 clone the initial repos
./step-01.sh

#02 build appimagetool
./step-02.sh

#03 build linuxdeploy
./step-03.sh

#04 build linuxdeploy appimage plugin
./step-04.sh

#05 build retroarch
./step-05.sh

#06 assemble appimage
./step-06.sh
