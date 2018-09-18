#!/bin/sh

cur_time=`date +'%Y%m%d%H%M'  --date 'now - 5 minutes'`
filename="$*"
latest_file=`ls -dtr $filename|tail -1`

if [ -f $latest_file ]
then
    latest_timestamp=`ls -tr $latest_file|awk -F_ '{print $NF}'|awk -F. '{print $1}'`
elif [ -d $latest_file ]
then
    latest_timestamp=`ls -dtr $latest_file|awk -F_ '{print $NF}'`
fi

if [ $cur_time -gt $latest_timestamp ]
then
    echo "$latest_file fileage is older than 5 minutes"
    exit 2
else
    echo "$latest_file fileage is lesser than 5 minutes"
    exit 0
fi
