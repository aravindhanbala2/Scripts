#!/bin/bash
cur_date=`date +'%Y-%m-%d %H:%M:%S'  --date 'now - 10 minutes'`

### MySQL Configuration
DB_HOSTNAME="127.0.0.1"
DB_USERNAME="glue"
DB_PASSWD="Glue@123"
DB_NAME="glue"

MYSQL=`which mysql`;
QUERY="select start_date from ${DB_NAME}.processes where start_date > \"$cur_date\" limit 1";


#Error_count=`grep "$cur_date" /opt/glue/logs/serverlog.log | grep "$cur_time:" | grep -e "ERROR" | wc -l`
${MYSQL} -u$DB_USERNAME -p$DB_PASSWD -h$DB_HOSTNAME -e"${QUERY}" > /tmp/glue_job_trigger.txt
if [ `wc -l /tmp/glue_job_trigger.txt|awk '{print $1}'` -eq 2 ]
then
    echo "Glue job triggering properly"
    exit 0
else
    echo "Glue job is not triggered. Last glue job triggered at `cat /tmp/glue_job_trigger.txt`"
    exit 2
fi
