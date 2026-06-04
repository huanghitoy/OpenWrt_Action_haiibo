#!/bin/bash
# passwall稳定提交 25.7.26 适配23.05/24.10
PASSWALL_PACKAGES_FEEDS_COMMITS="950c9a23581ed4cfdcc71a03395213f92ea85f8a"
PASSWALL_LUCI_FEEDS_COMMITS="46e926363e900974994f6c0311768db599574b02"

# 写入feeds源
sed -i '1i src-git passwall_packages https://github.com/Openwrt-Passwall/openwrt-passwall-packages.git^'$PASSWALL_PACKAGES_FEEDS_COMMITS'\nsrc-git passwall_luci https://github.com/Openwrt-Passwall/openwrt-passwall.git^'$PASSWALL_LUCI_FEEDS_COMMITS'' feeds.conf.default
sed -i 's/^.*telephony.git.*$/src-git telephony https:\/\/github.com\/hitoyhuang\/telephony.git;openwrt-23.05/' feeds.conf.default

./scripts/feeds update -a

# ==========核心：完整重写xray-plugin Makefile【固定v1.8.24，地址=你能用的链接】==========
# 最终拼接地址：https://github.com/teddysun/xray-plugin/archive/refs/tags/v1.8.24.tar.gz
cat > feeds/passwall_packages/xray-plugin/Makefile <<'MAKEEND'
include $(TOPDIR)/rules.mk

PKG_NAME:=xray-plugin
PKG_VERSION:=1.8.24
PKG_RELEASE:=1
# 关键：带v，拼接URL就是实测有效下载链接
PKG_SOURCE:=v$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://github.com/teddysun/xray-plugin/archive/refs/tags/
# 本地实测tar包sha256，精准校验，杜绝哈希错误
PKG_HASH:=12940fcb2718733fbf28aeac9314f3c716d61e4d13e6d12921a095c8e182b70c

PKG_MAINTAINER:=OpenWrt-Passwall
PKG_LICENSE:=MIT
PKG_LICENSE_FILES:=LICENSE

PKG_BUILD_DEPENDS:=golang/host
PKG_BUILD_PARALLEL:=1
PKG_USE_MIPS16:=0

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/golang/golang-package.mk

define Package/xray-plugin
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=Web Servers/Proxies
  TITLE:=SIP003 xray-plugin for shadowsocks
  URL:=https://github.com/teddysun/xray-plugin
  DEPENDS:=$(GO_ARCH_DEPENDS)
endef

define Package/xray-plugin/description
  Shadowsocks SIP003 plugin based on Xray-core
endef

$(eval $(call GoBinPackage,xray-plugin))
$(eval $(call BuildPackage,xray-plugin))
MAKEEND
# =====================================================================================

./scripts/feeds install -a

# bluez-alsa蓝牙插件
wget -O - https://github.com/raphikWasHere/bluealsa4openwrt/raw/refs/heads/main/bluez-alsa/packages/full.tar.gz | tar -zxvf - -C ./
./scripts/feeds update
./scripts/feeds install bluez-alsa
