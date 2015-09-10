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

TITLE="DeepSecs MiWiFi"

rc=0

input_config() {

	item=$1
	prompt=$2
	height=$3
	wight=$4
	init=$5

	tmp="$(mktemp)"
	whiptail --inputbox "${prompt}" ${height} ${wight} --title "${TITLE}" ${init} >&1 1>&2 2>${tmp}

	rc=$?
	if [ ${rc} -eq 0 ]; then
		value="$(cat $tmp)"
		sed -i "s|^${item}=.*|${item}=${value}|" ${APCONFIG}
	fi

	unlink ${tmp}

}

password_config() {

	item=$1
	prompt=$2
	height=$3
	wight=$4
	init=$5

	tmp="$(mktemp)"
	whiptail --passwordbox "${prompt}" ${height} ${wight} --title "${TITLE}" ${init} >&1 1>&2 2>${tmp}

	rc=$?
	if [ ${rc} -eq 0 ]; then
		value="$(cat $tmp)"
		sed -i "s|^${item}=.*|${item}=${value}|" ${APCONFIG}
	fi

	unlink ${tmp}

}

yesno_config() {

	item=$1
	prompt=$2
	height=$3
	wight=$4

	whiptail --yesno "${prompt}" ${height} ${wight} --title "${TITLE}"

	rc=$?
	if [ ${rc} -eq 0 ]; then
		sed -i "s|^${item}=.*|${item}=1|" ${APCONFIG}
	else
		#echo "sed  \"s|^${item}=.*|${item}=0|\" ${APCONFIG}"
		sed -i "s|^${item}=.*|${item}=0|" ${APCONFIG}
	fi

}

menu_config() {

	item=$1
	shift
	prompt=$1
	shift
	height=$1
	shift
	wight=$1
	shift
	listheight=$1
	shift

	tmp="$(mktemp)"
	whiptail --menu "${prompt}" --title "${TITLE}" ${height} ${wight} ${listheight} $@ >&1 1>&2 2>${tmp}

	rc=$?
	if [ ${rc} -eq 0 ]; then
		value="$(cat $tmp)"
		sed -i "s|^${item}=.*|${item}=${value}|" ${APCONFIG}
	fi

	unlink ${tmp}

}

# setup ssid & wpa/psk password
input_config "SSID" "请输入 SSID:" 8 30 "MiWiFi_DeepSecs"

# password
password_config "WPAPSK" "请输入上网密码:" 8 30 "deepsecs"


# hide ssid
yesno_config "HideSSID" "隐藏 SSID ?" 7 30


# auth mode
MODES="WPA2PSK \"WPA2预共享密钥\""
MODES="${MODES} OPEN \"无\""
MODES="${MODES} SHARED \"共享密钥系统\""
MODES="${MODES} WPA \"WPA\""
MODES="${MODES} WPA2 \"WPA2\""
MODES="${MODES} WPAPSK \"WPA预共享密钥\""
MODES="${MODES} WPAPSKWPA2PSK \"WPAPSK/WPA2PSK混合模式\""

menu_config "AuthMode" "认证模式" 14 40 0 ${MODES}


# EncrypType types
MODES="TKIP;AES TKIP/AES混合"
MODES="${MODES} NONE 适用于开放认证"
MODES="${MODES} WEP 适用于开放或共享密钥认证"
MODES="${MODES} TKIP 适用于WPAPSK或WPA2PSK认证"
MODES="${MODES} AES 适用于WPAPSK或WPA2PSK认证"


menu_config EncrypType 加密类型 12 40 0 ${MODES}





