#!/bin/bash
set -eu

if [ -f "$(dirname "$(readlink -f "$0")")/../.use-local-r2" ]; then
    CDN_URL=http://cdn.local/friendlyelec-cdn/os-images/rk3588/images/old/kernel-5.10.y/images-for-eflasher
    EMMC_FLASHER_URL=http://cdn.local/friendlyelec-cdn/os-images/rk3588/images
else
    CDN_URL=https://downloads.friendlyelec.com/os-images/rk3588/images/old/kernel-5.10.y/images-for-eflasher
    EMMC_FLASHER_URL=https://downloads.friendlyelec.com/os-images/rk3588/images
fi
# hack for me
[ -f /etc/friendlyarm ] && source /etc/friendlyarm $(basename $(builtin cd ..; pwd))

# clean
mkdir -p tmp
sudo rm -rf tmp/*

cd tmp
git clone ../../.git sd-fuse_rk3588
cd sd-fuse_rk3588
wget ${CDN_URL}/debian-bullseye-desktop-arm64-images.tgz
tar xzf debian-bullseye-desktop-arm64-images.tgz
wget ${EMMC_FLASHER_URL}/emmc-flasher-images.tgz
tar xzf emmc-flasher-images.tgz

# make big file
fallocate -l 5G debian-bullseye-desktop-arm64/rootfs.img

# calc image size
IMG_SIZE=`du -s -B 1 debian-bullseye-desktop-arm64/rootfs.img | cut -f1`

# re-gen parameter.txt
./tools/generate-partmap-txt.sh ${IMG_SIZE} debian-bullseye-desktop-arm64

./mk-sd-image.sh debian-bullseye-desktop-arm64
sudo ./mk-emmc-image.sh debian-bullseye-desktop-arm64
