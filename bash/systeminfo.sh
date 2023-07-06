#!/bin/bash


#SYSTEM REPORT SCRIPT GENEREATED BY JOEL SAJU 

# Source the function library file
source reportfunctions.sh

# Function to display help message
display_help() {
    echo "Usage: systeminfo.sh [OPTIONS]"
    echo "Options:"
    echo "  -h        Display help for the script"
    echo "  -v        Run the script verbosely (show errors to the user)"
    echo "  -system   Generate a system report (computerreport, osreport, cpureport, ramreport, and videoreport)"
    echo "  -disk     Generate a disk report"
    echo "  -network  Generate a network report"
    exit 0
}

# Function to check root permission
check_root_permission() {
    if [[ $(id -u) -ne 0 ]]; then
        errormessage "Root permission required. Please run the script as root."
        exit 1
    fi
}

# Function to handle errors
handle_errors() {
    local error_message=$1
    if [[ "$verbose" == true ]]; then
        errormessage "$error_message"
    fi
}

# Function to generate the full system report
generate_system_report() {
    computerreport
    osreport
    cpureport
    ramreport
    videoreport
    diskreport
    networkreport

}

# Default behavior (full system report) when no options are provided
if [[ $# -eq 0 ]]; then
    generate_system_report
    exit 0
fi

# Variables to track options
verbose=false
generate_system=false
generate_disk=false
generate_network=false

# Parse command line options
for option in "$@"; do
    case $option in
        -h)
            display_help
            ;;
        -v)
            verbose=true
            ;;
        -system)
            generate_system=true
            ;;
        -disk)
            generate_disk=true
            ;;
        -network)
            generate_network=true
            ;;
        *)
            errormessage "Invalid option: $option"
            display_help
            ;;
    esac
done

# Check root permission
check_root_permission

# Generate reports based on options
if [[ "$generate_system" == true ]]; then
    generate_system_report
fi

if [[ "$generate_disk" == true ]]; then
    diskreport
fi

if [[ "$generate_network" == true ]]; then
    networkreport
fi

