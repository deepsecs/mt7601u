#!/bin/sh
#remove the driver before
ifconfig ra0 down 2>/dev/null
rmmod mt7601Usta 2>/dev/null

TITLE="DeepSecs MiWiFi"
wan=eth0

interfaces=`ifconfig | grep 'Link encap' | grep -v lo | awk '{print $1" "$5}')`
tmp="$(mktemp)"
whiptail --menu "互联网接口" --title "${TITLE}" 12 40 0 ${interfaces} >&1 1>&2 2>${tmp}
rc=$?
if [ ${rc} -eq 0 ]; then
	wan="$(cat $tmp)"
fi
unlink ${tmp}

#add new ap driver
modprobe rtutil7601Uap
modprobe mt7601Uap
modprobe rtnet7601Uap
#set ip
ip="192.168.199.1"
ifconfig ra0 up
ifconfig ra0 $ip
#dhcp the network
dhcpd ra0
#make if forward work from eth0
echo 1 | tee /proc/sys/net/ipv4/ip_forward
iptables -t filter -F
iptables -t nat -F
iptables -t nat -A POSTROUTING -o ${wan} -j MASQUERADE
echo "Notice: 需要开启 DHCP 服务，否则客户端需要设置成静态获取 IP 地址"
echo "网关地址: $ip"
