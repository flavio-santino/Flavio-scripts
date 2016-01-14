#!/bin/sh
 
# A script to install KVM guest
# using automatic installation using network installation or autoyast.
# Flavio Pereira - flaviosantino@gmail.com
# Date: 2015-12-01

if [ $# -ne 1 ]
then
echo "Usage: $0 guest-name"
exit 1
fi


virt-install \
--name ${1} \
--disk path=/home/username/KVM-guests/${1}.qcow2,format=qcow2,bus=virtio,cache=none,size=10 \
--vnc \
--noautoconsole \
--vcpus=2 \
--ram=1024 \
--network bridge=br0 \
--location=http://your-webserver.com/install/sles12/x86_64/
#-x "autoyast=http://your-webserver.com/autoyast-files/sles12-autoyast.xml" 
