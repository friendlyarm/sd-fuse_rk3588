#!/bin/bash
set -eu

HTTP_SERVER=112.124.9.243
KERNEL_URL=https://github.com/friendlyarm/kernel-rockchip
KERNEL_BRANCH=nanopi5-v5.10.y_opt

# hack for me
[ -f /etc/friendlyarm ] && source /etc/friendlyarm $(basename $(builtin cd ..; pwd))

# clean
mkdir -p tmp
sudo rm -rf tmp/*

cd tmp
git clone ../../.git sd-fuse_rk3588
cd sd-fuse_rk3588
if [ -f ../../friendlywrt22-images.tgz ]; then
	tar xvzf ../../friendlywrt22-images.tgz
else
	wget --no-proxy http://${HTTP_SERVER}/dvdfiles/RK3588/old/kernel-5.10.y/images-for-eflasher/friendlywrt22-images.tgz
    tar xvzf friendlywrt22-images.tgz
fi

if [ -f ../../kernel-rk3588.tgz ]; then
	tar xvzf ../../kernel-rk3588.tgz
else
	git clone ${KERNEL_URL} --depth 1 -b ${KERNEL_BRANCH} kernel-rk3588
fi

BUILD_THIRD_PARTY_DRIVER=0 KERNEL_SRC=$PWD/kernel-rk3588 ./build-kernel.sh friendlywrt22
sudo ./mk-sd-image.sh friendlywrt22
