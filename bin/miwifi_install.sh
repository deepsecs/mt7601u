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

