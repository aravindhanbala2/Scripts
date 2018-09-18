#!/bin/bash
log_file="/opt/zookeeper/logs/zookeeper.log"
cur_date=`date +'%Y-%m-%d'`
cur_time=`date +'%H:%M:%S' --date 'now - 3 minutes' | awk -F: '{printf "%s:%s\n", $1,$2}'`

#log_check=`grep "$cur_date" /opt/glue/logs/serverlog.log | grep "$cur_time:" | grep -e "ERROR" | wc -l`
log_check=`sed -ne "/$cur_date/"',$p'  $log_file | sed -n -e "/$cur_time:/"',$p' | grep -e "operation latency"`
if [[ ! -e $log_file ]]
 then
   echo "$log_file - File not found"
   exit 2
 elif [[ -z "$log_check" ]]
  then
        echo "zookeeper is working fine"
        exit 0
  else
        echo "Zookeper getting operation latency error"
        exit 2
fi
