#!/bin/bash

# creating user  and password

read -p "enter a username (user will be added to wheel group):  " NEWUSER
read -p "enter a passwd:  "   PASSWD
read -p "switch to user when done (Y)? " su

# command to create user

sudo useradd "$NEWUSER"


# group

sudo usermod -aG wheel "$NEWUSER" 



# command to create passwd

echo "$NEWUSER:$PASSWD" | sudo chpasswd


echo "The account $NEWUSER and password has been made."


# Switch user

if [ "$su" = "Y" ]; then 
	sudo -i -u "$NEWUSER"
fi
