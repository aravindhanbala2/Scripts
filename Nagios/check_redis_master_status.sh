#!/bin/bash
statu=`/usr/local/bin/redis-cli -p 7379 info|/usr/bin/grep "master_link_status"|awk -F: '{sub(/\r/,"",$2);print $2}'`
master=`/usr/local/bin/redis-cli -p 7379 info|/usr/bin/grep "master_host"|awk -F: '{sub(/\r/,"",$2);print $2}'`
if [ "$statu" == "up" ]
then
        echo "Master - $master link status is $statu"
        exit 0
else
        echo "Master - $master link status is $statu"
        exit 2
fi
