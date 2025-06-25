#
# Copyright (C) 2017 - 2018 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=asterisk-chan-quectel-5g

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/hitoyhuang/asterisk-chan-quectel-5g.git
PKG_SOURCE_VERSION:=881cae5c93afb2268c169f7d17d268ea869c0b3e
PKG_SOURCE_DATE=2024-04-25
PKG_RELEASE:=0.1

PKG_FIXUP:=autoreconf

PKG_LICENSE:=GPL-2.0
PKG_LICENSE_FILES:=COPYRIGHT.txt LICENSE.txt
PKG_MAINTAINER:=koreapyj <koreapyj@dcmys.kr>

define Build/Prepare
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(BUILD_VARIANT)/$(PKG_NAME)-$(PKG_VERSION)
$(CP) ./src/* $(PKG_BUILD_DIR)/
endef



MODULES_DIR:=/usr/lib/asterisk/modules

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/nls.mk

define Package/$(PKG_NAME)
  SUBMENU:=Telephony
  SECTION:=net
  CATEGORY:=Network
  URL:=https://github.com/koreapyj/asterisk-chan-quectel-5g
  DEPENDS:=asterisk $(ICONV_DEPENDS) +kmod-usb-acm +kmod-usb-serial +kmod-usb-serial-option +libusb-1.0 +alsa-lib
  TITLE:=Quectel 5G modules support
endef

define Package/$(PKG_NAME)/description
 Asterisk channel driver for Quectel 5G modules
endef


CONFIGURE_ARGS+= \
	--with-asterisk=$(STAGING_DIR)/usr/include \
		--with-astversion=18 \
		--with-iconv=$(ICONV_PREFIX)/include

TARGET_CFLAGS+= \
	-I$(CHAN_quectel_AST_HEADERS)

MAKE_FLAGS+=LD="$(TARGET_CC)"

CONFIGURE_VARS += \
	DESTDIR="$(MODULES_DIR)" \
	ac_cv_type_size_t=yes \
	ac_cv_type_ssize_t=yes


define Package/$(PKG_NAME)/conffiles
	/etc/asterisk/quectel5g.conf
endef


define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/etc/asterisk
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/etc/quectel5g.conf $(1)/etc/asterisk
	$(INSTALL_DIR) $(1)$(MODULES_DIR)
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/chan_quectel.so $(1)$(MODULES_DIR)
endef


$(eval $(call BuildPackage,$(PKG_NAME)))
