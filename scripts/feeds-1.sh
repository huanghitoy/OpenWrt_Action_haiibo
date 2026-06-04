#!/bin/bash

#passwall 25.7.26   23.05,24.10 编译通过可以
PASSWALL_PACKAGES_FEEDS_COMMITS="950c9a23581ed4cfdcc71a03395213f92ea85f8a"
PASSWALL_LUCI_FEEDS_COMMITS="46e926363e900974994f6c0311768db599574b02"

sed -i '1i src-git passwall_packages https://github.com/Openwrt-Passwall/openwrt-passwall-packages.git^'$PASSWALL_PACKAGES_FEEDS_COMMITS'\nsrc-git passwall_luci https://github.com/Openwrt-Passwall/openwrt-passwall.git^'$PASSWALL_LUCI_FEEDS_COMMITS'' feeds.conf.default
sed -i 's/^.*telephony.git.*$/src-git telephony https:\/\/github.com\/hitoyhuang\/telephony.git;openwrt-23.05/' feeds.conf.default

./scripts/feeds update -a

# ===================== 【唯一正确修复：23.05专用】 =====================
# 把错误的编译指令 改回 23.05 能识别的正确指令
sed -i 's|golang-build|golang-package|g' feeds/passwall_packages/xray-plugin/Makefile
# ======================================================================

./scripts/feeds install -a

wget -O -  https://github.com/raphikWasHere/bluealsa4openwrt/raw/refs/heads/main/bluealsa-alsa/packages/full.tar.gz | tar -zxvf - -C ./

./scripts/feeds update
./scripts/feeds install bluez-alsa
