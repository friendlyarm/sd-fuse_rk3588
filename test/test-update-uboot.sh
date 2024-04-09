#!/bin/bash
set -eux

HTTP_SERVER=112.124.9.243
UBOOT_REPO=https://github.com/friendlyarm/uboot-rockchip
UBOOT_BRANCH=nanopi5-v2017.09

# hack for me
[ -f /etc/friendlyarm ] && source /etc/friendlyarm $(basename $(builtin cd ..; pwd))

# clean
mkdir -p tmp
sudo rm -rf tmp/*

cd tmp
git clone ../../.git sd-fuse_rk3588
cd sd-fuse_rk3588
if [ -f ../../ubuntu-jammy-minimal-arm64-images.tgz ]; then
	tar xvzf ../../ubuntu-jammy-minimal-arm64-images.tgz
else
	wget --no-proxy http://${HTTP_SERVER}/dvdfiles/RK3588/old/kernel-5.10.y/images-for-eflasher/ubuntu-jammy-minimal-arm64-images.tgz
    tar xvzf ubuntu-jammy-minimal-arm64-images.tgz
fi

git clone ${UBOOT_REPO} --depth 1 -b ${UBOOT_BRANCH} uboot-rk3588
[ -d rkbin ] || git clone https://github.com/friendlyarm/rkbin --depth 1 -b nanopi6
UBOOT_SRC=$PWD/uboot-rk3588 ./build-uboot.sh ubuntu-jammy-minimal-arm64
sudo ./mk-sd-image.sh ubuntu-jammy-minimal-arm64
