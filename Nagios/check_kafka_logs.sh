#!/bin/bash

TOPIC=$1
ZK_HOST=$2
CRIT_THRESHOLD=$3

if [ "$TOPIC" = "" -o "$ZK_HOST" = "" -o "$CRIT_THRESHOLD" = "" ]; then

    echo "Usage: $0 kafkatopic zkhost critical"
    exit 2

fi

CONSUMER_LAG_CHECK=()
#CONSUMER_OWNER_CHECK_CPM=`cat /tmp/CampaignTxn_Null_CPM`
#CONSUMER_OWNER_CHECK_CPC=`cat /tmp/CampaignTxn_Null_CPC`
#CONSUMER_LAG_CHECK_CPM=`cat /tmp/CampaignTxn_Lag_CPM`
#CONSUMER_LAG_CHECK_CPC=`cat /tmp/CampaignTxn_Lag_CPC`


if [ "$1" == "CampaignTxnCPM" ];then

 LAG_CHECK=`cat /tmp/CampaignTxn_Lag_CPM`
 CONSUMER_OWNER_CHECK=`cat /tmp/CampaignTxn_Null_CPM`

elif [ "$1" == "CampaignTxnCPC" ];then

 LAG_CHECK=`cat /tmp/CampaignTxn_Lag_CPC`
 CONSUMER_OWNER_CHECK=`cat /tmp/CampaignTxn_Null_CPC`

else

 echo "Please specify the valid topic to check!"

 exit 0

fi


if [ $CONSUMER_OWNER_CHECK -eq 0 ];then

   owner_flag=false

else

   owner_flag=true

fi


for lag_size in ${LAG_CHECK}

do

        if [ $lag_size -gt $CRIT_THRESHOLD ];then
                is_lag=true

        else

                is_lag=false

        fi



        if [ $is_lag == true -a $owner_flag == true ];then

                echo "Critical - $TOPIC - Kafka consumer lag size is high and consumer owner data is null"
                exit 2

        elif [ $is_lag == true -a $owner_flag == false ];then

                echo "Critical - $TOPIC - Kafka consumer lag size is high and consumer owner data is normal"
                exit 2

        elif [ $is_lag == false -a $owner_flag == true ];then

                echo "Critical - $TOPIC - Kafka consumer lag size is normal and consumer owner data is null"
                exit 2

        elif [ $is_lag == true ];then

                echo "Critical - $TOPIC - Kafka consumer lag size is high"
                exit 2

        elif [ $owner_flag == true ];then

                echo "Critical - $TOPIC - Kafka consumer owner data is null"
                exit 2

        else

                echo "OK - $TOPIC - Kafka consumer lag size/owner data is normal"
                exit 0

        fi

done

