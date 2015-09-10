#!/bin/sh
ifconfig ra0 down
sleep 1
rmmod rtnet7601Uap
rmmod mt7601Uap
rmmod rtutil7601Uap
