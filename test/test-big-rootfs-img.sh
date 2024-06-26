#!/bin/bash
set -eu

HTTP_SERVER=112.124.9.243

# hack for me
[ -f /etc/friendlyarm ] && source /etc/friendlyarm $(basename $(builtin cd ..; pwd))

# clean
mkdir -p tmp
sudo rm -rf tmp/*

cd tmp
git clone ../../.git sd-fuse_rk3588
cd sd-fuse_rk3588
wget --no-proxy http://${HTTP_SERVER}/dvdfiles/RK3588/images-for-eflasher/debian-bullseye-desktop-arm64-images.tgz
tar xzf debian-bullseye-desktop-arm64-images.tgz
wget --no-proxy http://${HTTP_SERVER}/dvdfiles/RK3588/images-for-eflasher/emmc-flasher-images.tgz
tar xzf emmc-flasher-images.tgz

# make big file
fallocate -l 5G debian-bullseye-desktop-arm64/rootfs.img

# calc image size
IMG_SIZE=`du -s -B 1 debian-bullseye-desktop-arm64/rootfs.img | cut -f1`

# re-gen parameter.txt
./tools/generate-partmap-txt.sh ${IMG_SIZE} debian-bullseye-desktop-arm64

./mk-sd-image.sh debian-bullseye-desktop-arm64
sudo ./mk-emmc-image.sh debian-bullseye-desktop-arm64
