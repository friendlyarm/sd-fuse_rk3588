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
wget --no-proxy http://${HTTP_SERVER}/dvdfiles/RK3588/images-for-eflasher/ubuntu-jammy-minimal-arm64-images.tgz
tar xzf ubuntu-jammy-minimal-arm64-images.tgz
wget --no-proxy http://${HTTP_SERVER}/dvdfiles/RK3588/images-for-eflasher/emmc-flasher-images.tgz
tar xzf emmc-flasher-images.tgz
wget --no-proxy http://${HTTP_SERVER}/dvdfiles/RK3588/rootfs/rootfs-ubuntu-jammy-minimal-arm64.tgz

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
