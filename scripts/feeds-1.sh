#!/bin/bash

##passwall 25.5.16  可以
#PASSWALL_PACKAGES_FEEDS_COMMITS="1013e7cb1dca5c0835ca277a1f80c2f81549be42"
#PASSWALL_LUCI_FEEDS_COMMITS="74f7fa3e3279b4cef9471cd7bccec310a10dcb74"

#passwall 25.7.26   23.05,24.10 编译通过可以
PASSWALL_PACKAGES_FEEDS_COMMITS="950c9a23581ed4cfdcc71a03395213f92ea85f8a"
PASSWALL_LUCI_FEEDS_COMMITS="46e926363e900974994f6c0311768db599574b02"

#passwall 25.8.31  编译通不过
#PASSWALL_PACKAGES_FEEDS_COMMITS="f002d6d83f0e2f21b7db251410409eb472fd2d6e"
#PASSWALL_LUCI_FEEDS_COMMITS="d13c49df62631f3fecd9d3146e370b419f5ed049"

#passwall 25.12.31
#PASSWALL_PACKAGES_FEEDS_COMMITS="46495fc982f7861e8913b8667bfdcd523b7ec2fc"
#PASSWALL_LUCI_FEEDS_COMMITS="d743aeeeeced58359cd066ed5679985c5c82c97c"


sed -i '1i src-git passwall_packages https://github.com/Openwrt-Passwall/openwrt-passwall-packages.git^'$PASSWALL_PACKAGES_FEEDS_COMMITS'\nsrc-git passwall_luci https://github.com/Openwrt-Passwall/openwrt-passwall.git^'$PASSWALL_LUCI_FEEDS_COMMITS'' feeds.conf.default
sed -i 's/^.*telephony.git.*$/src-git telephony https:\/\/github.com\/hitoyhuang\/telephony.git;openwrt-23.05/' feeds.conf.default

./scripts/feeds update -a

# ====================== 【关键修复：位置放对了】======================
# 修复 xray-plugin 下载失败 + 哈希错误
sed -i 's|PKG_SOURCE_URL:=.*codeload.github.com.*|PKG_SOURCE_URL:=https://github.com/teddysun/xray-plugin/archive/refs/tags/|' feeds/passwall_packages/xray-plugin/Makefile
sed -i 's|PKG_HASH:=.*|PKG_HASH:=1150968f8791df884ce0ab5b2dbc870496088c90b5ffcc7f21497075aab7b1b5|' feeds/passwall_packages/xray-plugin/Makefile
# ====================================================================

./scripts/feeds install -a

wget -O -  https://github.com/raphikWasHere/bluealsa4openwrt/raw/refs/heads/main/bluez-alsa/packages/full.tar.gz | tar -zxvf - -C ./

./scripts/feeds update
./scripts/feeds install bluez-alsa
