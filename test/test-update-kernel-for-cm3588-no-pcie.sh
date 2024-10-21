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
[ -f /etc/friendlyarm ] && source /etc/friendlyarm $(basename $(builtin cd ..; pwd))

if [ -f ../../ubuntu-noble-desktop-arm64-images.tgz ]; then
	tar xvzf ../../ubuntu-noble-desktop-arm64-images.tgz
else
	wget --no-proxy http://${HTTP_SERVER}/dvdfiles/RK3588/images-for-eflasher/ubuntu-noble-desktop-arm64-images.tgz
    tar xvzf ubuntu-noble-desktop-arm64-images.tgz
fi

if [ -f ../../emmc-flasher-images.tgz ]; then
	tar xvzf ../../emmc-flasher-images.tgz
else
	wget --no-proxy http://${HTTP_SERVER}/dvdfiles/RK3588/images-for-eflasher/emmc-flasher-images.tgz
	tar xzf emmc-flasher-images.tgz
fi

if [ -f ../../kernel-rk3588.tgz ]; then
	tar xvzf ../../kernel-rk3588.tgz
else
	git clone ${KERNEL_URL} --depth 1 -b ${KERNEL_BRANCH} kernel-rk3588
fi
pushd kernel-rk3588
git am ../test/kernel-patches/0001-disable-PCIe-func-of-the-cm3588.patch
popd

wget http://${HTTP_SERVER}/sd-fuse/kernel-3rd-drivers.tgz
if [ -f kernel-3rd-drivers.tgz ]; then
	pushd out
	tar xzf ../kernel-3rd-drivers.tgz
	popd
fi

KERNEL_SRC=$PWD/kernel-rk3588 ./build-kernel.sh ubuntu-noble-desktop-arm64
KERNEL_SRC=$PWD/kernel-rk3588 ./build-kernel.sh eflasher

sudo ./mk-sd-image.sh ubuntu-noble-desktop-arm64
sudo ./mk-emmc-image.sh ubuntu-noble-desktop-arm64
sudo ./mk-sd-image.sh eflasher
