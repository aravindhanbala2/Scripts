#!/bin/bash



/opt/kafka/bin/kafka-run-class.sh kafka.tools.ConsumerOffsetChecker --group group1 --zookeeper 127.0.0.1 --topic CampaignTxnCPM | awk -F' ' '{if(!/Lag/) print $7;}' | grep -iE "NULL|NONE"| wc -l > /tmp/CampaignTxn_Null_CPM_tmp

sleep 1

/opt/kafka/bin/kafka-run-class.sh kafka.tools.ConsumerOffsetChecker --group group1 --zookeeper 127.0.0.1 --topic CampaignTxnCPC | awk -F' ' '{if(!/Lag/) print $7;}' | grep -iE "NULL|NONE" | wc -l > /tmp/CampaignTxn_Null_CPC_tmp

sleep 1

/opt/kafka/bin/kafka-run-class.sh kafka.tools.ConsumerOffsetChecker --group group1 --zookeeper 127.0.0.1 --topic CampaignTxnCPM | awk -F' ' '{if(!/Lag/) print $6;}' | sort -rn > /tmp/CampaignTxn_Lag_CPM_tmp

sleep 1

/opt/kafka/bin/kafka-run-class.sh kafka.tools.ConsumerOffsetChecker --group group1 --zookeeper 127.0.0.1 --topic CampaignTxnCPC | awk -F' ' '{if(!/Lag/) print $6;}' | sort -rn > /tmp/CampaignTxn_Lag_CPC_tmp

sleep 2

/usr/bin/cp /tmp/CampaignTxn_Null_CPM_tmp /tmp/CampaignTxn_Null_CPM
/usr/bin/cp /tmp/CampaignTxn_Null_CPC_tmp /tmp/CampaignTxn_Null_CPC

/usr/bin/cp /tmp/CampaignTxn_Lag_CPM_tmp /tmp/CampaignTxn_Lag_CPM
/usr/bin/cp /tmp/CampaignTxn_Lag_CPC_tmp /tmp/CampaignTxn_Lag_CPC

exit 0
