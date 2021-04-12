#!/bin/bash
clear

### 基础部分 ###
# 使用 O3 级别的优化
sed -i 's/Os/O3/g' include/target.mk
# 更新 Feeds
./scripts/feeds update -a
./scripts/feeds install -a
# 默认开启 Irqbalance
sed -i "s/enabled '0'/enabled '1'/g" feeds/packages/utils/irqbalance/files/irqbalance.config
# 移除 SNAPSHOT 标签
sed -i 's,-SNAPSHOT,,g' include/version.mk
sed -i 's,-SNAPSHOT,,g' package/base-files/image-config.in
# 维多利亚的秘密
rm -rf ./scripts/download.pl
rm -rf ./include/download.mk
wget -P scripts/ https://github.com/immortalwrt/immortalwrt/raw/openwrt-21.02/scripts/download.pl
wget -P include/ https://github.com/immortalwrt/immortalwrt/raw/openwrt-21.02/include/download.mk

#临时补丁
wget -qO - https://github.com/openwrt/openwrt/commit/7fae64.patch | patch -p1

### 必要的 Patches ###
# Patch arm64 型号名称
wget -P target/linux/generic/pending-5.4 https://github.com/immortalwrt/immortalwrt/raw/openwrt-21.02/target/linux/generic/pending-5.4/312-arm64-cpuinfo-Add-model-name-in-proc-cpuinfo-for-64bit-ta.patch
# Patch jsonc
wget -q https://github.com/QiuSimons/R2S-R4S-X86-OpenWrt/raw/master/PATCH/new/package/use_json_object_new_int64.patch
patch -p1 < ./use_json_object_new_int64.patch
# Patch dnsmasq
wget -q https://github.com/QiuSimons/R2S-R4S-X86-OpenWrt/raw/master/PATCH/new/package/dnsmasq-add-filter-aaaa-option.patch
wget -q https://github.com/QiuSimons/R2S-R4S-X86-OpenWrt/raw/master/PATCH/new/package/luci-add-filter-aaaa-option.patch
wget -P package/network/services/dnsmasq/patches/ https://github.com/QiuSimons/R2S-R4S-X86-OpenWrt/raw/master/PATCH/new/package/900-add-filter-aaaa-option.patch
patch -p1 < ./dnsmasq-add-filter-aaaa-option.patch
patch -p1 < ./luci-add-filter-aaaa-option.patch

### Fullcone-NAT 部分 ###
# Patch Kernel 以解决 FullCone 冲突
pushd target/linux/generic/hack-5.4
wget https://github.com/coolsnowwolf/lede/raw/master/target/linux/generic/hack-5.4/952-net-conntrack-events-support-multiple-registrant.patch
popd
# Patch FireWall 以增添 FullCone 功能
mkdir package/network/config/firewall/patches
wget -P package/network/config/firewall/patches/ https://github.com/immortalwrt/immortalwrt/raw/openwrt-21.02/package/network/config/firewall/patches/fullconenat.patch
# Patch LuCI 以增添 FullCone 开关
wget -q https://github.com/QiuSimons/R2S-R4S-X86-OpenWrt/raw/master/PATCH/new/package/luci-app-firewall_add_fullcone.patch
patch -p1 < ./luci-app-firewall_add_fullcone.patch
# FullCone 相关组件
svn co https://github.com/Lienol/openwrt/branches/main/package/network/fullconenat package/network/fullconenat


### 获取额外的基础软件包 ###
# AutoCore
svn co https://github.com/immortalwrt/immortalwrt/branches/master/package/lean/autocore package/lean/autocore
rm -rf ./feeds/packages/utils/coremark
svn co https://github.com/immortalwrt/packages/trunk/utils/coremark feeds/packages/utils/coremark
# AutoMount
svn co https://github.com/immortalwrt/immortalwrt/branches/openwrt-21.02/package/lean/automount package/lean/automount
# 更换 Nodejs 版本
rm -rf ./feeds/packages/lang/node
svn co https://github.com/nxhack/openwrt-node-packages/trunk/node feeds/packages/lang/node
rm -rf ./feeds/packages/lang/node-arduino-firmata
svn co https://github.com/nxhack/openwrt-node-packages/trunk/node-arduino-firmata feeds/packages/lang/node-arduino-firmata
rm -rf ./feeds/packages/lang/node-cylon
svn co https://github.com/nxhack/openwrt-node-packages/trunk/node-cylon feeds/packages/lang/node-cylon
rm -rf ./feeds/packages/lang/node-hid
svn co https://github.com/nxhack/openwrt-node-packages/trunk/node-hid feeds/packages/lang/node-hid
rm -rf ./feeds/packages/lang/node-homebridge
svn co https://github.com/nxhack/openwrt-node-packages/trunk/node-homebridge feeds/packages/lang/node-homebridge
rm -rf ./feeds/packages/lang/node-serialport
svn co https://github.com/nxhack/openwrt-node-packages/trunk/node-serialport feeds/packages/lang/node-serialport
rm -rf ./feeds/packages/lang/node-serialport-bindings
svn co https://github.com/nxhack/openwrt-node-packages/trunk/node-serialport-bindings feeds/packages/lang/node-serialport-bindings
rm -rf ./feeds/packages/lang/node-yarn
svn co https://github.com/nxhack/openwrt-node-packages/trunk/node-yarn feeds/packages/lang/node-yarn
ln -sf ../../../feeds/packages/lang/node-yarn ./package/feeds/packages/node-yarn
# UPX 可执行软件压缩
sed -i '/patchelf pkgconf/i\tools-y += ucl upx' ./tools/Makefile
sed -i '\/autoconf\/compile :=/i\$(curdir)/upx/compile := $(curdir)/ucl/compile' ./tools/Makefile
svn co https://github.com/immortalwrt/immortalwrt/branches/openwrt-21.02/tools/upx tools/upx
svn co https://github.com/immortalwrt/immortalwrt/branches/openwrt-21.02/tools/ucl tools/ucl

### 获取额外的 LuCI 应用、主题和依赖 ###
# Argon 主题
git clone -b master --depth 1 https://github.com/jerrykuku/luci-theme-argon.git package/new/luci-theme-argon
wget -P ./package/new/luci-theme-argon/luasrc/view/themes/argon -N https://github.com/jerrykuku/luci-theme-argon/raw/9fdcfc866ca80d8d094d554c6aedc18682661973/luasrc/view/themes/argon/footer.htm
wget -P ./package/new/luci-theme-argon/luasrc/view/themes/argon -N https://github.com/jerrykuku/luci-theme-argon/raw/9fdcfc866ca80d8d094d554c6aedc18682661973/luasrc/view/themes/argon/header.htm
svn co https://github.com/msylgj/OpenWrt_luci-app/trunk/others/luci-app-argon-config package/new/luci-app-argon-config
# MAC 地址与 IP 绑定
svn co https://github.com/msylgj/OpenWrt_luci-app/trunk/lean/luci-app-arpbind package/lean/luci-app-arpbind
# 定时重启
svn co https://github.com/msylgj/OpenWrt_luci-app/trunk/lean/luci-app-autoreboot package/lean/luci-app-autoreboot
# Boost 通用即插即用
svn co https://github.com/ryohuang/slim-wrt/trunk/slimapps/application/luci-app-boostupnp package/new/luci-app-boostupnp
sed -i 's,api.ipify.org,myip.ipip.net/s,g' ./package/new/luci-app-boostupnp/root/usr/sbin/boostupnp.sh
# CPU 控制相关
svn co https://github.com/msylgj/OpenWrt_luci-app/trunk/lean/luci-app-cpufreq package/lean/luci-app-cpufreq
svn co https://github.com/msylgj/OpenWrt_luci-app/trunk/others/luci-app-cpulimit package/lean/luci-app-cpulimit
svn co https://github.com/immortalwrt/packages/trunk/utils/cpulimit package/lean/cpulimit
# 动态DNS
svn co https://github.com/msylgj/OpenWrt_luci-app/trunk/others/luci-app-tencentddns package/new/luci-app-tencentddns
# FRP 内网穿透
rm -rf ./feeds/luci/applications/luci-app-frps
rm -rf ./feeds/luci/applications/luci-app-frpc
rm -rf ./feeds/packages/net/frp
rm -f ./package/feeds/packages/frp
svn co https://github.com/msylgj/OpenWrt_luci-app/trunk/lean/luci-app-frps package/lean/luci-app-frps
svn co https://github.com/msylgj/OpenWrt_luci-app/trunk/lean/luci-app-frpc package/lean/luci-app-frpc
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/frp package/lean/frp
# IPv6 兼容助手
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/ipv6-helper package/lean/ipv6-helper
# OLED 驱动程序
svn co https://github.com/msylgj/OpenWrt_luci-app/trunk/others/luci-app-oled package/new/luci-app-oled
# OpenClash
svn co https://github.com/vernesong/OpenClash/trunk/luci-app-openclash package/new/luci-app-openclash
# 清理内存
svn co https://github.com/msylgj/OpenWrt_luci-app/trunk/lean/luci-app-ramfree package/lean/luci-app-ramfree
# ServerChan 微信推送
svn co https://github.com/msylgj/OpenWrt_luci-app/trunk/others/luci-app-serverchan package/new/luci-app-serverchan
# 网易云音乐解锁
git clone -b master --depth 1 https://github.com/immortalwrt/luci-app-unblockneteasemusic.git package/new/luci-app-unblockneteasemusic
# KMS 激活助手
svn co https://github.com/msylgj/OpenWrt_luci-app/trunk/lean/luci-app-vlmcsd package/lean/luci-app-vlmcsd
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/vlmcsd package/lean/vlmcsd
# 网络唤醒
svn co https://github.com/msylgj/OpenWrt_luci-app/trunk/others/luci-app-services-wolplus package/new/luci-app-services-wolplus
# 翻译及部分功能优化
svn co https://github.com/QiuSimons/R2S-R4S-X86-OpenWrt/trunk/PATCH/duplicate/addition-trans-zh package/lean/lean-translate

### 最后的收尾工作 ###
# Lets Fuck
mkdir package/base-files/files/usr/bin
cp -f ../SCRIPTS/fuck package/base-files/files/usr/bin/fuck
# 最大连接数
sed -i 's/16384/65535/g' package/kernel/linux/files/sysctl-nf-conntrack.conf
# 定制化配置
sed -i "s/'%D %V %C'/'Built by OPoA($(date +%Y.%m.%d))@%D %V %C'/g" package/base-files/files/etc/openwrt_release
sed -i "/%D/a\ Built by OPoA($(date +%Y.%m.%d))" package/base-files/files/etc/banner
sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/files/bin/config_generate
sed -i "s/openclash.config.enable=0/openclash.config.enable=1/g" package/new/luci-app-openclash/root/etc/uci-defaults/luci-openclash
sed -i 's/+kmod-fast-classifier //g' package/lean/lean-translate/Makefile
sed -i '/exit 0/i\echo "/usr/share/unblockneteasemusic/" >> /etc/sysupgrade.conf && cat /etc/sysupgrade.conf | sort | uniq > /tmp/tmp_sysupgrade_conf && cat /tmp/tmp_sysupgrade_conf > /etc/sysupgrade.conf' package/lean/lean-translate/files/zzz-default-settings
# 生成默认配置及缓存
rm -rf .config

exit 0
