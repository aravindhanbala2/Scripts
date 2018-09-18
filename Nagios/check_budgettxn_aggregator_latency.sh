#!/bin/sh

datestr="`date +"%Y_%m_%d"`";

dbhost="$1"
dbname="$2"
dbuser="kafka"
dbpass="Kafka@123"


mysql -h$dbhost -u$dbuser -p$dbpass ${dbname} -e "select end_id from campaign_txn_index where tablename=\"campaign_txn_${datestr}\" order by id desc limit 1;select id from campaign_txn_${datestr} order by id desc limit 1;" | sed -e 's/\t//g;' | grep -v id | awk '{ printf $0" "; } END { printf "\n"; }' | while read agg txn;
do
#       echo "$agg $txn"
        ## Every minute we'll have at peak of 30K records. 30000x5 minutes.
        let agg+=300000;

        if [[ ${agg} -lt ${txn} ]]
        then
                echo "ALERT Aggregator is running very slow to catchup TXN data. More processing power required"
                exit 2
        else
                echo "Aggregator is updating fastly"
                exit 0
        fi
done
