#!/bin/bash

log_file="$1"
mins="$2"
cur_date=`date +'%Y-%m-%d' --date "now - ${mins} minutes"`
cur_time=`date +'%H:%M:%S' --date "now - ${mins} minutes" | awk -F: '{printf "%s:%s\n", $1,$2}'`

#Error_count=`grep "$cur_date" /opt/glue/logs/serverlog.log | grep "$cur_time:" | grep -e "ERROR" | wc -l`
log_check=`sed -ne "/$cur_date/"',$p'  $log_file | sed -n -e "/$cur_time:/"',$p' | grep -i -e "ERROR" -ie "exception"`
if [[ ! -e $log_file ]]
 then
   echo "$log_file - File not found"
   exit 2
 elif [[ -z "$log_check" ]]
  then
        echo "$log_file log not having any error in past hour"
        exit 0
  else
        echo "$log_file log having error in past hour"
        exit 2
fi
