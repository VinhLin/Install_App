#!/bin/bash

# Check permission
permission=$(whoami)
if [ "$permission" != "root" ]; then
    echo "This script run with root"
    exit
fi

# Check OS of machine
OS=$(uname -s)
repo_name=$(lsb_release -d | awk -F ":\t" '{print $2}')

if [ "$OS" = "Linux" ]; then
    if [[ $repo_name == *"Ubuntu"* ]]; then
        echo "This is a Ubuntu system."
    else
        echo "This is a Linux system, but not Ubuntu."
        exit
    fi
else
    echo "This script is intended for Linux systems only."
    exit
fi

# Update timezone
echo "Change timezone to +7"
timedatectl set-timezone Asia/Ho_Chi_Minh

# Check connect internet
ping -c 4 google.com > /dev/null 2>&1

if [ $? -eq 0 ]
then
    echo "Internet connection is up"
else
    echo "Internet connection is down"
    exit
fi

# Update
apt update -y
apt-get upgrade -y

# Install Tools
echo "
0. Install all
1. cmake
2. arp-scan
3. speedtest-cli
4. snmp
5. net-tools
6. wget unzip
7. traceroute
8. netcat
"
echo -n "What is tool you want to install?"
read -r option_install
case "${option_install}" in
    "1")
        echo "Install cmake."
        sudo snap install cmake --classic
    ;;
    "2")
        echo "Install arp-scan."
        sudo apt-get install arp-scan -y
    ;;
    "3")
        echo "Install speedtest-cli."
        sudo apt install speedtest-cli -y
    ;;
    "4")
        echo "Install snmp."
        sudo apt install snmpd snmp libsnmp-dev -y
    ;;
    "5")
        echo "Install Net-tools."
        sudo apt install net-tools -y
    ;;
    "6")
        echo "Install Wget and Unzip."
        sudo apt install wget unzip -y
    ;;
    "7")
        echo "Install Traceroute."
        sudo apt install traceroute -y
    ;;
    "8")
        echo "Install Netcat."
        sudo apt-get install netcat -y
    ;;
    *)
        echo "Default install all."
        sudo snap install cmake --classic -y
        sudo apt-get install arp-scan -y
        sudo apt install speedtest-cli -y
        sudo apt install snmpd snmp libsnmp-dev -y
        sudo apt install net-tools -y
        sudo apt install wget unzip -y
        sudo apt install traceroute -y
        sudo apt-get install netcat -y
    ;;
esac

# Install Firewall-cmd - Default
echo "Install firewall-cmd."
sudo apt install firewalld -y
sudo systemctl enable firewalld
sudo ufw disable

# Install Docker - Default
echo "Install Docker"
sudo apt-get install -y docker.io docker-compose
sudo groupadd docker
sudo usermod -aG docker ${USER}
echo "Check version"
docker-compose version
docker version

# Reboot device
echo "Reboot device"
reboot
