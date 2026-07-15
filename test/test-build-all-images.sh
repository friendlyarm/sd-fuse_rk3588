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


wget ${CDN_URL}/friendlycore-focal-arm64-images.tgz
tar xzf friendlycore-focal-arm64-images.tgz

wget ${CDN_URL}/debian-bullseye-desktop-arm64-images.tgz
tar xzf debian-bullseye-desktop-arm64-images.tgz

wget ${CDN_URL}/debian-bullseye-core-arm64-images.tgz
tar xzf debian-bullseye-core-arm64-images.tgz

wget ${CDN_URL}/debian-bullseye-minimal-arm64-images.tgz
tar xzf debian-bullseye-minimal-arm64-images.tgz

wget ${CDN_URL}/ubuntu-jammy-desktop-arm64-images.tgz
tar xzf ubuntu-jammy-desktop-arm64-images.tgz

wget ${CDN_URL}/ubuntu-jammy-minimal-arm64-images.tgz
tar xzf ubuntu-jammy-minimal-arm64-images.tgz

wget ${EMMC_FLASHER_URL}/emmc-flasher-images.tgz
tar xzf emmc-flasher-images.tgz

./mk-sd-image.sh debian-bullseye-desktop-arm64
./mk-emmc-image.sh debian-bullseye-desktop-arm64

./mk-sd-image.sh debian-bullseye-core-arm64
./mk-emmc-image.sh debian-bullseye-core-arm64

./mk-sd-image.sh debian-bullseye-minimal-arm64
./mk-emmc-image.sh debian-bullseye-minimal-arm64

./mk-sd-image.sh ubuntu-jammy-desktop-arm64
./mk-emmc-image.sh ubuntu-jammy-desktop-arm64

./mk-sd-image.sh ubuntu-jammy-minimal-arm64
./mk-emmc-image.sh ubuntu-jammy-minimal-arm64

./mk-sd-image.sh friendlycore-focal-arm64
./mk-emmc-image.sh friendlycore-focal-arm64

./mk-emmc-image.sh ubuntu-jammy-desktop-arm64 filename=ubuntu-jammy-desktop-arm64-auto-eflasher.img autostart=yes

echo "done."
