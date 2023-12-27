#!/bin/bash

# Check permission
permission=$(whoami)
if [ "$permission" != "root" ]; then
    echo "This script run with root"
    exit
fi

# Check OS of machine
OS=$(uname -s)

if [ "$OS" = "Linux" ]; then
    if [ -f /etc/redhat-release ]; then
        if grep -q "CentOS" /etc/redhat-release; then
            echo "This is a CentOS system."
        else
            echo "This is a Linux system, but not CentOS."
            exit
        fi
    else
        echo "This is a Linux system, but cannot determine distribution."
        exit
    fi
else
    echo "This script is intended for Linux systems only."
    exit
fi

# Update hostname
echo -n "Change your hostname, choose your option (y/n):"
read -r option_hostname
if [ "$option_hostname" == "y" ]; then
    echo -n "Your hostname want to change: "
    read -r your_hostname
    hostnamectl set-hostname "$your_hostname"
    hostnamectl
fi

# Update timezone
echo "Change timezone to +7"
timedatectl set-timezone Asia/Ho_Chi_Minh

# Check connect internet
ping -c 1 google.com > /dev/null 2>&1

if [ $? -eq 0 ]
then
    echo "Internet connection is up"
else
    echo "Internet connection is down"
    exit
fi

# Update
yum -y update
yum install -y epel-release

# Install Tools
echo "
0. Install all
1. telnet
2. nano
3. rsyslog
4. ssh
5. net-tools
6. wget
7. traceroute
8. netcat
9. curl
10. snmp
"
echo -n "What is tool you want to install?"
read -r option_install
case "${option_install}" in
    "1")
        echo "Install Telnet."
        yum install -y telnet
    ;;
    "2")
        echo "Install Nano."
        yum install -y nano
    ;;
    "3")
        echo "Install Rsyslog."
        yum install rsyslog -y
    ;;
    "4")
        echo "Install SSH."
        yum install openssh -y
    ;;
    "5")
        echo "Install Net-tools."
        yum install net-tools -y
    ;;
    "6")
        echo "Install Wget."
        yum install -y wget
    ;;
    "7")
        echo "Install Traceroute."
        yum install traceroute -y
    ;;
    "8")
        echo "Install Netcat."
        yum install -y nc
    ;;
    "9")
        echo "Install Curl."
        yum install curl -y
    ;;
    "10")
        echo "Install SNMP."
        yum -y install net-snmp net-snmp-utils
    ;;
    *)
        echo "Default install all."
        yum install -y telnet
        yum install -y nano
        yum install rsyslog -y
        yum install openssh -y
        yum install net-tools -y
        yum install -y wget
        yum install traceroute -y
        yum install -y nc
        yum install curl -y
        yum -y install net-snmp net-snmp-utils
    ;;
esac

# Reboot device
echo "Reboot device"
reboot
