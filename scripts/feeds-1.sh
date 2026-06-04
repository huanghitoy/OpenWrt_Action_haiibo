#!/bin/bash

#passwall 25.7.26   23.05,24.10 编译通过可以
PASSWALL_PACKAGES_FEEDS_COMMITS="950c9a23581ed4cfdcc71a03395213f92ea85f8a"
PASSWALL_LUCI_FEEDS_COMMITS="46e926363e900974994f6c0311768db599574b02"

sed -i '1i src-git passwall_packages https://github.com/Openwrt-Passwall/openwrt-passwall-packages.git^'$PASSWALL_PACKAGES_FEEDS_COMMITS'\nsrc-git passwall_luci https://github.com/Openwrt-Passwall/openwrt-passwall.git^'$PASSWALL_LUCI_FEEDS_COMMITS'' feeds.conf.default
sed -i 's/^.*telephony.git.*$/src-git telephony https:\/\/github.com\/hitoyhuang\/telephony.git;openwrt-23.05/' feeds.conf.default

./scripts/feeds update -a

# ====================== 【sed 修复 xray-plugin 100% 成功】 ======================
sed -i 's|PKG_SOURCE_URL:=.*|PKG_SOURCE_URL:=https://github.com/teddysun/xray-plugin/archive/refs/tags/|' feeds/passwall_packages/xray-plugin/Makefile
sed -i 's|PKG_SOURCE:=.*|PKG_SOURCE:=v$(PKG_VERSION).tar.gz|' feeds/passwall_packages/xray-plugin/Makefile
sed -i 's|PKG_HASH:=.*|PKG_HASH:=12940fcb2718733fbf28aeac9314f3c716d61e4d13e6d12921a095c8e182b70c|' feeds/passwall_packages/xray-plugin/Makefile
# ==============================================================================

./scripts/feeds install -a

wget -O -  https://github.com/raphikWasHere/bluealsa4openwrt/raw/refs/heads/main/bluez-alsa/packages/full.tar.gz | tar -zxvf - -C ./

./scripts/feeds update
./scripts/feeds install bluez-alsa
