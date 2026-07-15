#!/bin/bash
set -eu

# Copyright (C) Guangzhou FriendlyElec Computer Tech. Co., Ltd.
# (http://www.friendlyelec.com)
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, you can access it online at
# http://www.gnu.org/licenses/gpl-2.0.html.

# ----------------------------------------------------------
# base setup

# CDN base URL: local MinIO when .use-local-r2 exists at repo root,
# else production Cloudflare R2 (自定义域 cdn.friendlyelec.com).
SDFUSE_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
if [ -f "${SDFUSE_ROOT}/.use-local-r2" ]; then
    BASE_URL=http://cdn.local/friendlyelec-cdn/os-images
else
    BASE_URL=https://cdn.friendlyelec.com/os-images
fi
OPT_URL=http://wiki.friendlyarm.com/download/
BOARD=rk3588/images
TARGET_OS=$(echo ${1,,}|sed 's/\///g')
ROMFILE=`./tools/get_pkg_filename.sh ${TARGET_OS}`
if [ -z ${ROMFILE} ]; then
	echo "Usage: $0 <buildroot|debian-buster-desktop-arm64|debian-bullseye-desktop-arm64|debian-bullseye-minimal-arm64|debian-bullseye-core-arm64|friendlycore-focal-arm64|openmediavault-arm64|ubuntu-jammy-desktop-arm64|ubuntu-jammy-minimal-arm64|friendlywrt22|friendlywrt22-docker|friendlywrt21|friendlywrt21-docker|eflasher>"
	exit 1
fi

#----------------------------------------------------------
# local functions

function FA_DoExec() {
	echo "> ${@}"
	eval $@
}

function download_file()
{
	local url=${BASE_URL}/${BOARD}/$1

	if [ -z $1 ]; then
		echo "Error downloading file: $1"
		exit 1
	fi

	if [ -f $1 ]; then
		rm -fv $1
	fi

	FA_DoExec wget --spider --tries=1 ${url}
	if [[ "$?" != 0 ]]; then
		url=${OPT_URL}/${BOARD}/$1
	fi

	FA_DoExec wget ${url}
	if [[ "$?" != 0 ]]; then
		echo "Error downloading file: $1"
		exit 1
	fi

	return 0
}

#----------------------------------------------------------
# download image and verify it

download_file ${ROMFILE}.sha256

if [ -f ${ROMFILE} ]; then
	sha256sum -c ${ROMFILE}.sha256 >/dev/null 2>&1
	NEED_DL=$?
else
	NEED_DL=1
fi

# skip if main file exist and sha256sum check OK
if [ ${NEED_DL} -ne 0 ]; then
	download_file ${ROMFILE}
fi

sha256sum -c ${ROMFILE}.sha256
if [[ "$?" != 0 ]]; then
	echo "Error in downloaded file, please try again, or download it by"
	echo "browser or other tools, URL is:"
	echo "  ${BASE_URL}/${BOARD}/${ROMFILE}"
	echo "  ${BASE_URL}/${BOARD}/${ROMFILE}.sha256"
	exit 1
fi

#----------------------------------------------------------
# extract

mkdir -p ${TARGET_OS}

if [ -f ${ROMFILE} ]; then
	XOPTS="-C ${TARGET_OS} --strip-components=1"
	FA_DoExec tar xzvf ${ROMFILE} ${XOPTS} || exit 1
fi
