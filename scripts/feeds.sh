#!/bin/bash

#passwall 25.8.5
FEEDS_COMMITS1="1013e7cb1dca5c0835ca277a1f80c2f81549be42"
FEEDS_COMMITS2="74f7fa3e3279b4cef9471cd7bccec310a10dcb74"

#sed -i 's/^.*telephony.git.*$/src-git telephony https:\/\/github.com\/hitoyhuang\/telephony.git;openwrt-23.05/' feeds.conf.default
sed -i '1i src-git passwall_packages https://github.com/xiaorouji/openwrt-passwall-packages.git^'$FEEDS_COMMITS1'\nsrc-git passwall_luci https://github.com/xiaorouji/openwrt-passwall.git^'$FEEDS_COMMITS2'' feeds.conf.default
./scripts/feeds update -a
./scripts/feeds install -a
wget -O -  https://github.com/raphikWasHere/bluealsa4openwrt/raw/refs/heads/main/bluez-alsa/packages/full.tar.gz | tar -zxvf - -C ./
./scripts/feeds update
./scripts/feeds install bluez-alsa   
