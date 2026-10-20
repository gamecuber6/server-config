#!/bin/bash

# check root
if [ "$EUID" -ne 0 ]; then
  echo "please run as root! also make sure the root user can use sudo without entering a password."
  exit 1
fi

echo "SYSMAINTENANCE: SERVER EDITION ver.1-proper"

echo "step 1: apt updating and cleaning"
apt-get update -y
apt-get upgrade -y
apt-get autoremove -y
apt-get clean -y
apt-get autoclean -y

echo "step 2: quick and easy temp file cleaning"
rm -rf /tmp/*
rm -rf /var/tmp/*

echo "step 3: removing old logs"
journalctl --vacuum-time=3d 
sudo -n logrotate -f /etc/logrotate.conf

echo "DONE. REBOOTING IN 1 MINUTE"
sleep 1m
sudo -n systemctl reboot
