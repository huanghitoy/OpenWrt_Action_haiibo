#!/bin/bash

##passwall 25.5.16  可以
#PASSWALL_PACKAGES_FEEDS_COMMITS="1013e7cb1dca5c0835ca277a1f80c2f81549be42"
#PASSWALL_LUCI_FEEDS_COMMITS="74f7fa3e3279b4cef9471cd7bccec310a10dcb74"

#passwall-25.7.15  xray-core-25.7.26  23.05,24.10 编译通过可以
#PASSWALL_PACKAGES_FEEDS_COMMITS="950c9a23581ed4cfdcc71a03395213f92ea85f8a"
#PASSWALL_LUCI_FEEDS_COMMITS="46e926363e900974994f6c0311768db599574b02"

#passwall-25.12.1  xray-core-25.12.8        23.05 编译通过可以
PASSWALL_PACKAGES_FEEDS_COMMITS="b37a3f1ce3512b61143c4fa49335a074d197bcf5"
PASSWALL_LUCI_FEEDS_COMMITS="d73f09db0462a65cbfe989b2b8d41fc0bac2b008"

#passwall 25.12.31  
#PASSWALL_PACKAGES_FEEDS_COMMITS="46495fc982f7861e8913b8667bfdcd523b7ec2fc"
#PASSWALL_LUCI_FEEDS_COMMITS="d743aeeeeced58359cd066ed5679985c5c82c97c"





sed -i '1i src-git passwall_packages https://github.com/Openwrt-Passwall/openwrt-passwall-packages.git^'$PASSWALL_PACKAGES_FEEDS_COMMITS'\nsrc-git passwall_luci https://github.com/Openwrt-Passwall/openwrt-passwall.git^'$PASSWALL_LUCI_FEEDS_COMMITS'' feeds.conf.default
sed -i 's/^.*telephony.git.*$/src-git telephony https:\/\/github.com\/hitoyhuang\/telephony.git;openwrt-23.05/' feeds.conf.default

./scripts/feeds update -a

# ✅ 修复 xray-plugin-1.8.24 在passwall-25.7.15版本中哈希值不匹配，在最新版中已修复
sed -i 's|PKG_HASH:=.*|PKG_HASH:=1150968f8791df884ce0ab5b2dbc870496088c90b5ffcc7f21497075aab7b1b5|g' feeds/passwall_packages/xray-plugin/Makefile

./scripts/feeds install -a

wget -O -  https://github.com/raphikwasHere/bluealsa4openwrt/raw/refs/heads/main/bluealsa4openwrt/packages/full.tar.gz | tar -zxvf - -C ./

./scripts/feeds update
./scripts/feeds install bluez-alsa
