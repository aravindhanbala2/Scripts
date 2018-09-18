#!/bin/sh

port=$1

if [ $port -eq 7100 ]
then
	if [ `ps -ef | grep "/opt/dsp-server" | grep -i DSPServer | grep -v grep | wc -l` -eq 1 ]
	then
		echo "Adserver_7100-09 process is running"
		exit 0
	else
		echo "Adserver_7100-09 process is not running"
		exit 2
	fi
elif [ $port -eq 8100 ]
then
        if [ `ps -ef | grep "/adserver01/dsp-server" | grep -i DSPServer | grep -v grep | wc -l` -eq 1 ]
        then
                echo "Adserver_8100-09 process is running"
		exit 0
        else
                echo "Adserver_8100-09 process is not running"
		exit 2
        fi
elif [ $port -eq 9100 ]
then
        if [ `ps -ef | grep "/adserver02/dsp-server" | grep -i DSPServer | grep -v grep | wc -l` -eq 1 ]
        then
                echo "Adserver_9100-09 process is running"
                exit 0
        else
                echo "Adserver_9100-09 process is not running"
                exit 2
        fi
fi
