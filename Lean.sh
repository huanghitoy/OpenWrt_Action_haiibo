#!/bin/bash

# 修改默认IP
sed -i 's/192.168.1.1/192.168.12.199/g' package/base-files/files/bin/config_generate


# TTYD 免登录
sed -i 's|/bin/login|/bin/login -f root|g' feeds/packages/utils/ttyd/files/ttyd.config


./scripts/feeds update -a
./scripts/feeds install -a
