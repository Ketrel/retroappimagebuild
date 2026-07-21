#!/bin/sh

_location="$(cd -- "$(dirname -- "${0}")" && pwd)" || (echo 'Error Getting DIR Base' && exit 7)

for file in ${_location}/steps/step-*.sh ; do
   if [ -e "${file}" ]; then
       "${file}" || exit
    fi
done
