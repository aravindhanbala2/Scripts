#!/bin/bash

host=localhost
user=nagios
password=nagios

#MSG=`mysql -h $host -u$user -p$password -e 'show slave status\G' | grep Last_SQL_Error | sed -e 's/ *Last_SQL_Error: //'`
Slave_sql=`mysql -h $host -u$user -p$password -e 'show slave status\G' |grep -i "Slave_SQL_Running"| awk '{print $2}'`
Slave_IO=`mysql -h $host -u$user -p$password -e 'show slave status\G' |grep -i "Slave_IO_Running"| awk '{print $2}'`
Seconds_Behind_Master=`mysql -h $host -u$user -p$password -e 'show slave status\G' |grep -i "Seconds_Behind_Master"| awk '{print $2}'`

if [ "$Slave_sql" = "No" ]; then
 f1=true
else
 f1=false
fi

if [ "$Slave_IO" = "No" ]; then
 f2=true
else
 f2=false
fi

if [ "$Seconds_Behind_Master" -gt "100" ]; then
 f3=true
else
 f3=false
fi
 
 if [ "$f1" == "true" -a "$f2" == "true" -a "$f3" == "true" ]
  then
    echo "Slave_SQL_Running, Slave_IO_Running & Seconds_Behind_Master is not working"
    exit 2

 elif [ "$f1" == "true" -a "$f2" == "false" -a "$f3" == "false" ]
  then
    echo "Slave_SQL_Running is not running, Slave_IO_Running & Seconds_Behind_Master is fine"
    exit 2

 elif [ "$f1" == "true" -a "$f2" == "true" -a "$f3" == "false" ]
  then
    echo "Slave_SQL_Running & Slave_IO_Running is not running, Seconds_Behind_Master is fine"
    exit 2

 elif [ "$f1" == "false" -a "$f2" == "true" -a "$f3" == "true" ]
  then
    echo "Slave_SQL_Running is running, Slave_IO_Running & Seconds_Behind_Master is not working"
    exit 2

 elif [ "$f1" == "false" -a "$f2" == "false" -a "$f3" == "true" ]
  then
    echo "Slave_SQL_Running & Slave_IO_Running is running, Seconds_Behind_Master > 100"
    exit 2

 elif [ "$f1" == "false" -a "$f2" == "true" -a "$f3" == "false" ]
  then
    echo "Slave_SQL_Running,Seconds_Behind_Master is running & Slave_IO_Running is not running"
    exit 2

 elif [ "$f1" == "true" -a "$f2" == "false" -a "$f3" == "true" ]
  then
    echo "Slave_SQL_Running,Seconds_Behind_Master is not running & Slave_IO_Running is running"
    exit 2

 else
    echo "Slave_SQL_Running,Slave_IO_Running & Seconds_Behind_Master is working"
    exit 0
 
 fi
