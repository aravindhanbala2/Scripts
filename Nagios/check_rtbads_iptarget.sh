#!/bin/bash

FILENAME=$1

Rtb_ads=`awk -F"," '{ print $36; }' ${FILENAME} | grep "\." | wc -l`

if [ "$Rtb_ads" -gt 0 ]
then
        echo "${FILENAME} is having issue with IP-targeting"
        exit 2
else
        echo "${FILENAME} is working fine"
        exit 0
fi
