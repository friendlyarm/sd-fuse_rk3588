#!/bin/bash
set -eu

if ! command -v convert >/dev/null 2>&1; then
  sudo apt install graphicsmagick-imagemagick-compat
fi

if ! command -v convert >/dev/null 2>&1; then
	echo "Error: Unable to find the convert command."
	exit 1
fi

HTTP_SERVER=112.124.9.243
KERNEL_URL=https://github.com/friendlyarm/kernel-rockchip
KERNEL_BRANCH=nanopi6-v6.1.y

# hack for me
[ -f /etc/friendlyarm ] && source /etc/friendlyarm $(basename $(builtin cd ..; pwd))

# clean
mkdir -p tmp
sudo rm -rf tmp/*

cd tmp
git clone ../../.git sd-fuse_rk3588
cd sd-fuse_rk3588

if [ ! -d ubuntu-noble-desktop-arm64 ]; then
	wget --no-proxy http://${HTTP_SERVER}/dvdfiles/RK3588/images-for-eflasher/ubuntu-noble-desktop-arm64-images.tgz
	tar xvzf ubuntu-noble-desktop-arm64-images.tgz
fi

if [ ! -d eflasher ]; then
	wget --no-proxy http://${HTTP_SERVER}/dvdfiles/RK3588/images-for-eflasher/emmc-flasher-images.tgz
	tar xvzf emmc-flasher-images.tgz
fi

if [ ! -d kernel-rk3588 ]; then
	git clone ${KERNEL_URL} --depth 1 -b ${KERNEL_BRANCH} kernel-rk3588
fi

convert files/logo.jpg -type truecolor /tmp/logo.bmp
convert files/logo.jpg -type truecolor /tmp/logo_kernel.bmp
LOGO=/tmp/logo.bmp KERNEL_LOGO=/tmp/logo_kernel.bmp ./build-kernel.sh eflasher
LOGO=/tmp/logo.bmp KERNEL_LOGO=/tmp/logo_kernel.bmp ./build-kernel.sh ubuntu-noble-desktop-arm64

sudo ./mk-sd-image.sh ubuntu-noble-desktop-arm64
sudo ./mk-emmc-image.sh ubuntu-noble-desktop-arm64
