#!/bin/bash
set -eu

HTTP_SERVER=112.124.9.243

# hack for me
[ -f /etc/friendlyarm ] && source /etc/friendlyarm $(basename $(builtin cd ..; pwd))

# clean
mkdir -p tmp
sudo rm -rf tmp/*

cd tmp
git clone ../../.git sd-fuse_rk3588
cd sd-fuse_rk3588
wget --no-proxy http://${HTTP_SERVER}/dvdfiles/RK3588/images-for-eflasher/ubuntu-noble-desktop-arm64-images.tgz
tar xzf ubuntu-noble-desktop-arm64-images.tgz
wget --no-proxy http://${HTTP_SERVER}/dvdfiles/RK3588/images-for-eflasher/emmc-flasher-images.tgz
tar xzf emmc-flasher-images.tgz

sed -i '/^bootargs/d' ubuntu-noble-desktop-arm64/info.conf
echo "bootargs-ext=preempt=full nohz_full=all threadirqs rcu_nocbs=all rcutree.enable_rcu_lazy=1" >> ubuntu-noble-desktop-arm64/info.conf

# Custom boot parameters are only supported for sd-to-emmc images
./mk-emmc-image.sh ubuntu-noble-desktop-arm64
