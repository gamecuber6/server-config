#!/bin/bash

# check root
if [ "$EUID" -ne 0 ]; then
  echo "please run as root! also make sure the root user can use sudo without entering a password."
  exit 1
fi

echo "SYSMAINTENANCE: SERVER EDITION ver.1.01"

echo "step 1: apt updating and cleaning"
sudo -n DEBIAN_FRONTEND=noninteractive apt-get update -y
sudo -n DEBIAN_FRONTEND=noninteractive apt-get upgrade -y
sudo -n DEBIAN_FRONTEND=noninteractive apt-get autoremove -y
sudo -n DEBIAN_FRONTEND=noninteractive apt-get clean -y
sudo -n DEBIAN_FRONTEND=noninteractive apt-get autoclean -y

echo "step 2: quick and easy temp file cleaning"
rm -rf /tmp/*
rm -rf /var/tmp/*

echo "step 3: removing old logs"
journalctl --vacuum-time=3d 
sudo -n logrotate -f /etc/logrotate.conf

echo "DONE. REBOOTING IN 1 MINUTE"
sleep 1m
sudo -n systemctl reboot
