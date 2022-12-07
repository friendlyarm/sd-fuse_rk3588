# sd-fuse_rk3588
Create bootable SD card for NanoPi-R6S  
  
*其他语言版本: [English](README.md)*  
  
## How to find the /dev name of my SD Card
Unplug all usb devices:
```
ls -1 /dev > ~/before.txt
```
plug it in, then
```
ls -1 /dev > ~/after.txt
diff ~/before.txt ~/after.txt
```

## Build debian-buster-desktop-arm64 bootable SD card
```
git clone https://github.com/friendlyarm/sd-fuse_rk3588
cd sd-fuse_rk3588
sudo ./fusing.sh /dev/sdX debian-buster-desktop-arm64
```
You can build the following OS: buildroot, debian-buster-desktop-arm64, debian-bullseye-desktop-arm64, ubuntu-jammy-desktop-arm64, ubuntu-jammy-minimal-arm64, friendlywrt22, friendlywrt22-docker, friendlywrt21, friendlywrt21-docker.
Because the android system has to run on the emmc, so you need to make eflasher img to install Android.  

Notes:  
fusing.sh will check the local directory for a directory with the same name as OS, if it does not exist fusing.sh will go to download it from network.  
So you can download from the netdisk in advance, on netdisk, the images files are stored in a directory called images-for-eflasher, for example:
```
cd sd-fuse_rk3588
tar xvzf ../images-for-eflasher/debian-buster-desktop-arm64-images.tgz
./mk-sd-image.sh /dev/sdX debian-buster-desktop-arm64
```

## Build an sd card image
First, download and unpack:
```
git clone https://github.com/friendlyarm/sd-fuse_rk3588
cd sd-fuse_rk3588
wget --no-proxy http://112.124.9.243/dvdfiles/rk3588/images-for-eflasher/debian-buster-desktop-arm64-images.tgz
tar xvzf debian-buster-desktop-arm64-images.tgz
```
Now,  Change something under the debian-buster-desktop-arm64 directory,
for example, replace the file you compiled, then re-pack sd card image:
```
./mk-sd-image.sh debian-buster-desktop-arm64
```
The following file will be generated:  
```
out/rk3588-sd-debian-buster-desktop-5.10-arm64-YYYYMMDD.img
```
You can use dd to burn this file into an sd card:
```
dd if=out/rk3588-sd-debian-buster-desktop-5.10-arm64-YYYYMMDD.img of=/dev/sdX bs=1M
```
