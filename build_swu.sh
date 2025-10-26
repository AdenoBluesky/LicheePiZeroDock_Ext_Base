#!/bin/bash
set -e
VERSION="2025.10.16"
OUT="../output/images/firmware_${VERSION}.swu"

# rootfs圧縮
gzip -c ../output/images/rootfs.ext4 > rootfs.ext4.gz

# 署名（任意）
# openssl dgst -sha256 -sign private.pem -out sw-description.sig sw-description

# パッケージ作成
# tar -cf ${OUT} sw-description rootfs.ext4.gz toggle_partition.sh



# ファイルの順序リストを作成（sw-description を必ず先頭に）
# 署名する場合は2番目に sw-description.sig
printf "%s\n" sw-description rootfs.ext4.gz toggle_partition.sh > filelist

# cpio で “crc” 形式のアーカイブを作る（これが .swu）
# 圧縮なし（まずはノンプリで試すのが確実）
cpio -ov -H crc --owner root:root < filelist > ${OUT}

rm rootfs.ext4.gz