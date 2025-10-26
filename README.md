# Lichee Pi Zero (Dock) 用のカスタム

## 対象

- buildroot-2025.02.6 

## 作成

### 入手

https://buildroot.org/download.html

Long-term support	2025.02.x

### 展開

buildroot-2025.02.7

### git clone

```shell
git clone git@github.com:AdenoBluesky/LicheePiZeroDock_Ext_Base.git
```

### make

```shell
make list-defconfigs BR2_EXTERNAL=LicheePiZeroDock_Ext_Base
make menuconfig sipeed_licheepi_zero_defconfig
make
```

### 動作確認・ファームアップ

#### 有線LANのアクティブ化

```shell
ifconfig eth0 192.168.2.50 netmask 255.255.255.0 up
```

#### SWUpdateのWEBUIにアクセス

```shell
http://192.168.2.50:8080/
```

#### SWUファイルの作成

```bash
$ ./build_swu.sh 
sw-description
rootfs.ext4.gz
toggle_partition.sh
10429 ブロック
```

>output/images/firmware_2025.10.16.swu

が生成される

## メモ

### U-boot変更時

uboot変更の度に差分生成コピーをやる必要がある

#### 差分を生成

```bash
make uboot-savedefconfig
# 生成物: output/build/uboot-*/defconfig

cp output/build/uboot-2025.07/defconfig licheepi-external/board/licheepi_zero/uboot-fragment.config

```

#### BR2_EXTERNALに取り込み

BR2_EXTERNALに参照設定

```bash
BR2_TARGET_UBOOT_USE_CUSTOM_CONFIG=y
BR2_TARGET_UBOOT_CUSTOM_CONFIG_FILE="$(BR2_EXTERNAL_LICHEEPIZERODOCK_EXT_BASE_PATH)/board/licheepi_zero/uboot-fragment.config"
```

### SWUpdate変更時

### swupdate-menuconfig

```bash
make swupdate-menuconfig

# 保存時
make swupdate-update-config
```

## 素材

### SWUpdateの背景

ぱくたそ［ https://www.pakutaso.com ］
https://www.pakutaso.com/20241048303post-52368.html