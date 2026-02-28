#!/bin/bash

# check root
if [ "$EUID" -ne 0 ]; then
  echo "please run as root"
  exit 1
fi

echo "WELCOME TO gamecuber6's SYSMAINTENANCE: SERVER EDITION (todo: put cool ascii art here)"

echo "step 1: apt updating and cleaning"
apt-get update -y
apt-get upgrade -y
apt-get autoremove -y
apt-get clean -y
apt-get autoclean -y

echo "step 2: temp file cleaning"
rm -rf /tmp/*
rm -rf /var/tmp/*

echo "step 3: removing old logs"
journalctl --vacuum-time=3d 
logrotate -f /etc/logrotate.conf

echo "WE ARE DONE. REBOOTING IN 1 MINUTE OR SOMETHING. 60, 59, 58 okay i cant"
shutdown -r +1 "weekly sysmaintenance"
