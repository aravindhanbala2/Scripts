log_file=$1
log_time=`date +'%Y-%m-%d/%H:%M' --date 'now - 1 minutes'`

log_check=`cat $log_file | grep --line-buffered "$log_time" | grep -e "No operations allowed after connection closed" -ie "error" -ie "exception"`

if [[ ! -e $log_file ]]
 then
   echo "$log_file - File not found"
   exit 2
 elif [[ -z "$log_check" ]]
  then
        echo "DB Connection is working good"
        exit 0
  else
        echo "DB connection is failed"
        exit 2
 fi

