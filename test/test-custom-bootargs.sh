#!/bin/bash
set -eu

if [ -f "$(dirname "$(readlink -f "$0")")/../.use-local-r2" ]; then
    CDN_URL=http://cdn.local/friendlyelec-cdn/os-images/rk3588/images
else
    CDN_URL=https://downloads.friendlyelec.com/os-images/rk3588/images
fi
# hack for me
[ -f /etc/friendlyarm ] && source /etc/friendlyarm $(basename $(builtin cd ..; pwd))

# clean
mkdir -p tmp
sudo rm -rf tmp/*

cd tmp
git clone ../../.git sd-fuse_rk3588
cd sd-fuse_rk3588
wget ${CDN_URL}/ubuntu-noble-desktop-arm64-images.tgz
tar xzf ubuntu-noble-desktop-arm64-images.tgz
wget ${CDN_URL}/emmc-flasher-images.tgz
tar xzf emmc-flasher-images.tgz

sed -i '/^bootargs/d' ubuntu-noble-desktop-arm64/info.conf
echo "bootargs-ext=preempt=full nohz_full=all threadirqs rcu_nocbs=all rcutree.enable_rcu_lazy=1" >> ubuntu-noble-desktop-arm64/info.conf

# Custom boot parameters are only supported for sd-to-emmc images
./mk-emmc-image.sh ubuntu-noble-desktop-arm64
