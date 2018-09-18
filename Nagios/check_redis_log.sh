#!/bin/sh

log_file="/var/log/redis.log"
cur_date=`date +'%d %b'`
cur_time=`date +'%H:%M' --date 'now - 60 minutes'`

#Error_count=`grep "$cur_date" /opt/glue/logs/serverlog.log | grep "$cur_time:" | grep -e "ERROR" | wc -l`
log_check=`sed -ne "/$cur_date/"',$p'  $log_file | sed -n -e "/$cur_time:/"',$p' | grep -i -e "ERROR" -e "aborted" -e "Partial resynchronization not possible"`
if [[ ! -e $log_file ]]
 then
   echo "$log_file - File not found"
   exit 2
 elif [[ -z "$log_check" ]]
  then
        echo "Redis log not any having error in past hour"
        exit 0
  else
        echo "Redis log having error in past hour"
        exit 2
fi

