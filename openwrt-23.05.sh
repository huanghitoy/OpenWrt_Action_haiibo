#!/bin/bash
#openwrt-23.05
#sed -i 's/ +libopenssl-legacy//g' feeds/small/shadowsocksr-libev/Makefile
# 取消默认主题luci-theme-bootstrap  
sed -i 's/+luci-light/+luci-theme-argon/g' feeds/luci/collections/luci/Makefile


#修复dockerman 连接不上docker  原因是cgroupfs-mount不能挂载，注释7，8，9行
sed -i '7{s/^/#/}' feeds/packages/utils/cgroupfs-mount/files/cgroupfs-mount.init
sed -i '8{s/^/#/}' feeds/packages/utils/cgroupfs-mount/files/cgroupfs-mount.init
sed -i '9{s/^/#/}' feeds/packages/utils/cgroupfs-mount/files/cgroupfs-mount.init

# 修改ttdy 显示
#sed -i 's/ luci-app-ttyd//g' target/linux/x86/Makefile
#sed -i 's/ luci-app-wireguard//g' target/linux/x86/Makefile

# 修改默认IP
sed -i 's/192.168.1.1/192.168.12.199/g' package/base-files/files/bin/config_generate

# 修改默认时区
sed -i 's/UTC/CST-8/g' package/base-files/files/bin/config_generate
sed -i "/timezone/a \ \t\tset system.@system[-1].zonename='Asia/Shanghai'" package/base-files/files/bin/config_generate

# 更改默认 Shell 为 zsh
# sed -i 's/\/bin\/ash/\/usr\/bin\/zsh/g' package/base-files/files/etc/passwd

# TTYD 免登录
sed -i 's|/bin/login|/bin/login -f root|g' feeds/packages/utils/ttyd/files/ttyd.config

# 移除要替换的包 与kenzo 相同的包 
#rm -rf feeds/packages/net/{mosdns,adguardhome,pdnsd-alt,smartdns,v2ray-geodata,msd_lite}
#rm -rf feeds/luci/applications/{luci-app-serverchan,luci-app-aliyundrive-webdav,luci-app-argon-config,luci-app-design-config,luci-app-dockerman,luci-app-easymesh,luci-app-eqos,luci-app-smartdns,luci-app-mosdns,luci-app-netdata}
#rm -rf feeds/luci/themes/{luci-theme-argon,luci-theme-design}
rm -rf feeds/packages/lang/golang
git clone https://github.com/kenzok8/golang feeds/packages/lang/golang

# Git稀疏克隆，只克隆指定目录到本地
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
# 移植lean 的包到官方
git_sparse_clone master https://github.com/coolsnowwolf/lede package/qat package/wwan
git_sparse_clone master https://github.com/coolsnowwolf/luci applications/luci-app-vlmcsd applications/luci-app-verysync applications/luci-app-rclone applications/luci-app-nfs
git_sparse_clone master https://github.com/coolsnowwolf/packages net/vlmcsd net/verysync
#移植5G-Modem-Support
#git_sparse_clone main https://github.com/Siriling/5G-Modem-Support luci-app-usbmodem

# 移植kenzo 的包到官方 adguardhome openclash 
rm -rf feeds/packages/net/adguardhome
#rm -rf feeds/luci/applications/luci-app-dockerman
git_sparse_clone master https://github.com/kenzok8/openwrt-packages luci-app-adguardhome adguardhome 

# 移植immortalwrt 的包到官方 
git_sparse_clone openwrt-23.05 https://github.com/immortalwrt/luci applications/luci-app-homeproxy applications/luci-app-diskman applications/luci-app-timewol applications/luci-app-arpbind
#git_sparse_clone openwrt-23.05 https://github.com/immortalwrt/packages net/softethervpn5
git_sparse_clone master https://github.com/immortalwrt-collections/openwrt-cdnspeedtest cdnspeedtest

# 移植Lienol 的包到官方 luci-app-fileassistant luci-app-ssr-mudb-server luci-app-timecontrol luci-app-openvpn-server luci-app-openvpn-client
#rm -rf feeds/kenzo/luci-app-fileassistant
#rm -rf package/luci-app-fileassistant
git_sparse_clone main https://github.com/huanghitoy/openwrt-package luci-app-fileassistant luci-app-ssr-mudb-server luci-app-timecontrol luci-app-openvpn-server luci-app-openvpn-client
git_sparse_clone other https://github.com/Lienol/openwrt-package luci-app-tcpdump

#qbittorrent
rm -rf package/luci-app-qbittorrent
git clone --depth=1 https://github.com/sbwml/luci-app-qbittorrent package/luci-app-qbittorrent

# 添加额外插件 原来包和kenzo包没有的 4个
#rm -rf package/{luci-app-poweroff,OpenAppFilter,luci-app-netdata,luci-app-wolplus}
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

#########################4IceG###########################
# 3ginfo_lite
#rm -rf package/luci-app-3ginfo-lite
#git clone --depth=1 https://github.com/4IceG/luci-app-3ginfo-lite package/luci-app-3ginfo-lite

# luci-app-modemband
rm -rf package/luci-app-modemband
git clone https://github.com/4IceG/luci-app-modemband.git package/luci-app-modemband

# luci-app-lite-watchdog
rm -rf package/luci-app-lite-watchdog
git clone https://github.com/4IceG/luci-app-lite-watchdog.git package/luci-app-lite-watchdog

# sms-tool
rm -rf package/{luci-app-sms-tool,luci-app-sms-tool-js}
rm -rf feeds/packages/utils/sms-tool
git clone https://github.com/4IceG/luci-app-sms-tool.git package/luci-app-sms-tool
git clone https://github.com/4IceG/luci-app-sms-tool-js package/luci-app-sms-tool-js
#########################4IceG###########################
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
rm -rf package/luci-app-mosdns
git clone https://github.com/sbwml/luci-app-mosdns -b v5 package/luci-app-mosdns

# SmartDNS
#rm -rf openwrt/feeds/luci/applications/luci-app-smartdns
#rm -rf openwrt/feeds/packages/net/smartdns
#rm -rf package/{luci-app-smartdns,smartdns}
#git clone --depth=1 -b master https://github.com/pymumu/luci-app-smartdns package/luci-app-smartdns
#git clone --depth=1 https://github.com/pymumu/smartdns package/smartdns

# 在线用户
#rm -rf package/luci-app-onliner
#git_sparse_clone main https://github.com/haiibo/packages luci-app-onliner
#sed -i '$i uci set nlbwmon.@nlbwmon[0].refresh_interval=2s' package/lean/default-settings/files/zzz-default-settings
#sed -i '$i uci commit nlbwmon' package/lean/default-settings/files/zzz-default-settings
#chmod 755 package/luci-app-onliner/root/usr/share/onliner/setnlbw.sh

# 科学上网插件
#git clone --depth=1 -b main https://github.com/fw876/helloworld package/luci-app-ssr-plus
rm -rf feeds/packages/net/{trojan-go,v2ray-core,v2ray-geodata,xray-core,microsocks,sing-box}
rm -rf package/{luci-app-passwall,openwrt-passwall}
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall-packages package/openwrt-passwall
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall package/luci-app-passwall
#sed -i 's/ +kmod-nft-nat6 \\//g' package/openwrt-passwall/sing-box/Makefile
#rm -rf package/openwrt-passwall/{trojan-go,v2ray-core,v2ray-geodata,xray-core,microsocks,sing-box}
#git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall2 package/luci-app-passwall2
#git_sparse_clone master https://github.com/vernesong/OpenClash luci-app-openclash

# 更改 Argon 主题背景
#cp -f $GITHUB_WORKSPACE/images/bg1.jpg package/luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg

# 晶晨宝盒
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

# x86 型号只显示 CPU 型号
#sed -i 's/${g}.*/${a}${b}${c}${d}${e}${f}${hydrid}/g' package/lean/autocore/files/x86/autocore

# 修改本地时间格式
#sed -i 's/os.date()/os.date("%a %Y-%m-%d %H:%M:%S")/g' package/lean/autocore/files/*/index.htm

# 修改版本为编译日期
#date_version=$(date +"%y.%m.%d")
#orig_version=$(cat "package/lean/default-settings/files/zzz-default-settings" | grep DISTRIB_REVISION= | awk -F "'" '{print $2}')
#sed -i "s/${orig_version}/R${date_version} by Huanghitoy/g" package/lean/default-settings/files/zzz-default-settings

# 修复 hostapd 报错
#cp -f $GITHUB_WORKSPACE/scripts/011-fix-mbo-modules-build.patch package/network/services/hostapd/patches/011-fix-mbo-modules-build.patch

#调整 WNDR4300 固件大小至128M
patch -p0 < $GITHUB_WORKSPACE/scripts/openwrt-23.05_ath79_nand_121m.patch

# 修复 bluetooth csr
cp -f $GITHUB_WORKSPACE/scripts/950-csr-clean.patch target/linux/x86/patches-5.15/950-csr-clean.patch
cp -f $GITHUB_WORKSPACE/scripts/950-csr-clean.patch target/linux/ipq806x/patches-5.15/950-csr-clean.patch

# 修复 armv8 设备 xfsprogs 报错
#sed -i 's/TARGET_CFLAGS.*/TARGET_CFLAGS += -DHAVE_MAP_SYNC -D_LARGEFILE64_SOURCE/g' feeds/packages/utils/xfsprogs/Makefile

# 修改 Makefile
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/..\/..\/luci.mk/$(TOPDIR)\/feeds\/luci\/luci.mk/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/..\/..\/lang\/golang\/golang-package.mk/$(TOPDIR)\/feeds\/packages\/lang\/golang\/golang-package.mk/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/PKG_SOURCE_URL:=@GHREPO/PKG_SOURCE_URL:=https:\/\/github.com/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/PKG_SOURCE_URL:=@GHCODELOAD/PKG_SOURCE_URL:=https:\/\/codeload.github.com/g' {}

# 取消主题默认设置
#find package/luci-theme-*/* -type f -name '*luci-theme-*' -print -exec sed -i '/set luci.main.mediaurlbase/d' {} \;

# 调整 V2ray服务器 到 VPN 菜单
# sed -i 's/services/vpn/g' feeds/luci/applications/luci-app-v2ray-server/luasrc/controller/*.lua
# sed -i 's/services/vpn/g' feeds/luci/applications/luci-app-v2ray-server/luasrc/model/cbi/v2ray_server/*.lua
# sed -i 's/services/vpn/g' feeds/luci/applications/luci-app-v2ray-server/luasrc/view/v2ray_server/*.htm

./scripts/feeds update -a
./scripts/feeds install -a
./scripts/feeds install -a
make clean
rm -rf bin
