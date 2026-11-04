#!/bin/bash

# Install AD packages

sudo dnf clean all

sudo dnf makecache

sudo yum install -y realmd samba samba-common oddjob oddjob-mkhomedir adcli sssd  



# Start time synchronization


sudo systemctl enable --now chronyd


# Ask for domain information
read -p "Enter your domain: " DOMAIN

#Capitalization 
DOMAIN="${DOMAIN^^}"
read -p "Enter your AD username: " ADUSER


# Discover the domain
sudo realm discover  "$DOMAIN"


# Join the Domain

sudo realm join --user="$ADUSER" "$DOMAIN"  


# Check domain membership

sudo realm list 


echo  "Domain join process complete!" 
