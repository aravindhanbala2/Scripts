#!/bin/bash
log_file=$1
#cur_time=`date +'%Y-%m-%d\/%H:' --date 'now - 20 minutes'`

#log_check=`grep "$cur_date" /opt/glue/logs/serverlog.log | grep "$cur_time:" | grep -e "ERROR" | wc -l`
#log_check=`sed -ne "/$cur_date/"',$p'  $log_file | sed -n -e "/$cur_time/"',$p' | grep -i -e "heap"`
log_check=`cat $log_file | grep -i -e "heap"`
if [[ ! -e $log_file ]]
 then
   echo "$log_file - File not found"
   exit 2
 elif [[ -z "$log_check" ]]
  then
        echo "service is working fine"
        exit 0
  else
        echo "service getting operation heap space error"
        exit 2
fi
