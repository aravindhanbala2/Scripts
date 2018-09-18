#!/bin/sh -x
#org_bucket_file_timestap_tmp=`ssh root@tqdg005 -p2814 "stat /opt/bidsopt/bucketization/adclient_buckets.csv|grep Modify:"`
org_bucket_file_timestap=`cat /tmp/org_bucket_file_timestap_tmp|awk '{print $2" "$3}'|awk -F'.' '{print $1}'|sed 's/-/\//g'`
if [ -e /home/bidsopt/deployment/bootstrap/data/adclient_buckets.csv ]
then
	local_bucket_file_timestap=`stat /home/bidsopt/deployment/bootstrap/data/adclient_buckets.csv|grep Modify: |awk '{print $2" "$3}'|awk -F'.' '{print $1}'|sed 's/-/\//g'`
elif [ -e /home/bidsopt/deployment/dsp-server/resources/lucene/data/adclient_buckets.csv ]
then
	local_bucket_file_timestap=`stat /home/bidsopt/deployment/dsp-server/resources/lucene/data/adclient_buckets.csv|grep Modify: |awk '{print $2" "$3}'|awk -F'.' '{print $1}'|sed 's/-/\//g'`
fi

org_bucket_file_epoch=`date -d "$org_bucket_file_timestap" +"%s"`
local_bucket_file_epoch=`date -d "$local_bucket_file_timestap" +"%s"`

bucket_file_timestamp_diff=`expr $org_bucket_file_epoch - $local_bucket_file_epoch`

#echo -e "org_bucket_file_timestap: $org_bucket_file_timestap\nlocal_bucket_file_timestap: $local_bucket_file_timestap\norg_bucket_file_epoch: $org_bucket_file_epoch\nlocal_bucket_file_epoch: $local_bucket_file_epoch\ntime_diff: $bucket_file_timestamp_diff"
if [ $bucket_file_timestamp_diff -lt 300 ]
then
	echo "Bucket filestamp difference is $bucket_file_timestamp_diff seconds"
	exit 0
else
	echo "Bucket filestamp difference is $bucket_file_timestamp_diff seconds"
	exit 2
fi
