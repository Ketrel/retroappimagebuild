FROM debian:bookworm
ENV DEBIAN_FRONTEND=noninteractive
RUN \
    apt update && apt full-upgrade && \
    apt install -y \
        appstream build-essential cimg-dev cmake curl desktop-file-utils file fuse3 git libass-dev \
        libavcodec-dev libboost-filesystem-dev libcurl4-openssl-dev libfribidi-dev \
        libfuse2 libfuse3-3 libfuse3-dev libfuse-dev libgcrypt-dev libgles1 libgles2 libgles-dev \
        libglib2.0-dev libglvnd-core-dev libglvnd-dev libgpgme-dev libjpeg-dev libpng-dev libpulse-dev \
        libsdl2-dev libsquashfuse0 libsquashfuse-dev libx11-xcb-dev mesa-common-dev nasm patchelf pkg-config \
        qtbase5-dev squashfs-tools squashfuse wget zlib1g-dev zsync libevdev-dev qt6-base-dev qt6-svg-dev qt6-base-private-dev && \
    rm -rf /var/lib/apt/lists/*
ENTRYPOINT ["/bin/sh", "-c", "cd /res/scripts; ./build.sh"]

