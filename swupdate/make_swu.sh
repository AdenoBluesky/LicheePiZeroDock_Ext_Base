#!/bin/bash
set -e

BOARD_DIR="$(dirname "$0")"
: "${BINARIES_DIR:="$1"}"  # 第一引数に渡ってくる場合もあるので保険

echo "Generating SWU package for LicheePi Zero"
echo ${BOARD_DIR}
echo ${BINARIES_DIR}

VERSION="2025.10.16"
OUT="${BINARIES_DIR}/firmware_${VERSION}.swu"

# rootfs圧縮
gzip -c ${BINARIES_DIR}/rootfs.ext4 > ${BINARIES_DIR}/rootfs.ext4.gz

# 署名（任意）
# openssl dgst -sha256 -sign private.pem -out sw-description.sig sw-description

# パッケージ作成
# tar -cf ${OUT} sw-description rootfs.ext4.gz toggle_partition.sh



# ファイルの順序リストを作成（sw-description を必ず先頭に）
# 署名する場合は2番目に sw-description.sig
printf "%s\n" ${BOARD_DIR}/sw-description ${BINARIES_DIR}/rootfs.ext4.gz ${BOARD_DIR}/toggle_partition.sh > ${BINARIES_DIR}/filelist

# cpio で “crc” 形式のアーカイブを作る（これが .swu）
# 圧縮なし（まずはノンプリで試すのが確実）
cpio -ov -H crc --owner root:root < ${BINARIES_DIR}/filelist > ${OUT}

rm ${BINARIES_DIR}/rootfs.ext4.gz
rm ${BINARIES_DIR}/filelist
echo "SWU package created at: ${OUT}"