 #!/bin/bash
fqdn=$(hostname --fqdn)
host_info=$(hostnamectl)
ip_addrs=$(hostname -I | awk '$1 !~ /127./ {print $1}')
root_fs=$(df -h /)
echo "FQDN: $fqdn"
echo -e "Host Information:\n$host_info"
echo "IP Addresses:$ip_addrs"
echo -e "Root Filesystem Status:\n$root_fs"

