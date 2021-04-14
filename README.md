<h1 align="center">Orange-r1plus-OpenWrt</h1>
<h1 align="center">请勿用于商业用途，请遵守互联网法规</h1>

## 说明
* Fork自QiuSimons(GC404)大神的纯原生OP版本,源库了解更多
    - [QiuSimons/R2S-R4S-X86-OpenWrt](https://github.com/QiuSimons/R2S-R4S-X86-OpenWrt)
* ipv4: 192.168.2.1
* username: root
* password: 空
* 添加Flow Offload+Full Cone Nat
* 支持scp和sftp
* 无usb-wifi支持(r2s/r4s).wan&lan交换(r2s)
* 支持SSD1306驱动的12864(0.96英寸)和12832(0.91英寸)OLED屏幕(r2s)
* OC-1.6(r2s)/2.2-1.8(r4s)

## 插件清单
- app:argon-config
- app:arpbind
- app:autoreboot
- app:cpufreq
- app:cpulimit
- app:frpc(r2s)
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
* 刷写或升级后遇到任何问题，可以尝试ssh进路由器，输入fuck，回车后等待重启，或可解决(使用squashfs格式固件,来自QiuSimons)

## 各路大神随机排序

|          [CTCGFW](https://github.com/immortalwrt)           |           [coolsnowwolf](https://github.com/coolsnowwolf)            |              [QiuSimons](https://github.com/QiuSimons)               |              [Quintus](https://github.com/quintus-lab)               |
| :----------------------------------------------------------: | :----------------------------------------------------------: | :----------------------------------------------------------: | :----------------------------------------------------------: |
| <img width="120" src="https://avatars.githubusercontent.com/u/53193414"/> | <img width="120" src="https://avatars.githubusercontent.com/u/31687149" /> | <img width="120" src="https://avatars.githubusercontent.com/u/45143996" /> | <img width="120" src="https://avatars.githubusercontent.com/u/31897806" /> |
