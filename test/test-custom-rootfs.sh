#!/bin/bash
set -eu

# CDN base URL: local MinIO when .use-local-r2 exists at repo root,
# else production Cloudflare R2. All images-for-eflasher downloads go here.
if [ -f "$(dirname "$(readlink -f "$0")")/../.use-local-r2" ]; then
    CDN_URL=http://cdn.local/friendlyelec-cdn/os-images/rk3588/images
else
    CDN_URL=https://cdn.friendlyelec.com/os-images/rk3588/images
fi
# hack for me
[ -f /etc/friendlyarm ] && source /etc/friendlyarm $(basename $(builtin cd ..; pwd))

# clean
mkdir -p tmp
sudo rm -rf tmp/*

cd tmp
git clone ../../.git sd-fuse_rk3588
cd sd-fuse_rk3588
wget --no-proxy ${CDN_URL}/ubuntu-jammy-minimal-arm64-images.tgz
tar xzf ubuntu-jammy-minimal-arm64-images.tgz
wget --no-proxy ${CDN_URL}/emmc-flasher-images.tgz
tar xzf emmc-flasher-images.tgz
wget --no-proxy http://112.124.9.243/dvdfiles/RK3588/rootfs/rootfs-ubuntu-jammy-minimal-arm64.tgz

TEMPSCRIPT=`mktemp script.XXXXXX`
cat << 'EOL' > $PWD/$TEMPSCRIPT
#!/bin/bash
tar xzf rootfs-ubuntu-jammy-minimal-arm64.tgz --numeric-owner --same-owner
echo hello > ubuntu-jammy-minimal-arm64/rootfs/root/welcome.txt
./build-rootfs-img.sh ubuntu-jammy-minimal-arm64/rootfs ubuntu-jammy-minimal-arm64
EOL
chmod 755 $PWD/$TEMPSCRIPT
if [ $(id -u) -ne 0 ]; then
    ./tools/fakeroot-ng $PWD/$TEMPSCRIPT
else
    $PWD/$TEMPSCRIPT
fi
rm $PWD/$TEMPSCRIPT

./mk-sd-image.sh ubuntu-jammy-minimal-arm64
./mk-emmc-image.sh ubuntu-jammy-minimal-arm64
