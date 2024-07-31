#!/bin/bash

#sed -i 's/ +libopenssl-legacy//g' feeds/small/shadowsocksr-libev/Makefile

#淇dockerman 杩炴帴涓嶄笂docker  鍘熷洜鏄痗groupfs-mount涓嶈兘鎸傝浇锛屾敞閲?锛?锛?琛?sed -i '7{s/^/#/}' feeds/packages/utils/cgroupfs-mount/files/cgroupfs-mount.init
sed -i '8{s/^/#/}' feeds/packages/utils/cgroupfs-mount/files/cgroupfs-mount.init
sed -i '9{s/^/#/}' feeds/packages/utils/cgroupfs-mount/files/cgroupfs-mount.init

# 淇敼ttdy 鏄剧ず
#sed -i 's/ luci-app-ttyd//g' target/linux/x86/Makefile
#sed -i 's/ luci-app-wireguard//g' target/linux/x86/Makefile

# 淇敼榛樿IP
sed -i 's/192.168.1.1/192.168.12.199/g' package/base-files/files/bin/config_generate

# 鏇存敼榛樿 Shell 涓?zsh
# sed -i 's/\/bin\/ash/\/usr\/bin\/zsh/g' package/base-files/files/etc/passwd

# TTYD 鍏嶇櫥褰?sed -i 's|/bin/login|/bin/login -f root|g' feeds/packages/utils/ttyd/files/ttyd.config

# 绉婚櫎瑕佹浛鎹㈢殑鍖?涓巏enzo 鐩稿悓鐨勫寘 
#rm -rf feeds/packages/net/{mosdns,adguardhome,pdnsd-alt,smartdns,v2ray-geodata,msd_lite}
#rm -rf feeds/luci/applications/{luci-app-serverchan,luci-app-aliyundrive-webdav,luci-app-argon-config,luci-app-design-config,luci-app-dockerman,luci-app-easymesh,luci-app-eqos,luci-app-smartdns,luci-app-mosdns,luci-app-netdata}
#rm -rf feeds/luci/themes/{luci-theme-argon,luci-theme-design}
rm -rf feeds/packages/lang/golang
git clone https://github.com/kenzok8/golang feeds/packages/lang/golang

# Git绋€鐤忓厠闅嗭紝鍙厠闅嗘寚瀹氱洰褰曞埌鏈湴
rm -rf package/huang
mkdir package/huang
function git_sparse_clone() {
  branch="$1" repourl="$2" && shift 2
  git clone --depth=1 -b $branch --single-branch --filter=blob:none --sparse $repourl
  repodir=$(echo $repourl | awk -F '/' '{print $(NF)}')
  cd $repodir && git sparse-checkout set $@
  mv -f $@ ../package/huang
  cd .. && rm -rf $repodir
}
# 绉绘lean 鐨勫寘鍒板畼鏂?git_sparse_clone master https://github.com/coolsnowwolf/lede  package/qca package/qat package/wwan
git_sparse_clone master https://github.com/coolsnowwolf/luci applications/luci-app-vlmcsd applications/luci-app-verysync applications/luci-app-rclone
git_sparse_clone master https://github.com/coolsnowwolf/packages net/vlmcsd net/verysync
#绉绘5G-Modem-Support
git_sparse_clone main https://github.com/Siriling/5G-Modem-Support luci-app-usbmodem

# 绉绘kenzo 鐨勫寘鍒板畼鏂?adguardhome openclash 
rm -rf feeds/packages/net/adguardhome
#rm -rf feeds/luci/applications/luci-app-dockerman
git_sparse_clone master https://github.com/kenzok8/openwrt-packages luci-app-adguardhome adguardhome luci-app-openclash

# 绉绘immortalwrt 鐨勫寘鍒板畼鏂?
git_sparse_clone openwrt-23.05 https://github.com/immortalwrt/luci applications/luci-app-homeproxy applications/luci-app-accesscontrol  applications/luci-app-diskman
#git_sparse_clone openwrt-23.05 https://github.com/immortalwrt/packages net/softethervpn5
git_sparse_clone master https://github.com/immortalwrt-collections/openwrt-cdnspeedtest cdnspeedtest

# 绉绘Lienol 鐨勫寘鍒板畼鏂?luci-app-fileassistant luci-app-ssr-mudb-server luci-app-timecontrol luci-app-openvpn-server luci-app-openvpn-client
#rm -rf feeds/kenzo/luci-app-fileassistant
#rm -rf package/luci-app-fileassistant
git_sparse_clone main https://github.com/huanghitoy/openwrt-package luci-app-fileassistant luci-app-ssr-mudb-server luci-app-timecontrol luci-app-openvpn-server luci-app-openvpn-client
git_sparse_clone other https://github.com/Lienol/openwrt-package luci-app-tcpdump

#qbittorrent
rm -rf package/luci-app-qbittorrent
git clone --depth=1 https://github.com/sbwml/luci-app-qbittorrent package/luci-app-qbittorrent

# 娣诲姞棰濆鎻掍欢 鍘熸潵鍖呭拰kenzo鍖呮病鏈夌殑 4涓?#rm -rf package/{luci-app-poweroff,OpenAppFilter,luci-app-netdata,luci-app-wolplus}
#git clone --depth=1 https://github.com/esirplayground/luci-app-poweroff package/luci-app-poweroff
#git clone --depth=1 https://github.com/destan19/OpenAppFilter package/OpenAppFilter
#git clone --depth=1 https://github.com/Jason6111/luci-app-netdata package/luci-app-netdata
rm -rf package/luci-app-wolplus
git clone --depth=1 https://github.com/animegasan/luci-app-wolplus package/luci-app-wolplus

# dockerman
rm -rf feeds/luci/applications/luci-app-dockerman
rm -rf package/luci-app-dockerman
git_sparse_clone master https://github.com/lisaac/luci-app-dockerman applications/luci-app-dockerman

# adguardhome
#rm -rf feeds/packages/net/adguardhome
#rm -rf package/luci-app-adguardhome
#git clone --depth=1 https://github.com/kongfl888/luci-app-adguardhome package/luci-app-adguardhome

# msd_lite
rm -rf feeds/packages/net/msd_lite
rm -rf package/{luci-app-msd_lite,msd_lite}
git clone --depth=1 https://github.com/ximiTech/luci-app-msd_lite package/luci-app-msd_lite
git clone --depth=1 https://github.com/ximiTech/msd_lite package/msd_lite

# 3ginfo_lite
rm -rf package/luci-app-3ginfo-lite
git clone --depth=1 https://github.com/4IceG/luci-app-3ginfo-lite package/luci-app-3ginfo-lite

# Mproxy
rm -rf package/luci-app-mproxy
git clone --depth=1 https://github.com/huanghitoy/luci-app-mproxy package/luci-app-mproxy
chmod 755 package/luci-app-mproxy/luci-app-mproxy/root/etc/init.d/mproxy

# Themes
#git clone --depth=1 -b 18.06 https://github.com/kiddin9/luci-theme-edge package/luci-theme-edge
rm -rf package/{luci-theme-argon,luci-app-argon-config}
git clone --depth=1 -b master https://github.com/jerrykuku/luci-theme-argon package/luci-theme-argon
git clone --depth=1 -b master https://github.com/jerrykuku/luci-app-argon-config package/luci-app-argon-config
#git clone --depth=1 https://github.com/xiaoqingfengATGH/luci-theme-infinityfreedom package/luci-theme-infinityfreedom
#git_sparse_clone main https://github.com/haiibo/packages luci-theme-atmaterial luci-theme-opentomcat luci-theme-netgear

# MosDNS
#rm -rf feeds/packages/net/mosdns
#rm -rf feeds/luci/luci-app-mosdns
#rm -rf feeds/packages/utils/v2dat
#rm -rf feeds/small/{luci-app-mosdns,mosdns,v2dat}
rm -rf package/luci-app-mosdns
git clone --depth=1 https://github.com/sbwml/luci-app-mosdns package/luci-app-mosdns

# SmartDNS
#rm -rf openwrt/feeds/luci/applications/luci-app-smartdns
#rm -rf openwrt/feeds/packages/net/smartdns
#rm -rf package/{luci-app-smartdns,smartdns}
#git clone --depth=1 -b master https://github.com/pymumu/luci-app-smartdns package/luci-app-smartdns
#git clone --depth=1 https://github.com/pymumu/smartdns package/smartdns

# 鍦ㄧ嚎鐢ㄦ埛
#rm -rf package/luci-app-onliner
#git_sparse_clone main https://github.com/haiibo/packages luci-app-onliner
#sed -i '$i uci set nlbwmon.@nlbwmon[0].refresh_interval=2s' package/lean/default-settings/files/zzz-default-settings
#sed -i '$i uci commit nlbwmon' package/lean/default-settings/files/zzz-default-settings
#chmod 755 package/luci-app-onliner/root/usr/share/onliner/setnlbw.sh

# 绉戝涓婄綉鎻掍欢
#git clone --depth=1 -b main https://github.com/fw876/helloworld package/luci-app-ssr-plus
rm -rf package/{luci-app-passwall,openwrt-passwall}
rm -fr feeds/packages/net/{trojan-go,v2ray-core,v2ray-geodata,xray-core}
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall-packages package/openwrt-passwall
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall package/luci-app-passwall
#git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall2 package/luci-app-passwall2
#git_sparse_clone master https://github.com/vernesong/OpenClash luci-app-openclash

# 鏇存敼 Argon 涓婚鑳屾櫙
#cp -f $GITHUB_WORKSPACE/images/bg1.jpg package/luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg

# 鏅舵櫒瀹濈洅
#git_sparse_clone main https://github.com/ophub/luci-app-amlogic luci-app-amlogic
#sed -i "s|firmware_repo.*|firmware_repo 'https://github.com/haiibo/OpenWrt'|g" package/luci-app-amlogic/root/etc/config/amlogic
# sed -i "s|kernel_path.*|kernel_path 'https://github.com/ophub/kernel'|g" package/luci-app-amlogic/root/etc/config/amlogic
#sed -i "s|ARMv8|ARMv8_PLUS|g" package/luci-app-amlogic/root/etc/config/amlogic



# Alist
#git clone --depth=1 https://github.com/sbwml/luci-app-alist package/luci-app-alist

# DDNS.to
#git_sparse_clone main https://github.com/linkease/nas-packages-luci luci/luci-app-ddnsto
#git_sparse_clone master https://github.com/linkease/nas-packages network/services/ddnsto

# iStore
#git_sparse_clone main https://github.com/linkease/istore-ui app-store-ui
#git_sparse_clone main https://github.com/linkease/istore luci

#git_sparse_clone openwrt-18.06 https://github.com/immortalwrt/luci applications/luci-app-eqos
#git_sparse_clone master https://github.com/syb999/openwrt-19.07.1 package/network/services/msd_lite
#git clone --depth=1 https://github.com/ilxp/luci-app-ikoolproxy package/luci-app-ikoolproxy
#git clone --depth=1 https://github.com/kongfl888/luci-app-adguardhome package/luci-app-adguardhome
#git clone --depth=1 -b openwrt-18.06 https://github.com/tty228/luci-app-wechatpush package/luci-app-serverchan

# x86 鍨嬪彿鍙樉绀?CPU 鍨嬪彿
#sed -i 's/${g}.*/${a}${b}${c}${d}${e}${f}${hydrid}/g' package/lean/autocore/files/x86/autocore

# 淇敼鏈湴鏃堕棿鏍煎紡
#sed -i 's/os.date()/os.date("%a %Y-%m-%d %H:%M:%S")/g' package/lean/autocore/files/*/index.htm

# 淇敼鐗堟湰涓虹紪璇戞棩鏈?#date_version=$(date +"%y.%m.%d")
#orig_version=$(cat "package/lean/default-settings/files/zzz-default-settings" | grep DISTRIB_REVISION= | awk -F "'" '{print $2}')
#sed -i "s/${orig_version}/R${date_version} by Huanghitoy/g" package/lean/default-settings/files/zzz-default-settings

# 淇 hostapd 鎶ラ敊
#cp -f $GITHUB_WORKSPACE/scripts/011-fix-mbo-modules-build.patch package/network/services/hostapd/patches/011-fix-mbo-modules-build.patch

# 淇 armv8 璁惧 xfsprogs 鎶ラ敊
#sed -i 's/TARGET_CFLAGS.*/TARGET_CFLAGS += -DHAVE_MAP_SYNC -D_LARGEFILE64_SOURCE/g' feeds/packages/utils/xfsprogs/Makefile

# 淇敼 Makefile
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/..\/..\/luci.mk/$(TOPDIR)\/feeds\/luci\/luci.mk/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/..\/..\/lang\/golang\/golang-package.mk/$(TOPDIR)\/feeds\/packages\/lang\/golang\/golang-package.mk/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/PKG_SOURCE_URL:=@GHREPO/PKG_SOURCE_URL:=https:\/\/github.com/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/PKG_SOURCE_URL:=@GHCODELOAD/PKG_SOURCE_URL:=https:\/\/codeload.github.com/g' {}

# 鍙栨秷涓婚榛樿璁剧疆
#find package/luci-theme-*/* -type f -name '*luci-theme-*' -print -exec sed -i '/set luci.main.mediaurlbase/d' {} \;

# 璋冩暣 V2ray鏈嶅姟鍣?鍒?VPN 鑿滃崟
# sed -i 's/services/vpn/g' feeds/luci/applications/luci-app-v2ray-server/luasrc/controller/*.lua
# sed -i 's/services/vpn/g' feeds/luci/applications/luci-app-v2ray-server/luasrc/model/cbi/v2ray_server/*.lua
# sed -i 's/services/vpn/g' feeds/luci/applications/luci-app-v2ray-server/luasrc/view/v2ray_server/*.htm

./scripts/feeds update -a
./scripts/feeds install -a
