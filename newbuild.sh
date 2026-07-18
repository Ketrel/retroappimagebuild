#!/bin/sh

if [ ! -d "${PWD}/output" ] && [ ! -e "${PWD}/output" ]; then
    mkdir output
fi

podman build \
    -t retrobuild:buildenv \
    -f Dockerfile

podman run \
    --rm \
    --log-driver=json-file \
    -e UID=$(id -u) \
    -e GID=$(id -g) \
    -v "$(pwd)/output:/output" \
    -v "$(pwd)/res:/res:ro" \
    retrobuild:buildenv
