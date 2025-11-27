#!/bin/bash
set -e

BOARD_DIR="$(dirname "$0")"
: "${BINARIES_DIR:="$1"}"  # 第一引数に渡ってくる場合もあるので保険

echo "Generating SWU package for LicheePi Zero"
# echo ${BOARD_DIR}
# echo ${BINARIES_DIR}

EXT_ROOT="$(cd "$BOARD_DIR/.." && pwd)"
# echo "Extension root: ${EXT_ROOT}"
GIT_TAG="$(cd "$EXT_ROOT" && git describe --always --dirty)"
echo "Git tag: ${GIT_TAG}"

BUILD_TAG="$(date +%Y%m%d)-${GIT_TAG}"

# VERSION="2025.10.16"
OUT="${BINARIES_DIR}/firmware_${BUILD_TAG}.swu"

# rootfs圧縮
gzip -c ${BINARIES_DIR}/rootfs.ext4 > ${BINARIES_DIR}/rootfs.ext4.gz

# 署名（任意）
# openssl dgst -sha256 -sign private.pem -out sw-description.sig sw-description

# パッケージ作成
# tar -cf ${OUT} sw-description rootfs.ext4.gz toggle_partition.sh

# ▼ sw-description を生成
# cp ${BOARD_DIR}/sw-description ${BINARIES_DIR}/sw-description
DESC_IN="$BOARD_DIR/sw-description"
DESC_OUT="$BINARIES_DIR/sw-description"

sed "s/@VERSION@/$BUILD_TAG/g" "$DESC_IN" > "$DESC_OUT"

cp ${BOARD_DIR}/toggle_partition.sh ${BINARIES_DIR}/toggle_partition.sh

cd ${BINARIES_DIR}

# ファイルの順序リストを作成（sw-description を必ず先頭に）
# 署名する場合は2番目に sw-description.sig
printf "%s\n" sw-description rootfs.ext4.gz toggle_partition.sh > filelist

# cpio で “crc” 形式のアーカイブを作る（これが .swu）
# 圧縮なし（まずはノンプリで試すのが確実）
cpio -ov -H crc --owner root:root < filelist > ${OUT}

rm ${BINARIES_DIR}/rootfs.ext4.gz
rm ${BINARIES_DIR}/sw-description
rm ${BINARIES_DIR}/toggle_partition.sh
rm ${BINARIES_DIR}/filelist
echo "SWU package created at: ${OUT}"