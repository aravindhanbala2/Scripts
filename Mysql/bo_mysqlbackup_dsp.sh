#!/bin/bash

echo "Start time: `date`"
bkp=`date +%Y%m%d`
bkpdate=`date +%Y%m%d%H`
lock_file=/tmp/mysqldump_$bkpdate.lock

last_mnt_last_date=`date --d="$(date +%Y/%m/01) - 1 Day" +'%Y-%m-%d'`
last_mnt_first_date=`date --d="$(date +%Y/%m/01) - 1 Day" +'%Y-%m-01'`
current_date=`date +'%Y-%m-%d'`
current_hr=`date +'%H'`

bkpdir="/data/mysql/backup/daily_backup/$(date +%Y%m%d)"
reports_monthly_bkpdir="/data/mysql/backup/monthly_backup/"
oldbkp=`date --date="7 days ago" +"%Y%m%d"`

dbuser="boro"
dbpass="boro"
reports_dbpass="Boro@123"

lock_file_check () {

 if ! [ -f $lock_file ] 
  then
      echo "Creating $lock_file"
      echo $$ > $lock_file
      echo "BKP Date  : $bkpdate"
      echo "Lock File : $lock_file"

 backup_directory
      
 else
      echo "Backup is already running. Please delete the lock file : $lock_file and re-run the script "
 fi
}

backup_directory () {

 echo "Making Backup Directory $bkpdir"
 mkdir $bkpdir -p

 bo_dsp_backup
# bo_reports_backup
# glue_backup
 archive_old_backup

}

bo_dsp_backup () { 

echo "Database backup - bo_dsp for $CURDATE"
mysqldump -u$dbuser -p$dbpass --single-transaction --ignore-table={bo_dsp.adgroup_logs,bo_dsp.gui_meta_data,bo_dsp.dsp_updations} bo_dsp 2>/dev/null > $bkpdir/bo_dsp_$bkpdate.sql
 
  if [ $? -eq 0 ]
   then
       echo "Database - $bkpdate : bo_dsp backup is successful"
       echo "Compressing the backup file : bo_dsp_$bkpdate.sql"
       bzip2 -q9 $bkpdir/bo_dsp_$bkpdate.sql
   else
       echo "Database - $bkpdate : bo_dsp backup is unsuccessful"
  fi
  rsync_to_tqdg025 "${bkpdir}/" "/data/Backups/DBs/daily_backup/${bkp}/"
}

bo_reports_backup () {

if [ $current_hr -eq 23 ]
then
 echo "Database daily backup - bo_reports"

 mysql -u$dbuser -p$reports_dbpass bo_reports -e 'show tables' 2>/dev/null | grep -v Tables_in_ |grep -vE 'adclient_category_report|adclients_unknown|carrierowner_unknown'| xargs mysqldump -u$dbuser -p$reports_dbpass --single-transaction --no-create-info bo_reports --where="daydate between ${last_mnt_last_date} and ${current_date}" 2>/dev/null > $reports_daily_bkpdir/bo_reports_$bkpdate.sql

  if [ $? -eq 0 ]
   then
       echo "Database : bo_reports daily backup is successful"
       echo "Compressing the backup file : bo_reports_$bkpdate.sql"
       bzip2 -q9  $reports_daily_bkpdir/bo_reports_$bkpdate.sql
   else
       echo "Database : bo_reports daily backup is unsuccessful"
  fi
  rsync_to_tqdg025 "${bkpdir}/" "/data/Backups/DBs/daily_backup/${bkp}/"
elif [ $current_hr -eq 22 ]
then
 echo "Database monthly backup - bo_reports"

 mysql -u$dbuser -p$reports_dbpass bo_reports -e 'show tables' 2>/dev/null | grep -v Tables_in_ |grep -vE 'adclient_category_report|adclients_unknown|carrierowner_unknown'| xargs mysqldump -u$dbuser -p$reports_dbpass --single-transaction --no-create-info bo_reports --where="daydate between ${last_mnt_last_date} and ${last_mnt_first_date}" 2>/dev/null > $reports_monthly_bkpdir/bo_reports_$bkpdate.sql

  if [ $? -eq 0 ]
   then
       echo "Database : bo_reports monthly backup is successful"
       echo "Compressing the backup file : bo_reports_$bkpdate.sql"
       bzip2 -q9  $reports_monthly_bkpdir/bo_reports_$bkpdate.sql
   else
       echo "Database : bo_reports monthly backup is unsuccessful"
  fi
  rsync_to_tqdg025 "${reports_monthly_bkpdir}/" "/data/Backups/DBs/monthly_backup/"
fi
}


glue_backup () {

 echo "Database backup - glue"

 mysqldump -u$dbuser -p$dbpass --single-transaction glue 2>/dev/null > $bkpdir/glue_$bkpdate.sql

  if [ $? -eq 0 ]
   then
       echo "Database : glue backup is successful"
       echo "Compressing the backup file : glue_$bkpdate.sql"
       bzip2 -q9  $bkpdir/glue_$bkpdate.sql
   else
       echo "Database : glue backup is unsuccessful"
  fi

}

archive_old_backup () {

 echo "Dropping old backup $oldbkp"
 rm -rf /data/mysql/backup/daily_backup/$oldbkp

}

rsync_to_tqdg025 () {

 echo "Copy the backup files to Nagios"
 rsync -azve "ssh -p 2814" ${1} tqdg025:${2}
 #scp -P2814 $bkpdir/bo_dsp_$bkpdate.sql.bz2 bo_usev_nagios:/data/Backups/DBs/$(date +%Y%m%d)
 
# echo "Copy to S3 from Sn1"
#/usr/bin/ssh servern1 "/usr/local/bin/aws s3 sync --delete /data/Backups/Servers/Linode/Sn5/DBs/daily_backup/. s3://bidsoptbackups/Databases/daily_backup/"
# /usr/bin/ssh servern1 "/usr/local/bin/aws s3 sync /data/Backups/Servers/Linode/Sn5/DBs/daily_backup/. s3://bidsoptbackups/Databases/daily_backup/"
}

lock_file_check
echo "Deleting Lock File $lock_file"
rm -rf $lock_file
echo "End time: `date`"
