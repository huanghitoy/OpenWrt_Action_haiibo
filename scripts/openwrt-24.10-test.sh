#!/bin/bash

# 检测代理是否可用
PROXY_HOST="192.168.12.21"
PROXY_PORT="8080"
PROXY_URL="http://${PROXY_HOST}:${PROXY_PORT}"

# 检测端口是否开放
check_proxy() {
    # 使用nc命令检测端口
    if command -v nc &> /dev/null; then
        if nc -z -w 2 $PROXY_HOST $PROXY_PORT; then
            echo "检测到代理服务器可用: $PROXY_URL"
            return 0
        fi
    # 使用telnet检测端口
    elif command -v telnet &> /dev/null; then
        if timeout 2 telnet $PROXY_HOST $PROXY_PORT &> /dev/null; then
            echo "检测到代理服务器可用: $PROXY_URL"
            return 0
        fi
    # 使用bash内置方法检测端口
    else
        timeout 2 bash -c "echo > /dev/tcp/$PROXY_HOST/$PROXY_PORT" &> /dev/null
        if [ $? -eq 0 ]; then
            echo "检测到代理服务器可用: $PROXY_URL"
            return 0
        fi
    fi
    
    echo "代理服务器不可用，将不使用代理"
    return 1
}

# 设置代理（如果可用）
if check_proxy; then
    export http_proxy=$PROXY_URL
    export https_proxy=$PROXY_URL
    export HTTP_PROXY=$PROXY_URL
    export HTTPS_PROXY=$PROXY_URL
    
    # 设置git代理
    git config --global http.proxy $PROXY_URL
    git config --global https.proxy $PROXY_URL
    git config --global http.sslVerify false
else
    # 清除代理设置
    unset http_proxy https_proxy HTTP_PROXY HTTPS_PROXY
    git config --global --unset http.proxy
    git config --global --unset https.proxy
fi


#openwrt-24.10


#sed -i 's/ +libopenssl-legacy//g' feeds/small/shadowsocksr-libev/Makefile
# 取消默认主题luci-theme-bootstrap  
sed -i 's/+luci-light/+luci-theme-argon/g' feeds/luci/collections/luci/Makefile


#修复dockerman 连接不上docker  原因是cgroupfs-mount不能挂载，注释7，8，9行
#sed -i '7{s/^/#/}' feeds/packages/utils/cgroupfs-mount/files/cgroupfs-mount.init
#sed -i '8{s/^/#/}' feeds/packages/utils/cgroupfs-mount/files/cgroupfs-mount.init
#sed -i '9{s/^/#/}' feeds/packages/utils/cgroupfs-mount/files/cgroupfs-mount.init

# 修改ttdy 显示
#sed -i 's/ luci-app-ttyd//g' target/linux/x86/Makefile
#sed -i 's/ luci-app-wireguard//g' target/linux/x86/Makefile

# 修改默认IP
#sed -i 's/192.168.1.1/192.168.12.199/g' package/base-files/files/bin/config_generate

# 修改默认时区
sed -i 's/UTC/CST-8/g' package/base-files/files/bin/config_generate
sed -i "/timezone/a \ \t\tset system.@system[-1].zonename='Asia/Shanghai'" package/base-files/files/bin/config_generate

# 更改默认 Shell 为 zsh
# sed -i 's/\/bin\/ash/\/usr\/bin\/zsh/g' package/base-files/files/etc/passwd

# TTYD 免登录
sed -i 's|/bin/login|/bin/login -f root|g' feeds/packages/utils/ttyd/files/ttyd.config



./scripts/feeds update -a
./scripts/feeds install -a
