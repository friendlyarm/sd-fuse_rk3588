#!/bin/bash
set -eu

HTTP_SERVER=112.124.9.243
SOC=rk3588

# hack for me
[ -f /etc/friendlyarm ] && source /etc/friendlyarm $(basename $(builtin cd ..; pwd))

# clean
mkdir -p tmp
sudo rm -rf tmp/*

cd tmp
git clone ../../.git sd-fuse
cd sd-fuse
wget --no-proxy http://${HTTP_SERVER}/dvdfiles/${SOC^^}/images-for-eflasher/ubuntu-focal-desktop-arm64-images.tgz
tar xzf ubuntu-focal-desktop-arm64-images.tgz
wget --no-proxy http://${HTTP_SERVER}/dvdfiles/${SOC^^}/images-for-eflasher/emmc-flasher-images.tgz
tar xzf emmc-flasher-images.tgz
wget --no-proxy http://${HTTP_SERVER}/dvdfiles/${SOC^^}/rootfs/rootfs-ubuntu-focal-desktop-arm64.tgz

sudo tar xzfp rootfs-ubuntu-focal-desktop-arm64.tgz --numeric-owner --same-owner
sudo -E FS_TYPE=btrfs ./build-rootfs-img.sh ubuntu-focal-desktop-arm64/rootfs ubuntu-focal-desktop-arm64

./mk-sd-image.sh ubuntu-focal-desktop-arm64
./mk-emmc-image.sh ubuntu-focal-desktop-arm64
