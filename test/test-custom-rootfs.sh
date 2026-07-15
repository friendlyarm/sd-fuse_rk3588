#!/bin/bash
set -eu

if [ -f "$(dirname "$(readlink -f "$0")")/../.use-local-r2" ]; then
    CDN_URL=http://cdn.local/friendlyelec-cdn/os-images/rk3588/images
    ROOTFS_URL=http://cdn.local/friendlyelec-cdn/rootfs/rk3588
else
    CDN_URL=https://downloads.friendlyelec.com/os-images/rk3588/images
    ROOTFS_URL=https://downloads.friendlyelec.com/rootfs/rk3588
fi
# hack for me
[ -f /etc/friendlyarm ] && source /etc/friendlyarm $(basename $(builtin cd ..; pwd))

# clean
mkdir -p tmp
sudo rm -rf tmp/*

cd tmp
git clone ../../.git sd-fuse_rk3588
cd sd-fuse_rk3588
wget ${CDN_URL}/ubuntu-jammy-minimal-arm64-images.tgz
tar xzf ubuntu-jammy-minimal-arm64-images.tgz
wget ${CDN_URL}/emmc-flasher-images.tgz
tar xzf emmc-flasher-images.tgz
wget ${ROOTFS_URL}/rootfs-ubuntu-jammy-minimal-arm64.tgz
wget ${ROOTFS_URL}/rootfs-ubuntu-jammy-minimal-arm64.tgz.sha256
sha256sum -c rootfs-ubuntu-jammy-minimal-arm64.tgz.sha256

sudo tar xzfp rootfs-ubuntu-jammy-minimal-arm64.tgz --numeric-owner --same-owner
echo hello > ubuntu-jammy-minimal-arm64/rootfs/home/pi/welcome.txt
sudo ./build-rootfs-img.sh ubuntu-jammy-minimal-arm64/rootfs ubuntu-jammy-minimal-arm64

./mk-sd-image.sh ubuntu-jammy-minimal-arm64
./mk-emmc-image.sh ubuntu-jammy-minimal-arm64
