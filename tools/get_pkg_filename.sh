#!/bin/bash

TARGET_OS=$1
case ${TARGET_OS} in
buildroot)
        ROMFILE=buildroot-images.tgz;;
friendlywrt22)
        ROMFILE=friendlywrt22-images.tgz;;
friendlywrt22-docker)
        ROMFILE=friendlywrt22-docker-images.tgz;;
friendlywrt21)
        ROMFILE=friendlywrt21-images.tgz;;
friendlywrt21-docker)
        ROMFILE=friendlywrt21-docker-images.tgz;;
debian-buster-desktop-arm64)
        ROMFILE=debian-buster-desktop-arm64-images.tgz;;
debian-bullseye-desktop-arm64)
        ROMFILE=debian-bullseye-desktop-arm64-images.tgz;;
ubuntu-jammy-desktop-arm64)
		ROMFILE=ubuntu-jammy-desktop-arm64-images.tgz;;
ubuntu-jammy-minimal-arm64)
		ROMFILE=ubuntu-jammy-minimal-arm64-images.tgz;;
eflasher)
        ROMFILE=emmc-flasher-images.tgz;;
*)
        ROMFILE=unsupported-${TARGET_OS}.tgz;;
esac
echo $ROMFILE
