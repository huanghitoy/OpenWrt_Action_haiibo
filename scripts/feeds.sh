#!/bin/bash

##passwall 25.5.16  可以
#PASSWALL_PACKAGES_FEEDS_COMMITS="1013e7cb1dca5c0835ca277a1f80c2f81549be42"
#PASSWALL_LUCI_FEEDS_COMMITS="74f7fa3e3279b4cef9471cd7bccec310a10dcb74"

#passwall 25.7.26   可以
PASSWALL_PACKAGES_FEEDS_COMMITS="950c9a23581ed4cfdcc71a03395213f92ea85f8a"
PASSWALL_LUCI_FEEDS_COMMITS="46e926363e900974994f6c0311768db599574b02"

#passwall 25.8.31  编译通不过
#PASSWALL_PACKAGES_FEEDS_COMMITS="f002d6d83f0e2f21b7db251410409eb472fd2d6e"
#PASSWALL_LUCI_FEEDS_COMMITS="d13c49df62631f3fecd9d3146e370b419f5ed049"



sed -i '1i src-git passwall_packages https://github.com/xiaorouji/openwrt-passwall-packages.git^'$PASSWALL_PACKAGES_FEEDS_COMMITS'\nsrc-git passwall_luci https://github.com/xiaorouji/openwrt-passwall.git^'$PASSWALL_LUCI_FEEDS_COMMITS'' feeds.conf.default
#sed -i 's/^.*telephony.git.*$/src-git telephony https:\/\/github.com\/hitoyhuang\/telephony.git;openwrt-23.05/' feeds.conf.default
#sed -i 's/^.*telephony.git.*$/src-git telephony https:\/\/github.com\/koreapyj\/telephony.git^8a0f6d84d7a4340098f5520e8d6fc5485b8fd995/' feeds.conf.default
sed -i 's/^.*telephony.git.*$/src-git telephony https:\/\/github.com\/huanghitoy\/telephony.git^439e120b6861c18e7134f79d544ed09b1f039ffd/' feeds.conf.default
./scripts/feeds update -a
./scripts/feeds install -a

wget -O -  https://github.com/raphikWasHere/bluealsa4openwrt/raw/refs/heads/main/bluez-alsa/packages/full.tar.gz | tar -zxvf - -C ./

./scripts/feeds update
./scripts/feeds install bluez-alsa   
