#!/bin/bash
Check=`/usr/bin/sudo /usr/sbin/iptables -L | grep 192.168.255.0/24 | wc -l`
if [ $Check = 1 ]
then 
        echo "Iptables is running"
        exit 0
else
        echo "Iptables is not running" 
        exit 2
fi
