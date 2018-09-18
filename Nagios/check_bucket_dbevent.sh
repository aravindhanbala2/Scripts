#!/bin/sh
current_time=`date +'%Y/%m/%d %H:%M:%S'`
current_time_epoch=`date -d "$current_time" +'%s'`
echo -e "current_time: $current_time\ncurrent_time_epoch: $current_time_epoch"

mysql -htqdg006 -uboui -p'Boui@123' bo_dsp -e "select * from adclients_mapping_events order by ac_mp_updated_at desc limit 1\G" > /tmp/bkt_events_monitor.txt
last_event_status=`grep ac_mp_status /tmp/bkt_events_monitor.txt|awk '{print $2}'`
last_event_adclient_id=`grep ac_mp_clnt_ids /tmp/bkt_events_monitor.txt|awk '{print $2}'`
last_event_bucket_id=`grep ac_mp_bkt_id /tmp/bkt_events_monitor.txt|awk '{print $2}'`
last_event_adgrp_op=`grep ac_mp_adgrp_operation /tmp/bkt_events_monitor.txt|awk '{print $2}'`
last_event_created_time=`grep ac_mp_created_at /tmp/bkt_events_monitor.txt|awk '{print $2" "$3}'|sed 's/-/\//g'`
last_event_updated_time=`grep ac_mp_updated_at /tmp/bkt_events_monitor.txt|awk '{print $2" "$3}'|sed 's/-/\//g'`
last_event_created_time_epoch=`date -d "$last_event_created_time" +'%s'`
last_event_upated_time_epoch=`date -d "$last_event_updated_time" +'%s'`
echo -e "last_event_status: $last_event_status\nlast_event_adclient_id: $last_event_adclient_id\nlast_event_bucket_id: $last_event_bucket_id\nlast_event_adgrp_op: $last_event_adgrp_op\nlast_event_created_time: $last_event_created_time\nlast_event_updated_time: $last_event_updated_time\nlast_event_created_time_epoch: $last_event_created_time_epoch\nlast_event_upated_time_epoch: $last_event_upated_time_epoch"

last_log_file_modified_time=`stat /opt/bidsopt/bucketization/logs/bucketization.log|grep Modify:|awk '{print $2" "$3}'|awk -F"." '{print $1}'|sed 's/-/\//g'`
last_log_file_modified_epoch=`date -d "$last_log_file_modified_time" +'%s'`
echo -e "last_log_file_modified_time: $last_log_file_modified_time\nlast_log_file_modified_epoch: $last_log_file_modified_epoch"

org_bucket_file_timestap=`stat /opt/bidsopt/bucketization/adclient_buckets.csv|grep Modify:|awk '{print $2" "$3}'|awk -F'.' '{print $1}'|sed 's/-/\//g'`
org_bucket_file_timestap_epoch=`date -d "$org_bucket_file_timestap"  +'%s'`
echo -e "org_bucket_file_timestap: $org_bucket_file_timestap\norg_bucket_file_timestap_epoch: $org_bucket_file_timestap_epoch"

if [ '$last_event_status' !=  'complete' ] && [ $last_event_created_time_epoch -ge `expr $current_time_epoch + 300` ]
then
	echo -e "Last bucket event not processed for more than five minutes. Please check bucket flow."
	exit 2
elif [ $last_event_upated_time_epoch -ge `expr $last_log_file_modified_epoch + 300` ]
then
	echo -e "Bucket log file modified time and bucket event updated time not matching"
	exit 2
elif [ $org_bucket_file_timestap_epoch -ge `expr $last_event_upated_time_epoch + 300` ]
then
	echo -e "Bucket last event triggerd at $last_event_updated_time and bucket csv file updated at $org_bucket_file_timestap. Changes not reflected to csv file, please check bucket flow."
	exit 2
#elif [ '$last_event_adgrp_op' == 'add' ] && [ `grep "$last_event_adclient_id" /opt/bidsopt/bucketization/adclient_buckets.csv|grep "$last_event_bucket_id"|wc -l` -ne 1 ]
#then
#	echo -e "Last bucket event adclient id: $last_event_adclient_id and bucket id: $last_event_bucket_id not updated in buckets csv file"
#	exit 2
#elif [ '$last_event_adgrp_op' == 'remove' ] && [ `grep "$last_event_adclient_id" /opt/bidsopt/bucketization/adclient_buckets.csv|grep "$last_event_bucket_id"|wc -l` -ne 0 ]
#then
#        echo -e "Last bucket event adclient id: $last_event_adclient_id and bucket id: $last_event_bucket_id not updated in buckets csv file"
#	exit 2
else
	echo -e "Bucekt is workking good"
	exit 0
fi
