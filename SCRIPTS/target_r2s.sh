#!/bin/bash
clear

#使用专属优化
sed -i 's,-mcpu=generic,-march=armv8-a+crypto+crc -mcpu=cortex-a53+crypto+crc -mtune=cortex-a53,g' include/target.mk
#IRQ
sed -i '/set_interface_core 4 "eth1"/a\set_interface_core 8 "ff160000" "ff160000.i2c"' target/linux/rockchip/armv8/base-files/etc/hotplug.d/net/40-net-smp-affinity
sed -i '/set_interface_core 4 "eth1"/a\set_interface_core 1 "ff150000" "ff150000.i2c"' target/linux/rockchip/armv8/base-files/etc/hotplug.d/net/40-net-smp-affinity
#disabed rk3328 ethernet tcp/udp offloading tx/rx
sed -i '/;;/i\ethtool -K eth0 rx off tx off && logger -t disable-offloading "disabed rk3328 ethernet tcp/udp offloading tx/rx"' target/linux/rockchip/armv8/base-files/etc/hotplug.d/net/40-net-smp-affinity
#SWAP LAN WAN（满足千兆场景，可选
sed -i 's,"eth1" "eth0","eth0" "eth1",g' target/linux/rockchip/armv8/base-files/etc/board.d/02_network
sed -i "s,'eth1' 'eth0','eth0' 'eth1',g" target/linux/rockchip/armv8/base-files/etc/board.d/02_network
#翻译及部分功能优化
svn co https://github.com/QiuSimons/R2S-R4S-X86-OpenWrt/trunk/PATCH/duplicate/addition-trans-zh-r2s package/lean/lean-translate
sed -i 's/+kmod-fast-classifier //g' package/lean/lean-translate/Makefile
sed -i '/chinadnslist/d' package/lean/lean-translate/files/zzz-default-settings
sed -i '/MosChinaDNS/d' package/lean/lean-translate/files/zzz-default-settings

#预配置一些插件
wget -P files/etc/config/ https://github.com/QiuSimons/R2S-R4S-X86-OpenWrt/raw/master/PATCH/R2S/files/etc/config/cpulimit

exit 0