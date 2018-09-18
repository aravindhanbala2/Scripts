#!/bin/bash
BASE_PATH="/data/rawlog"
HADOOP_HOME="/opt/hadoop"
JAVA_HOME="/usr/java/latest"

export JAVA_HOME="/usr/java/latest"
## Archival days configuration Actual + 1 day

ads_ARCHIVE=1
clicks_ARCHIVE=1
conversions_ARCHIVE=1
imps_ARCHIVE=1
campaign_txn_ARCHIVE=91
noads_ARCHIVE=16
rtbads_ARCHIVE=31
rtbnoads_ARCHIVE=16
rtbwinloss_ARCHIVE=31

archiver() {
        TOPIC=$1
        TOPIC_ARCHIVE=$2
        if [[ ${TOPIC} = "" || ${TOPIC_ARCHIVE} -eq 0 ]]
        then
                echo "ERROR: Wrong topic or archival time passed"
                exit 1;
        fi

        QUERY_DATE=`date -d "${TOPIC_ARCHIVE} days ago" +"${BASE_PATH}/${TOPIC}/year=%Y/month=%m/day=%d"`
        echo "`date` -- Starting the Archival of HDFS topic ${TOPIC} - path ${QUERY_DATE}";
        su hadoop -c "$HADOOP_HOME/bin/hadoop fs -ls ${QUERY_DATE};"
        ##$HADOOP_HOME/bin/hadoop fs -rmr ${QUERY_DATE};
        ##$HADOOP_HOME/bin/hadoop fs -expunge;
        su hadoop -c "$HADOOP_HOME/bin/hadoop fs -D fs.trash.interval=0 -rmr ${QUERY_DATE};"
        su hadoop -c "$HADOOP_HOME/bin/hadoop fs -ls ${QUERY_DATE};"
        echo "`date` -- Completed the Archival of HDFS topic ${TOPIC} - path ${QUERY_DATE}";
        echo ""
}

archiver ads ${ads_ARCHIVE}
archiver clicks ${clicks_ARCHIVE}
archiver conversion ${conversions_ARCHIVE}
archiver imp ${imps_ARCHIVE}
#archiver campaign_txn ${campaign_txn_ARCHIVE}
#archiver noads ${noads_ARCHIVE}
##archiver rtbads ${rtbads_ARCHIVE}
#archiver rtbnoads ${rtbnoads_ARCHIVE}
#archiver rtbwinloss ${rtbwinloss_ARCHIVE}

## Exit
exit 0
