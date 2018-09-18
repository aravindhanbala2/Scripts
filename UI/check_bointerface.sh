#!/bin/sh -x

PATH="$PATH:/usr/java/latest/bin:/opt/node/bin:/opt/play:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/bin:/sbin:/root/bin"
echo "Start time: `date`"
PROCESS=`jps|grep "ProdServerStart"|wc -l`
if [ $PROCESS -eq 1 ];
 then
    echo "bointerface service is running fine"
 else
    echo "There is some issue with play service. Restarting the service"
    pushd /home/bidsopt/deployment/bointerface/ 
    sbt stopProd
    rm -rf /home/bidsopt/deployment/bointerface/target/universal/stage/RUNNING_PID
    sbt -J-Xms1G -J-Xmx5G start &
fi
