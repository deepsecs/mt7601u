#!/bin/sh

# Stop network interface
ifconfig ra0 down 2>&1 >/dev/null

# wait for a moment
sleep 1

# Uninstall kernel modules
rmmod rtnet7601Uap 2>&1 >/dev/null
rmmod mt7601Uap rtutil7601Uap 2>&1 >/dev/null
depmod

# Uninstall tools
. /usr/local/bin/miwifi_tools.sh

for tool in $TOOLS; do
  rm "/usr/local/bin/$tool" 2>&1 >/dev/null
done

# delete configuration files
rm /etc/Wireless/RT2870AP/RT2870AP.dat 2>&1 >/dev/null

