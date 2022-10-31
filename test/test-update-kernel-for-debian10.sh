#!/bin/bash
set -eu

HTTP_SERVER=112.124.9.243
KERNEL_URL=https://github.com/friendlyarm/kernel-rockchip
KERNEL_BRANCH=nanopi5-v5.10.y_opt

# hack for me
PCNAME=`hostname`
if [ x"${PCNAME}" = x"tzs-i7pc" ]; then
	HTTP_SERVER=127.0.0.1
	KERNEL_URL=git@192.168.1.5:/devel/kernel/linux.git
	KERNEL_BRANCH=nanopi5-v5.10.y_opt
fi

# clean
mkdir -p tmp
sudo rm -rf tmp/*

cd tmp
git clone ../../.git sd-fuse_rk3588
cd sd-fuse_rk3588
if [ -f ../../debian-buster-desktop-arm64-images.tgz ]; then
	tar xvzf ../../debian-buster-desktop-arm64-images.tgz
else
	wget --no-proxy http://${HTTP_SERVER}/dvdfiles/RK3588/images-for-eflasher/debian-buster-desktop-arm64-images.tgz
    tar xvzf debian-buster-desktop-arm64-images.tgz
fi

if [ -f ../../kernel-rk3588.tgz ]; then
	tar xvzf ../../kernel-rk3588.tgz
else
	git clone ${KERNEL_URL} --depth 1 -b ${KERNEL_BRANCH} kernel-rk3588
fi

BUILD_THIRD_PARTY_DRIVER=0 KERNEL_SRC=$PWD/kernel-rk3588 ./build-kernel.sh debian-buster-desktop-arm64
sudo ./mk-sd-image.sh debian-buster-desktop-arm64
