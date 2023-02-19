 #!/bin/bash
# Get fully-qualified domain name
fqdn=$(hostname --fqdn)
# Get host information
host_info=$(hostnamectl)
# Get IP addresses not on the 127 network
ip_addrs=$(hostname -I | awk '$1 !~ /127./ {print $1}')
# Get root filesystem status in human-friendly nature
root_fs=$(df -h /)
# Display output
echo "FQDN: $fqdn"
echo -e "Host Information:\n$host_info"
echo "IP Addresses:$ip_addrs"
echo -e "Root Filesystem Status:\n$root_fs"

