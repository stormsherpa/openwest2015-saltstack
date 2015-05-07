#!/bin/bash

SHORT_NAME=web1

SALT_HOSTNAME=${SHORT_NAME}.ow2015.stormsherpa.com

echo $SALT_HOSTNAME > /etc/hostname
hostname $SALT_HOSTNAME

mkdir /etc/salt
cp /etc/hostname /etc/salt/minion_id

cd /root
wget scripts.nihosts.net/install_salt.sh

wget -O /tmp/install_salt.sh https://bootstrap.saltstack.com
sh /tmp/install_salt.sh

cp /etc/hostname /etc/salt/minion_id

echo 'append domain-name " ow2015.stormsherpa.com";' >> /etc/dhcp/dhclient.conf
ifdown eth0
ifup eth0

sleep 2

service salt-minion restart

