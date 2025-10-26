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