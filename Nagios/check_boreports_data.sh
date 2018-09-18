#!/bin/bash
DATE="`date +'%Y-%m-%d'`"
CURL=`curl -s 'http://localhost:5600/advertiser_overview.js?rowsPerPage=20&page=1&edate=${DATE}&sdate=${DATE}' | grep "status" | wc -l`
#echo "$CURL"

if [ $CURL -eq 1 ];
 then
    echo "boreports service is running fine"
    exit 0
 else
    echo "There is some issue with boreports service"
 #   cd /home/bidsopt/deployment/boreports/ ; /opt/easyrep/bin/easyrep stop ; /opt/easyrep/bin/easyrep start
 #   echo "Restarted the boreports service"
    exit 2
fi
