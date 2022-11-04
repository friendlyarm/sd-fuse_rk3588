#!/bin/bash
set -eu

HTTP_SERVER=112.124.9.243

# hack for me
PCNAME=`hostname`
if [ x"${PCNAME}" = x"tzs-i7pc" ]; then
       HTTP_SERVER=127.0.0.1
fi

# clean
mkdir -p tmp
sudo rm -rf tmp/*

cd tmp
git clone ../../.git sd-fuse_rk3588
cd sd-fuse_rk3588

wget --no-proxy http://${HTTP_SERVER}/dvdfiles/RK3588/images-for-eflasher/friendlywrt22-images.tgz
tar xzf friendlywrt22-images.tgz

wget --no-proxy http://${HTTP_SERVER}/dvdfiles/RK3588/images-for-eflasher/friendlywrt22-docker-images.tgz
tar xzf friendlywrt22-docker-images.tgz

wget --no-proxy http://${HTTP_SERVER}/dvdfiles/RK3588/images-for-eflasher/friendlywrt21-images.tgz
tar xzf friendlywrt21-images.tgz

wget --no-proxy http://${HTTP_SERVER}/dvdfiles/RK3588/images-for-eflasher/friendlywrt21-docker-images.tgz
tar xzf friendlywrt21-docker-images.tgz

wget --no-proxy http://${HTTP_SERVER}/dvdfiles/RK3588/images-for-eflasher/emmc-flasher-images.tgz
tar xzf emmc-flasher-images.tgz

wget --no-proxy http://${HTTP_SERVER}/dvdfiles/RK3588/images-for-eflasher/debian-buster-desktop-arm64-images.tgz
tar xzf debian-buster-desktop-arm64-images.tgz

wget --no-proxy http://${HTTP_SERVER}/dvdfiles/RK3588/images-for-eflasher/debian-bullseye-desktop-arm64-images.tgz
tar xzf debian-bullseye-desktop-arm64-images.tgz

wget --no-proxy http://${HTTP_SERVER}/dvdfiles/RK3588/images-for-eflasher/ubuntu-jammy-desktop-arm64-images.tgz
tar xzf ubuntu-jammy-desktop-arm64-images.tgz

wget --no-proxy http://${HTTP_SERVER}/dvdfiles/RK3588/images-for-eflasher/ubuntu-jammy-minimal-arm64-images.tgz
tar xzf ubuntu-jammy-minimal-arm64-images.tgz

./mk-sd-image.sh debian-buster-desktop-arm64
./mk-emmc-image.sh debian-buster-desktop-arm64

./mk-sd-image.sh debian-bullseye-desktop-arm64
./mk-emmc-image.sh debian-bullseye-desktop-arm64

./mk-sd-image.sh ubuntu-jammy-desktop-arm64
./mk-emmc-image.sh ubuntu-jammy-desktop-arm64

./mk-sd-image.sh ubuntu-jammy-minimal-arm64
./mk-emmc-image.sh ubuntu-jammy-minimal-arm64

./mk-sd-image.sh friendlywrt22
./mk-emmc-image.sh friendlywrt22

./mk-sd-image.sh friendlywrt22-docker
./mk-emmc-image.sh friendlywrt22-docker

./mk-sd-image.sh friendlywrt21
./mk-emmc-image.sh friendlywrt21

./mk-sd-image.sh friendlywrt21-docker
./mk-emmc-image.sh friendlywrt21-docker

./mk-emmc-image.sh ubuntu-jammy-desktop-arm64 filename=ubuntu-jammy-desktop-arm64-auto-eflasher.img autostart=yes

echo "done."
