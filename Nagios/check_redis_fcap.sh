#!/bin/bash

log_file="/opt/dsp-server/logs/server.log"
#log_time=`date +'%Y-%m-%d/%H:%M' --date 'now - 5 minutes'`
cur_date=`date +'%Y-%m-%d'`
cur_time=`date +'%H:%M:%S' --date 'now - 60 minutes' | awk -F: '{printf "%s:%s\n", $1,$2}'`

#log_check=`cat $log_file | grep --line-buffered "$log_time" | grep -e "fcap null"`
log_check=`sed -ne "/$cur_date/"',$p'  $log_file | sed -n -e "/$cur_time:/"',$p' | grep -e "fcap null" -e "Error Returning LOADING Redis"`

if [[ ! -e $log_file ]]
 then
   echo "$log_file - File not found"
   exit 2
 elif [[ -z "$log_check" ]]
  then
        echo "Redis connectivity is working fine"
        exit 0
  else
        echo "Redis connectivity issue"
        exit 2
 fi
