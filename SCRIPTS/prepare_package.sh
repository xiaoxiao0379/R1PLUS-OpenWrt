#!/bin/bash
clear

#使用O2级别的优化
sed -i 's/Os/O2/g' include/target.mk
#更新feed
./scripts/feeds update -a
./scripts/feeds install -a -f
#irqbalance
sed -i 's/0/1/g' feeds/packages/utils/irqbalance/files/irqbalance.config
#remove annoying snapshot tag
sed -i 's,-SNAPSHOT,,g' include/version.mk
sed -i 's,-SNAPSHOT,,g' package/base-files/image-config.in

##必要的patch
# target-5.10
wget -q https://github.com/quintus-lab/OpenWRT-R2S-R4S/raw/master/patches/0006-target-5.10-rockchip-support.patch
patch -p1 < ./0006-target-5.10-rockchip-support.patch
# rngd
wget -q https://github.com/quintus-lab/OpenWRT-R2S-R4S/raw/master/patches/0002-rockchip-rngd.patch
patch -p1 < ./0002-rockchip-rngd.patch
# patch cpuinfo display modelname
wget -q https://github.com/quintus-lab/OpenWRT-R2S-R4S/raw/master/patches/3829.patch
patch -p1 < ./3829.patch
#patch jsonc
wget -q https://github.com/QiuSimons/R2S-R4S-X86-OpenWrt/raw/master/PATCH/new/package/use_json_object_new_int64.patch
patch -p1 < ./use_json_object_new_int64.patch
#patch dnsmasq
wget -q https://github.com/QiuSimons/R2S-R4S-X86-OpenWrt/raw/master/PATCH/new/package/dnsmasq-add-filter-aaaa-option.patch
wget -q https://github.com/QiuSimons/R2S-R4S-X86-OpenWrt/raw/master/PATCH/new/package/luci-add-filter-aaaa-option.patch
wget -P package/network/services/dnsmasq/patches/ https://github.com/QiuSimons/R2S-R4S-X86-OpenWrt/raw/master/PATCH/new/package/900-add-filter-aaaa-option.patch
patch -p1 < ./dnsmasq-add-filter-aaaa-option.patch
patch -p1 < ./luci-add-filter-aaaa-option.patch
#Fullcone patch
wget -q https://github.com/quintus-lab/OpenWRT-R2S-R4S/raw/master/patches/1002-add-fullconenat-support.patch
wget -q https://github.com/quintus-lab/OpenWRT-R2S-R4S/raw/master/patches/1003-luci-app-firewall_add_fullcone.patch
wget -q https://github.com/quintus-lab/OpenWRT-R2S-R4S/raw/master/patches/1004-netconntrack.patch
patch -p1 < ./1002-add-fullconenat-support.patch
patch -p1 < ./1003-luci-app-firewall_add_fullcone.patch
patch -p1 < ./1004-netconntrack.patch
#FullCone 相关组件
svn co https://github.com/Lienol/openwrt/branches/main/package/network/fullconenat package/network/fullconenat

##获取额外package
#（不用注释这里的任何东西，这不会对提升action的执行速度起到多大的帮助
#（不需要的包直接修改seed就好
#upx
sed -i '/patchelf pkgconf/i\tools-y += ucl upx' ./tools/Makefile
sed -i '\/autoconf\/compile :=/i\$(curdir)/upx/compile := $(curdir)/ucl/compile' ./tools/Makefile
svn co https://github.com/immortalwrt/immortalwrt/branches/master/tools/upx tools/upx
svn co https://github.com/immortalwrt/immortalwrt/branches/master/tools/ucl tools/ucl
#update curl
svn co https://github.com/openwrt/openwrt/branches/openwrt-19.07/package/network/utils/curl package/network/utils/curl
#R8168
# svn co https://github.com/immortalwrt/immortalwrt/branches/master/package/ctcgfw/r8168 package/new/r8168
# patch -p1 < ../SCRIPTS/led.patch
# sed -i '/r8169/d' ./target/linux/rockchip/image/armv8.mk
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
#AutoCore
svn co https://github.com/immortalwrt/immortalwrt/branches/master/package/lean/autocore package/lean/autocore
rm -rf ./feeds/packages/utils/coremark
svn co https://github.com/immortalwrt/packages/trunk/utils/coremark feeds/packages/utils/coremark
sed -i 's,default 2,default 8,g' feeds/packages/utils/coremark/Makefile
sed -i 's,default n,default y,g' feeds/packages/utils/coremark/Makefile
#oled
svn co https://github.com/msylgj/OpenWrt_luci-app/trunk/others/luci-app-oled package/new/luci-app-oled
#网易云解锁
svn co https://github.com/msylgj/OpenWrt_luci-app/trunk/others/luci-app-unblockneteasemusic package/new/UnblockNeteaseMusic
#定时重启
svn co https://github.com/msylgj/OpenWrt_luci-app/trunk/lean/luci-app-autoreboot package/lean/luci-app-autoreboot
#argon主题
git clone -b master --depth 1 https://github.com/jerrykuku/luci-theme-argon.git package/new/luci-theme-argon
svn co https://github.com/msylgj/OpenWrt_luci-app/trunk/others/luci-app-argon-config package/new/luci-app-argon-config
#luci-app-cpulimit
svn co https://github.com/msylgj/OpenWrt_luci-app/trunk/others/luci-app-cpulimit package/lean/luci-app-cpulimit
svn co https://github.com/immortalwrt/immortalwrt/branches/master/package/ntlf9t/cpulimit package/lean/cpulimit
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