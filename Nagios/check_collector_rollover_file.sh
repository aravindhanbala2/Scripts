#!/bin/sh

log_file="/opt/streams-collector/logs/streams-collector.log"
cur_date=`date +'%Y%m%d' --date 'now - 60 minutes'`
cur_time=`date +'%H%M' --date 'now - 60 minutes'`

last_rolled_over_date=`grep "Rolled file:" ${log_file}|tail -1|awk '{print $1}'|awk -F"/" '{print $1}'|awk -F- '{print $1$2$3}'`
last_rolled_over_time=`grep "Rolled file:" ${log_file}|tail -1|awk '{print $1}'|awk -F"/" '{print $2}'|awk -F: '{print $1$2}'|/usr/bin/sed -e 's/^0//g'`
last_rolled_filename=`grep "Rolled file:" ${log_file}|tail -1|awk '{print $NF}'`

if [[ ! -e $log_file ]]
 then
   echo "$log_file - File not found"
   exit 2
else
    if [[ -z ${last_rolled_over_time} ]]
    then
	echo "LZO roll over timestamp details not available in log file"
  	exit 2
    elif [[ ${last_rolled_over_date}${last_rolled_over_time} > ${cur_date}${cur_time} ]]
   then
	echo "Last LZO roll over details: Filename - ${last_rolled_filename}, Date - ${last_rolled_over_date}, Time - ${last_rolled_over_time}"
	exit 0
   else
 	echo "Last LZO roll over details: Filename - ${last_rolled_filename}, Date - ${last_rolled_over_date}, Time - ${last_rolled_over_time}"
	exit 2
   fi
fi
