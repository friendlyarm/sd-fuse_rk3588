#!/bin/bash
set -eu

[ -f ${PWD}/mk-emmc-image.sh ] || {
	echo "Error: please run at the script's home dir"
	exit 1
}

cp -f $2/boot.img $1/
cp -f $2/idbloader.img $1/
cp -f $2/misc.img $1/
cp -f $2/dtbo.img $1/


if [ ! -f $1/userdata.img ]; then
	USERDATA_SIZE=104857600
	echo "Generating empty userdata.img (size:${USERDATA_SIZE})"
	TMPDIR=`mktemp -d`
    IMG_BLK=$((${USERDATA_SIZE} / 4096))
    [ -f $1/userdata.img ] && rm -f $1/userdata.img
    ${PWD}/tools/mke2fs -E android_sparse -t ext4 -L userdata -M /root -b 4096 -d ${TMPDIR} $1/userdata.img ${IMG_BLK}
	rm -rf ${TMPDIR}
fi

exit $?
