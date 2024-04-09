#!/bin/bash

TARGET_OS=$(echo ${1,,}|sed 's/\///g')
case ${TARGET_OS} in
buildroot*)
        ROMFILE=buildroot-images.tgz;;
android12)
        ROMFILE=android-12-images.tgz;;
androidtv)
        ROMFILE=android-tv-images.tgz;;
friendlywrt22)
        ROMFILE=friendlywrt22-images.tgz;;
friendlywrt22-docker)
        ROMFILE=friendlywrt22-docker-images.tgz;;
friendlywrt21)
        ROMFILE=friendlywrt21-images.tgz;;
friendlywrt21-docker)
        ROMFILE=friendlywrt21-docker-images.tgz;;
debian-*|ubuntu-*|friendlycore-*|openmediavault-*)
        ROMFILE=${TARGET_OS%-*}-arm64-images.tgz;;
eflasher)
        ROMFILE=emmc-flasher-images.tgz;;
*)
        ROMFILE=unsupported-${TARGET_OS}.tgz;;
esac
echo $ROMFILE
