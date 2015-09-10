#!/bin/sh

ROOT_DIR=`dirname $0`
ROOT_DIR="${ROOT_DIR}/.."

# install kernel modules
cp ${ROOT_DIR}/modules/*.ko /lib/modules/`uname -r`/kernel/drivers/net/wireless/
depmod

# install tools
. ${ROOT_DIR}/bin/miwifi_tools.sh

for tool in $TOOLS; do
  cp -f "${ROOT_DIR}/bin/${tool}" /usr/local/bin/
done

# install configuration files
mkdir -p /etc/Wireless/RT2870AP
cp ${ROOT_DIR}/etc/Wireless/RT2870AP/RT2870AP.dat /etc/Wireless/RT2870AP/
APCONFIG="/etc/Wireless/RT2870AP/RT2870AP.dat"

# setup ssid & wpa/psk password
tmp="$(mktemp)"
whiptail --inputbox "请输入 SSID:" 7 30 --title "DeepSecs MiWiFi" "MiWiFi_DeepSecs" >&1 1>&2 2>${tmp}
ssid="$(cat $tmp)"
sed -i "s|^SSID=.*|SSID=${ssid}|" ${APCONFIG}

# password
whiptail --passwordbox "请输入上网密码:" 7 30 --title "DeepSecs MiWiFi" "deepsecs" >&1 1>&2 2>${tmp}
password="$(cat $tmp)"
sed -i "s|^WPAPSK=.*|WPAPSK=${password}|" ${APCONFIG}

# delete temp file
unlink $tmp
