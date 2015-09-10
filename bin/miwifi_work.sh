#!/bin/sh
#remove the driver before
ifconfig ra0 down
rmmod mt7601Usta
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
echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward
iptables -t filter -F
iptables -t nat -F
iptables -t nat -A POSTROUTING -o eth1 -j MASQUERADE
echo "Notice: 需要开启 DHCP 服务，否则客户端需要设置成静态获取 IP 地址"
echo "网关地址: $ip"
