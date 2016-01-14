#/bin/bash
#
# Script to find IP address of kvm guest when using DHCP
# Written by Flavio Pereira - flaviosantino@gmail.com 
# Date: 2015-10-20
# Have fun.. 
# Usage: get-vm-ip.sh <vm-name> 

### Check if you passed the VM name ###
if [ $# -ne 1 ]
then
echo "Usage: $0 guest-name"
exit 1
fi


### This is a method to get the IP using arp -n. However, it might be a ###
### problem when you have a bridge using your Local Network or in case, ###
### someone just flush the arp table. 					###

#MAC=$(virsh dumpxml ${1} |grep 'mac address' | awk -F "'" '{print $2}')

#IP=$(arp -n |grep $MAC | awk '{print $1}')

#echo $IP

# I prefer to use this method as it will query the dhcp file inside the guest and return the correct IP

# For SLES 12 guests 
VERSION=$(virt-cat -d ${1} /etc/os-release |grep VERSION_ID | awk -F'"' '{print $2}')


if [ "$VERSION" = "12" ] 
then
	IP=$(virt-cat -d ${1} /var/lib/wicked/lease-eth0-dhcp-ipv4.xml |grep '<address>' | awk -F "[><]" '{print $3}')
else 
	IP=$(virt-cat -d ${1} /var/lib/dhcpcd/dhcpcd-eth0.info |grep IPADDR |awk -F "=" '{print $2}')
fi

echo $IP
# For SLES 11 SP3 and SP4 guests:
#irt-cat -d ${1} /var/lib/dhcpcd/dhcpcd-eth0.info |grep IPADDR |awk -F "=" '{print $2}'
