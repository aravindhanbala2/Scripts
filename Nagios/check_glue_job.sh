#!/bin/bash
cur_date=`date +'%Y-%m-%d %H:%M:%S'  --date 'now - 30 minutes'`

### MySQL Configuration
DB_HOSTNAME="localhost"
DB_USERNAME="glue"
DB_PASSWD="Glue@123"
DB_NAME="glue"

MYSQL=`which mysql`;
QUERY="select name,status from ${DB_NAME}.units where start_date > \"$cur_date\"";


#Error_count=`grep "$cur_date" /opt/glue/logs/serverlog.log | grep "$cur_time:" | grep -e "ERROR" | wc -l`
${MYSQL} -u$DB_USERNAME -p$DB_PASSWD -h$DB_HOSTNAME -e"${QUERY}" > /tmp/glue_log.txt
ERROR=`grep FAILED /tmp/glue_log.txt`
if [[ -n ${ERROR} ]]
then
    echo "Glue job failed - `grep FAILED /tmp/glue_log.txt|awk '{print $1}'`"
    exit 2
else
    echo "Glue job is working fine"
    exit 0
fi
