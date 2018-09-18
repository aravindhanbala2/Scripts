#!/bin/bash
log_file="/opt/streams-collector/logs/streams-collector.log"
cur_date=`date +'%Y-%m-%d/%H:'`

#log_check=`grep "$cur_date" /opt/glue/logs/serverlog.log | grep "$cur_time:" | grep -e "ERROR" | wc -l`
log_check=`grep "$cur_date" $log_file|grep "slowing"|wc -l`
if [[ ! -e $log_file ]]
 then
   echo "$log_file - File not found"
   exit 2
 elif [[ "$log_check" -eq 0 ]]
  then
        echo "collector is working fine"
        exit 0
  else
        echo "collector facing io operation latency error $log_check times in current hour"
        exit 2
fi
