#!/bin/bash

for i in {clicks,convs}
do
#time=`date --date "-10min"`
source_file=`ls -t /home/bidsopt/deployment/dest/${i}/|tail -1`
if [ ! -z /home/bidsopt/deployment/dest/${i}/${source_file} ] 
then
if [ -d /home/bidsopt/deployment/dest/${i}/${source_file} -a `find /home/bidsopt/deployment/dest/${i}/${source_file} -mmin +1 -maxdepth 0| wc -l` -eq 1 ]
then
 rsync -arvze "ssh -p2814" /home/bidsopt/deployment/dest/${i}/${source_file} root@tqdg005:/home/bidsopt/deployment/dest/${i}/ && rm -rf /home/bidsopt/deployment/dest/${i}/${source_file} >> /var/log/rsync.log 2>&1
fi
fi
done
