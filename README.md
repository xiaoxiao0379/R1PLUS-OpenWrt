# NanoPi-R2S/R4S-OpenWrt With kernel 5.10
 使用 Github Actions 在线编译 NanoPi-R2S/R4S 固件(kernel 5.10临时测试版)
* 特别说明:**当前5.10内核存在只能跑400Mbps的问题**, 但性能要优于5.4, 待bug修复后会考虑merge入主线

## 当前已知BUG
- 只能跑400Mbps
- 温度墙失效,烤机直升爆炸温度
## 说明
* 基础编译源码Fork自QiuSimons(GC404)大神的纯原生OP版本,个人根据**完全私人**口味进行了一定修改,建议去源库了解更多
    - [QiuSimons/R2S-R4S-X86-OpenWrt](https://github.com/QiuSimons/R2S-R4S-X86-OpenWrt)
* kernel5.10支持Fork自QC502大佬
    - [quintus-lab/OpenWRT-R2S-R4S](https://github.com/quintus-lab/OpenWRT-R2S-R4S)
* ipv4: 192.168.2.1
* username: root
* password: 空
* 原汁原味非杂交! 感谢R2S Club及R4S Club/天灵/GC/QC等诸多大佬的努力!
* 添加Flow Offload+Full Cone
* 支持scp和sftp
* 无usb-wifi支持.wan&lan交换(r2s)
* 原生OP内置升级可用,固件重置可用
* 支持SSD1306驱动的12864(0.96英寸)和12832(0.91英寸)OLED屏幕(r2s)
* OC-1.6(r2s)/2.2-1.8(r4s)

## 插件清单
- app:argon-config
- app:arpbind
- app:autoreboot
- app:cpufreq
- app:cpulimit
- app:frpc(r2s)
- app:frps(r4s)
- app:oled(r2s)
- app:openclash
- app:ramfree
- app:serverchan
- app:tencentddns
- app:unblockneteasemusic
- app:upnp
- app:vlmcsd
- app:wol-plus
- theme:argon
- theme:bootstrap

## 升级方法
* 原生OP内置升级,可选保留配置
* reset按钮可用(使用squashfs格式固件)
* 刷写或升级后遇到任何问题，可以尝试ssh进路由器，输入fuck，回车后等待重启，或可解决(使用squashfs格式固件,需要修改perpare_package去掉最后的注释,来自QiuSimons)

## 特别感谢（排名不分先后）
* [QiuSimons/R2S-R4S-X86-OpenWrt](https://github.com/project-openwrt/R2S-OpenWrt)
* [coolsnowwolf/lede](https://github.com/coolsnowwolf/lede)
* [immortalwrt/immortalwrt](https://github.com/immortalwrt/immortalwrt)
* [quintus-lab/OpenWRT-R2S-R4S](https://github.com/quintus-lab/OpenWRT-R2S-R4S)
