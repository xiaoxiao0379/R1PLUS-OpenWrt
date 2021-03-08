#!/bin/bash
clear

#R4S_TL
rm -rf ./target/linux/rockchip
svn co https://github.com/immortalwrt/immortalwrt/branches/master/target/linux/rockchip target/linux/rockchip
rm -rf ./package/boot/uboot-rockchip
svn co https://github.com/immortalwrt/immortalwrt/branches/master/package/boot/uboot-rockchip package/boot/uboot-rockchip

#overclock CPU-temperature
wget -P target/linux/rockchip/patches-5.10/ https://github.com/QiuSimons/R2S-R4S-X86-OpenWrt/raw/master/PATCH/new/main/213-RK3399-set-critical-CPU-temperature-for-thermal-throttling.patch

#使用特定的优化
sed -i 's,-mcpu=generic,-march=armv8-a+crypto+crc -mcpu=cortex-a72.cortex-a53+crypto+crc -mtune=cortex-a72.cortex-a53,g' include/target.mk
wget -P package/libs/mbedtls/patches/ https://github.com/QiuSimons/R2S-R4S-X86-OpenWrt/raw/master/PATCH/new/package/100-Implements-AES-and-GCM-with-ARMv8-Crypto-Extensions.patch

#Experimental
sed -i '/CRYPTO_DEV_ROCKCHIP/d' ./target/linux/rockchip/armv8/config-5.10
sed -i '/HW_RANDOM_ROCKCHIP/d' ./target/linux/rockchip/armv8/config-5.10
echo '
CONFIG_CRYPTO_DEV_ROCKCHIP=y
CONFIG_HW_RANDOM_ROCKCHIP=y
' >> ./target/linux/rockchip/armv8/config-5.10

#IRQ
sed -i '/set_interface_core 20 "eth1"/a\set_interface_core 8 "ff3c0000" "ff3c0000.i2c"' target/linux/rockchip/armv8/base-files/etc/hotplug.d/net/40-net-smp-affinity
sed -i '/set_interface_core 20 "eth1"/a\ethtool -C eth0 rx-usecs 1000 rx-frames 25 tx-usecs 100 tx-frames 25' target/linux/rockchip/armv8/base-files/etc/hotplug.d/net/40-net-smp-affinity

#翻译及部分功能优化
svn co https://github.com/QiuSimons/R2S-R4S-X86-OpenWrt/trunk/PATCH/duplicate/addition-trans-zh package/lean/lean-translate
sed -i 's/+kmod-fast-classifier //g' package/lean/lean-translate/Makefile
sed -i '/chinadnslist/d' package/lean/lean-translate/files/zzz-default-settings
sed -i '/MosChinaDNS/d' package/lean/lean-translate/files/zzz-default-settings

<<'COMMENT'
#Vermagic
latest_version="$(curl -s https://github.com/openwrt/openwrt/releases |grep -Eo "v[0-9\.]+\-*r*c*[0-9]*.tar.gz" |sed -n '/21/p' |sed -n 1p |sed 's/v//g' |sed 's/.tar.gz//g')"
wget https://downloads.openwrt.org/releases/${latest_version}/targets/rockchip/armv8/packages/Packages.gz
zgrep -m 1 "Depends: kernel (=.*)$" Packages.gz | sed -e 's/.*-\(.*\))/\1/' > .vermagic
sed -i -e 's/^\(.\).*vermagic$/\1cp $(TOPDIR)\/.vermagic $(LINUX_DIR)\/.vermagic/' include/kernel-defaults.mk
COMMENT

#Vermagic 2102 SNAPSHOT ONLY
wget https://downloads.openwrt.org/releases/21.02-SNAPSHOT/targets/rockchip/armv8/packages/Packages.gz
zgrep -m 1 "Depends: kernel (=.*)$" Packages.gz | sed -e 's/.*-\(.*\))/\1/' > .vermagic
sed -i -e 's/^\(.\).*vermagic$/\1cp $(TOPDIR)\/.vermagic $(LINUX_DIR)\/.vermagic/' include/kernel-defaults.mk

#预配置一些插件
wget -P files/etc/config/ https://github.com/QiuSimons/R2S-R4S-X86-OpenWrt/raw/master/PATCH/R4S/files/etc/config/cpufreq
wget -P files/etc/config/ https://github.com/QiuSimons/R2S-R4S-X86-OpenWrt/raw/master/PATCH/R4S/files/etc/config/cpulimit

exit 0