#!/bin/bash
# Set the hostname and a static IPv4 address (like nmtui, but with prompts).
# Run as root:  bash network.sh

# Show the network cards so you know which one to pick
nmcli device status
echo

read -p "Enter the new hostname: " NEWHOST
read -p "Enter the network interface (e.g. ens160): " IFACE
read -p "Enter the IP address with prefix (e.g. 10.0.5.10/24): " IPADDR
read -p "Enter the default gateway (e.g. 10.0.5.2): " GATEWAY
read -p "Enter the DNS server(s), separated by spaces: " DNS
read -p "Enter the search domain (e.g. ethan.local): " SEARCH

# Set the hostname
hostnamectl set-hostname "$NEWHOST"

# Find the connection profile that belongs to the interface
CON=$(nmcli -g GENERAL.CONNECTION device show "$IFACE")

# Set static IPv4 settings
nmcli con mod "$CON" ipv4.method manual \
    ipv4.addresses "$IPADDR" \
    ipv4.gateway "$GATEWAY" \
    ipv4.dns "$DNS" \
    ipv4.dns-search "$SEARCH" \
    connection.autoconnect yes

# Restart the connection to apply the changes
nmcli con up "$CON"

echo
echo "Hostname: $(hostname)"
ip -4 addr show "$IFACE" | grep inet
echo "Done! Log out and back in to see the new hostname in your prompt."
