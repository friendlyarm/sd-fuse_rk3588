#!/bin/bash
set -eu

HTTP_SERVER=112.124.9.243
KERNEL_URL=https://github.com/friendlyarm/kernel-rockchip
KERNEL_BRANCH=nanopi6-v6.1.y

# clean
mkdir -p tmp
sudo rm -rf tmp/*

cd tmp
git clone ../../.git sd-fuse_rk3588
cd sd-fuse_rk3588

# hack for me
PCNAME=`hostname`
if [ x"${PCNAME}" = x"tzs-i7pc" ]; then
	HTTP_SERVER=127.0.0.1
	KERNEL_URL=git@192.168.1.5:/devel/kernel/linux.git
	KERNEL_BRANCH=nanopi6-v6.1.y_dev
	mkdir -p out
	cp -af /opt/work-tzs/friendlywrt-global/kernel-3rd-drivers/* out/
fi

if [ -f ../../debian-bookworm-core-arm64-images.tgz ]; then
	tar xvzf ../../debian-bookworm-core-arm64-images.tgz
else
	wget --no-proxy http://${HTTP_SERVER}/dvdfiles/RK3588/images-for-eflasher/debian-bookworm-core-arm64-images.tgz
    tar xvzf debian-bookworm-core-arm64-images.tgz
fi

if [ -f ../../kernel-rk3588.tgz ]; then
	tar xvzf ../../kernel-rk3588.tgz
else
	git clone ${KERNEL_URL} --depth 1 -b ${KERNEL_BRANCH} kernel-rk3588
fi

KERNEL_SRC=$PWD/kernel-rk3588 ./build-kernel.sh debian-bookworm-core-arm64
sudo ./mk-sd-image.sh debian-bookworm-core-arm64
