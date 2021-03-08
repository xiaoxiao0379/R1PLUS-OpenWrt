#!/bin/bash
clear

#使用O2级别的优化
sed -i 's/Os/O2/g' include/target.mk
#更新feed
./scripts/feeds update -a
./scripts/feeds install -a -f
#irqbalance
sed -i 's/0/1/g' feeds/packages/utils/irqbalance/files/irqbalance.config

##必要的patch
#patch jsonc
wget -q https://github.com/QiuSimons/R2S-R4S-X86-OpenWrt/raw/master/PATCH/new/package/use_json_object_new_int64.patch
patch -p1 < ./use_json_object_new_int64.patch
# Patch LuCI 以增添fullcone开关
wget -q https://github.com/QiuSimons/R2S-R4S-X86-OpenWrt/raw/master/PATCH/new/package/luci-app-firewall_add_fullcone.patch
patch -p1 < ./luci-app-firewall_add_fullcone.patch

##获取额外package
#（不用注释这里的任何东西，这不会对提升action的执行速度起到多大的帮助
#（不需要的包直接修改seed就好
#upx
sed -i '/patchelf pkgconf/i\tools-y += ucl upx' ./tools/Makefile
sed -i '\/autoconf\/compile :=/i\$(curdir)/upx/compile := $(curdir)/ucl/compile' ./tools/Makefile
#更换Node版本
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
#luci-app-freq
svn co https://github.com/msylgj/OpenWrt_luci-app/trunk/lean/luci-app-cpufreq package/lean/luci-app-cpufreq
#arpbind
svn co https://github.com/msylgj/OpenWrt_luci-app/trunk/lean/luci-app-arpbind package/lean/luci-app-arpbind
#oled
svn co https://github.com/msylgj/OpenWrt_luci-app/trunk/others/luci-app-oled package/new/luci-app-oled
#网易云解锁
git clone -b master --depth 1 https://github.com/immortalwrt/luci-app-unblockneteasemusic.git package/new/luci-app-unblockneteasemusic
#定时重启
svn co https://github.com/msylgj/OpenWrt_luci-app/trunk/lean/luci-app-autoreboot package/lean/luci-app-autoreboot
#argon主题
git clone -b master --depth 1 https://github.com/jerrykuku/luci-theme-argon.git package/new/luci-theme-argon
svn co https://github.com/msylgj/OpenWrt_luci-app/trunk/others/luci-app-argon-config package/new/luci-app-argon-config
#luci-app-cpulimit
svn co https://github.com/msylgj/OpenWrt_luci-app/trunk/others/luci-app-cpulimit package/lean/luci-app-cpulimit
#清理内存
svn co https://github.com/msylgj/OpenWrt_luci-app/trunk/lean/luci-app-ramfree package/lean/luci-app-ramfree
#OpenClash
svn co https://github.com/vernesong/OpenClash/trunk/luci-app-openclash package/new/luci-app-openclash
#SeverChan
svn co https://github.com/msylgj/OpenWrt_luci-app/trunk/others/luci-app-serverchan package/new/luci-app-serverchan
#UPNP（回滚以解决某些沙雕设备的沙雕问题
rm -rf ./feeds/packages/net/miniupnpd
svn co https://github.com/coolsnowwolf/packages/trunk/net/miniupnpd feeds/packages/net/miniupnpd
#KMS
svn co https://github.com/msylgj/OpenWrt_luci-app/trunk/lean/luci-app-vlmcsd package/lean/luci-app-vlmcsd
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/vlmcsd package/lean/vlmcsd
#frp
rm -rf ./feeds/luci/applications/luci-app-frps
rm -rf ./feeds/luci/applications/luci-app-frpc
rm -rf ./feeds/packages/net/frp
rm -f ./package/feeds/packages/frp
svn co https://github.com/msylgj/OpenWrt_luci-app/trunk/lean/luci-app-frps package/lean/luci-app-frps
svn co https://github.com/msylgj/OpenWrt_luci-app/trunk/lean/luci-app-frpc package/lean/luci-app-frpc
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/frp package/lean/frp
#腾讯DDNS
svn co https://github.com/msylgj/OpenWrt_luci-app/trunk/others/luci-app-tencentddns package/new/luci-app-tencentddns
#WOL
svn co https://github.com/msylgj/OpenWrt_luci-app/trunk/others/luci-app-services-wolplus package/new/luci-app-services-wolplus

##最后的收尾工作
#Lets Fuck
#mkdir package/base-files/files/usr/bin
#cp -f ../SCRIPTS/fuck package/base-files/files/usr/bin/fuck
#最大连接
sed -i 's/16384/65536/g' package/kernel/linux/files/sysctl-nf-conntrack.conf
#custom config
sed -i "s/'%D %V %C'/'Built by OPoA($(date +%Y.%m.%d))@%D %V %C'/g" package/base-files/files/etc/openwrt_release
sed -i "/%D/a\ Built by OPoA($(date +%Y.%m.%d))" package/base-files/files/etc/banner
sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/files/bin/config_generate
#修改启动等待（可能无效）
sed -i 's/default "5"/default "0"/g' config/Config-images.in
#生成默认配置及缓存
rm -rf .config
exit 0