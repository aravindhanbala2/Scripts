#!/bin/sh -x
PATH="$PATH:/usr/java/latest/bin:/opt/node/bin:/opt/play:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/bin:/sbin:/root/bin"
echo "Start time: `date`"
DATE=`date +'%Y-%m-%d'`
CURL=`curl -s "http://localhost:5600/advertiser_overview.js?rowsPerPage=10&page=1&edate=${DATE}&sdate=${DATE}" | grep "status" | wc -l`

if [ $CURL -eq 1 ];
 then
    echo "boreports service is running fine"
 else
    echo "There is some issue with boreports service. Restarting the service"
    pushd /home/bidsopt/deployment/boReports/ 
    easyrep stop
    easyrep start
fi
