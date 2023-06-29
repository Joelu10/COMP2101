#!/bin/bash

# Get hostname and FQDN
HOSTNAME=$(hostname)
FQDN=$(hostname | sed 's/\(.*\)\..*/\1/')

# Get OS name and version
OS_NAME=$(hostnamectl | grep "Operating System:" | cut -d " " -f5-)
OS_VERSION=$(hostnamectl | grep "Operating System:" | cut -d " " -f6- | cut -d "(" -f1)

# Get default IP address
IP_ADDRESS=$(ip route get 8.8.8.8 | grep -oP 'src \K\S+')

# Get free disk space on root filesystem
DISK_SPACE=$(df -h / | awk 'NR==2 {print $4}')

# Output report
echo
echo "Report for $HOSTNAME"
echo "==============="
echo "FQDN: $FQDN"
echo "Operating System name and version: $OS_NAME $OS_VERSION"
echo "IP Address: $IP_ADDRESS"
echo "Root Filesystem Free Space: $DISK_SPACE"
echo "==============="

