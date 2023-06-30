#!/bin/bash

# Function to generate CPU report
cpureport() {
    echo "CPU Report"
    echo "-----------------------"
    
    # CPU manufacturer and model
    local cpu_manufacturer_model=$(lscpu | awk -F ': ' '/Model name/ {print $2}')
    echo "CPU Manufacturer and Model: $cpu_manufacturer_model"
    
    # CPU architecture
    local cpu_architecture=$(lscpu | awk -F ': ' '/Architecture/ {print $2}')
    echo "CPU Architecture: $cpu_architecture"
    
    # CPU core count
    local cpu_cores=$(lscpu | awk -F ': ' '/Core\(s\) per socket/ {print $2}')
    echo "CPU Core Count: $cpu_cores"
    
    # CPU maximum speed
    local cpu_max_speed=$(lscpu | awk -F ': ' '/CPU max MHz/ {print $2}')
    echo "CPU Maximum Speed: $cpu_max_speed MHz"
    
    # Sizes of caches (LI, L2, L3)
    local cache_li=$(lscpu | awk -F ': ' '/L1d cache/ {print $2}')
    local cache_l2=$(lscpu | awk -F ': ' '/L2 cache/ {print $2}')
    local cache_l3=$(lscpu | awk -F ': ' '/L3 cache/ {print $2}')
    echo "Cache Sizes:"
    echo "  L1 Cache: $cache_li"
    echo "  L2 Cache: $cache_l2"
    echo "  L3 Cache: $cache_l3"
    
    echo
}

# Function to generate computer report
computerreport() {
    echo "Computer Report"
    echo "-----------------------"
    
    # Computer manufacturer
    local manufacturer=$(sudo dmidecode -s system-manufacturer)
    echo "Computer Manufacturer: $manufacturer"
    
    # Computer descrip_addresstion or model
    local descrip_addresstion=$(sudo dmidecode -s system-product-name)
    echo "Computer Descrip_addresstion/Model: $descrip_addresstion"
    
    # Computer serial number
    local serial=$(sudo dmidecode -s system-serial-number)
    echo "Computer Serial Number: $serial"
    
    echo
}

# Function to generate OS report
osreport() {
    echo "OS Report"
    echo "-----------------------"
    
    # Linux distro
    local distro=$(lsb_release -ds)
    echo "Linux Distro: $distro"
    
    # Distro version
    local version=$(lsb_release -rs)
    echo "Distro Version: $version"
    
    echo
}

# Function to generate RAM report
ramreport() {
    echo "RAM Report"
    echo "-----------------------"
    
    # Table header
    echo "Manufacturer | Model | Size | Speed | Location"
    echo "----------------------------------------------"
    
    # Iterate over memory components
    sudo dmidecode -t memory | awk -F ': ' '/Manufacturer|Part Number|Size|Speed|Locator/ {
        if ($1 == "Manufacturer") {
            manufacturer = $2
        } else if ($1 == "Part Number") {
            model = $2
        } else if ($1 == "Size") {
            size = $2
        } else if ($1 == "Speed") {
            speed = $2
        } else if ($1 == "Locator") {
            location = $2
            print manufacturer " | " model " | " size " | " speed " | " location
        }
    }'
    
    # Total size of installed RAM
    local total_ram=$(sudo dmidecode -t memory | awk -F ': ' '/Size/ {sum += $2} END {print sum}')
    echo "Total Installed RAM: $total_ram"
    
    echo
}

# Function to generate disk report
diskreport() {
    echo "Disk Report"
    echo "-----------------------"
    
    # Table header
    echo "Manufacturer | Model | Size | Partition | Mount Point | Filesystem Size | Free Space"
    echo "----------------------------------------------------------------------------------"
    
    # Iterate over disk drives
    sudo lshw -class disk | awk -F ': ' '/logical name|vendor|product|size|partition|file system|mount point/ {
        if ($1 == "logical name") {
            printf "\n"
            printf $2 " | "
        } else if ($1 == "vendor") {
            printf $2 " | "
        } else if ($1 == "product") {
            printf $2 " | "
        } else if ($1 == "size") {
            printf $2 " | "
        } else if ($1 == "partition") {
            printf $2 " | "
        } else if ($1 == "file system") {
            printf $2 " | "
        } else if ($1 == "mount point") {
            printf $2 " | "
        }
    }'
    
    echo
}

# Function to generate network report
networkreport() {
    echo "Network Report"
    echo "-----------------------"
    
    # Table header
    echo "Manufacturer | Model | Link State | Speed | ip_address Addresses | Bridge Master | DNS Servers | Search Domains"
    echo "----------------------------------------------------------------------------------------------------"
    
    # Iterate over network interfaces
    sudo lshw -class network | awk -F ': ' '/logical name|vendor|product|link|capacity|configuration|ip_address_address|bridge|servers|search/ {
        if ($1 == "logical name") {
            printf "\n"
            printf $2 " | "
        } else if ($1 == "vendor") {
            printf $2 " | "
        } else if ($1 == "product") {
            printf $2 " | "
        } else if ($1 == "link") {
            printf $2 " | "
        } else if ($1 == "capacity") {
            printf $2 " | "
        } else if ($1 == "configuration") {
            ip_address_address = ""
            bridge = ""
            servers = ""
            search = ""
        } else if ($1 == "ip_address") {
            ip_address = ip_address $2 " "
        } else if ($1 == "bridge") {
            bridge = $2
        } else if ($1 == "servers") {
            servers = $2
        } else if ($1 == "search") {
            search = $2
            print ip_address " | " bridge " | " servers " | " search
        }
    }'
    
    echo
}

# Function to generate video report
function videoreport() {
    # Title
    echo "Video Report"
    
    # Labeled data
    echo "Video Card/Chipset Manufacturer: $(lshw -C display | awk '/description: VGA/ {print $2}')"
    echo "Video Card/Chipset Description or Model: $(lshw -C display | awk '/product: / {print $2}')"
}

# Function to display error messages
errormessage() {
    local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    local error_message=$1
    
    # Save error message to the logfile
    echo "[$timestamp] $error_message" >> /var/log/systeminfo.log
    
    # Display error message to the user on stderr
    echo "Error: $error_message" >&2
}

# Invoke the functions if the file is sourced
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    cpureport
    computerreport
    osreport
    ramreport
    diskreport
    networkreport
    videoreport
fi

