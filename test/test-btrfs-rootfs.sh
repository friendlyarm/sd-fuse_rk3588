#!/bin/bash
set -eu

if [ -f "$(dirname "$(readlink -f "$0")")/../.use-local-r2" ]; then
    CDN_URL=http://cdn.local/friendlyelec-cdn/os-images/rk3588/images
    ROOTFS_URL=http://cdn.local/friendlyelec-cdn/rootfs/rk3588
else
    CDN_URL=https://downloads.friendlyelec.com/os-images/rk3588/images
    ROOTFS_URL=https://downloads.friendlyelec.com/rootfs/rk3588
fi
SOC=rk3588

# hack for me
[ -f /etc/friendlyarm ] && source /etc/friendlyarm $(basename $(builtin cd ..; pwd))

# clean
mkdir -p tmp
sudo rm -rf tmp/*

cd tmp
git clone ../../.git sd-fuse
cd sd-fuse
wget ${CDN_URL}/ubuntu-focal-desktop-arm64-images.tgz
tar xzf ubuntu-focal-desktop-arm64-images.tgz
wget ${CDN_URL}/emmc-flasher-images.tgz
tar xzf emmc-flasher-images.tgz
wget ${ROOTFS_URL}/rootfs-ubuntu-focal-desktop-arm64.tgz
wget ${ROOTFS_URL}/rootfs-ubuntu-focal-desktop-arm64.tgz.sha256
sha256sum -c rootfs-ubuntu-focal-desktop-arm64.tgz.sha256

sudo tar xzfp rootfs-ubuntu-focal-desktop-arm64.tgz --numeric-owner --same-owner
sudo -E FS_TYPE=btrfs ./build-rootfs-img.sh ubuntu-focal-desktop-arm64/rootfs ubuntu-focal-desktop-arm64

./mk-sd-image.sh ubuntu-focal-desktop-arm64
./mk-emmc-image.sh ubuntu-focal-desktop-arm64
