#!/bin/bash
set -eu

# CDN base URL: local MinIO when .use-local-r2 exists at repo root,
# else production Cloudflare R2. All images-for-eflasher downloads go here.
if [ -f "$(dirname "$(readlink -f "$0")")/../.use-local-r2" ]; then
    CDN_URL=http://cdn.local/friendlyelec-cdn/os-images/rk3588/images
else
    CDN_URL=https://cdn.friendlyelec.com/os-images/rk3588/images
fi
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
if [ -f ../../debian-bullseye-desktop-arm64-images.tgz ]; then
	tar xvzf ../../debian-bullseye-desktop-arm64-images.tgz
else
	wget --no-proxy ${CDN_URL}/debian-bullseye-desktop-arm64-images.tgz
    tar xvzf debian-bullseye-desktop-arm64-images.tgz
fi

if [ -f ../../kernel-rk3588.tgz ]; then
	tar xvzf ../../kernel-rk3588.tgz
else
	git clone ${KERNEL_URL} --depth 1 -b ${KERNEL_BRANCH} kernel-rk3588
fi

BUILD_THIRD_PARTY_DRIVER=0 KERNEL_SRC=$PWD/kernel-rk3588 ./build-kernel.sh debian-bullseye-desktop-arm64
sudo ./mk-sd-image.sh debian-bullseye-desktop-arm64
