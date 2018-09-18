#!/bin/bash

log_file="/opt/dsp-server/logs/indexer.log"
log_time=`date +'%Y-%m-%d/%H:%M' --date 'now - 1 minutes'`

log_check=`cat $log_file | grep --line-buffered "$log_time" | grep -e "ERROR"`

if [[ ! -e $log_file ]]
 then
   echo "$log_file - File not found"
   exit 2
 elif [[ -z "$log_check" ]]
  then
        echo "Indexing is done"
        exit 0
  else
        echo "Indexing is failed"
        exit 2
 fi
