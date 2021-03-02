<h1 align="center">NanoPi-R2S/R4S-OpenWrt With kernel 5.10</h1>
<p align="center">
<img src="https://forthebadge.com/images/badges/built-with-love.svg">
<p>
<p align="center">
<img alt="GitHub All Releases" src="https://img.shields.io/github/downloads/msylgj/R2S-R4S-OpenWrt/total?style=for-the-badge">
<img alt="GitHub" src="https://img.shields.io/github/license/msylgj/R2S-R4S-OpenWrt?style=for-the-badge">
<p>
<p align="center">
<img src="https://github.com/msylgj/R2S-R4S-OpenWrt/actions/workflows/R2S-Openwrt-With-Kernel-5.10.yml/badge.svg">
<img src="https://github.com/msylgj/R2S-R4S-OpenWrt/actions/workflows/R4S-Openwrt-With-Kernel-5.10.yml/badge.svg">
<p>

<h1 align="center">请勿用于商业用途!!!</h1>

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
* 刷写或升级后遇到任何问题，可以尝试ssh进路由器，输入fuck，回车后等待重启，或可解决(使用squashfs格式固件,需要修改prepare_package去掉最后的注释,来自QiuSimons)

## 特别感谢（排名不分先后）

|          [CTCGFW](https://github.com/immortalwrt)           |           [coolsnowwolf](https://github.com/coolsnowwolf)            |              [QiuSimons](https://github.com/QiuSimons)               |              [Quintus](https://github.com/quintus-lab)               |
| :----------------------------------------------------------: | :----------------------------------------------------------: | :----------------------------------------------------------: | :----------------------------------------------------------: |
| <img width="120" src="https://avatars.githubusercontent.com/u/53193414"/> | <img width="120" src="https://avatars.githubusercontent.com/u/31687149" /> | <img width="120" src="https://avatars.githubusercontent.com/u/45143996" /> | <img width="120" src="https://avatars.githubusercontent.com/u/31897806" /> |
