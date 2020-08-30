#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#

# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# Add a feed source
#sed -i '$a src-git lienol https://github.com/Lienol/openwrt-package' feeds.conf.default
#!/bin/bash
#=================================================
# Description: DIY script
# Lisence: MIT
# Author: P3TERX
# Blog: https://p3terx.com
#=================================================
# Modify default IP
#sed -i 's/192.168.1.1/192.168.50.5/g' package/base-files/files/bin/config_generate
#修复核心及添加温度显示
sed -i 's|pcdata(boardinfo.system or "?")|luci.sys.exec("uname -m") or "?"|g' feeds/luci/modules/luci-mod-admin-full/luasrc/view/admin_status/index.htm
sed -i 's/or "1"%>/or "1"%> ( <%=luci.sys.exec("expr `cat \/sys\/class\/thermal\/thermal_zone0\/temp` \/ 1000") or "?"%> \&#8451; ) /g' feeds/luci/modules/luci-mod-admin-full/luasrc/view/admin_status/index.htm
#替换banner
rm -rf package/base-files/files/etc/banner
cp -f ../banner package/base-files/files/etc/
#添加wifi
mkdir -p files/etc/config
cp -f ../wireless files/etc/config/

#修改机器名称
sed -i 's/OpenWrt/RaspberryPi/g' package/base-files/files/bin/config_generate

# Change timezone
sed -i "s/'UTC'/'CST-8'\n        set system.@system[-1].zonename='Asia\/Shanghai'/g" package/base-files/files/bin/config_generate
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

./scripts/feeds update -a
./scripts/feeds install -a
