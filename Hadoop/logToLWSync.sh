#!/usr/bin/env bash

# This script will sync the files generated by the chukwa collector to hdfs only if the file doesn't exist on hdfs or the file size is smaller on hdfs.
# After a file has been uploaded to hdfs it will be moved to the synced folder

#if [ -z $HADOOP_HOME ] ; then
# if [ -e /etc/profile.d/hadoop.sh ]; then
#  source /etc/profile.d/hadoop.sh
# else
#  echo "Please set the HADOOP_HOME variable"
#  exit -1
# fi
#fi


if [ -z $5 ]
then
 echo "Type <local_log_dir> <synced_dir> <error_dir> <hdfs_dir> <logfile extension>"
 exit -1
fi

LOCAL_LOG_DIR=$1
SYNCED_DIR=$2
ERROR_DIR=$3
HDFS_DIR=$4

LOG_FILE_EXTENSION=$5

COMPRESSION_TOOL="NONE"

#configure the file extension compression testing tool
case $LOG_FILE_EXTENSION in
 lzo | LZO | lzop | LZOP)
   export COMPRESSION_TOOL="/usr/bin/lzop"
 ;;
 gz | GZ | gzip | GZIP)
   export COMPRESSION_TOOL="/usr/bin/gzip"
 ;;
 bz2 | BZ2 | bzip2 | BZIP2)
   export COMPRESSION_TOOL="/usr/bin/bzip2"
 ;;
esac


for f in $( find -L $LOCAL_LOG_DIR -name "*[0-9][0-9][0-9][0-9]-[0-9][0-9]\-[0-9][0-9]\-[0-9][0-9].*?$LOG_FILE_EXTENSION" )
do

if [ -a $COMPRESSION_TOOL ] 
then

 if ! $COMPRESSION_TOOL -t $f ; then

   if [ ! -d $ERROR_DIR ]
   then
      mkdir -p $ERROR_DIR
   fi

   echo "The file $f is not a valid LZO file"
   echo "Moving file to $ERROR_DIR"
   mv $f $ERROR_DIR/
   continue
 
 fi

fi

fileName=$( basename $f)
echo "fileName: $fileName"


uploadFileName="$HOSTNAME~$fileName"


logtype=$( echo "$fileName" | awk -F "." '{print $1}')

daydate_part=$( echo "$fileName" | awk -F '.' '{print $2}' )

#the daydate format is yyyy/MM/dd
daydate=$( echo "$daydate_part" | awk -F '-' '{print "year="$1"/month="$2"/day="$3}' )


#validate the daydate field. We do not know what the filename will be we can only assume
#if the file name is not in the format expected then we'll not get the correct daydate
if [[ ! "$daydate" =~ (year=[0-9][0-9][0-9][0-9]/month=[0-9][0-9]/day=[0-9][0-9]) ]]
then
   echo "File name incorrect"
   echo "The daydate format for file $fileName was $daydate"
   exit -1
fi


hour=$( echo "$daydate_part" | awk -F '-' '{print $4}' )


#validate hour
if [[ ! "$hour" =~ ([0-9][0-9]) ]]
then
  echo "File name incorrect"
  echo "The hour format is not correct for file $fileName was $hour"
fi

#email="yusuf@bidsopt.com"
date
rsync -azve "ssh -p 2814 -oStrictHostKeyChecking=no" $f root@tqdg006:/data/streams-collector/awslogs/$uploadFileName
copy_status=`echo $?`

if [ $copy_status -ne 0 ]; then
        echo "Failed to copy file $f into remote server!!" | mail -s "Error in Stream Collecctor: Failed to copy file $f into remote server!!"; 2>/dev/null
        exit -1
else
	mv $f $SYNCED_DIR/
fi
date
 #compare file sizes


done
