#!/bin/sh
current_date=`date +'%Y_%m_%d'`
current_bkp_dir="/data/Backups/Bootstrap/${current_date}"

mkdir -p ${current_bkp_dir}

for i in {adclient_buckets,campaign_budget,new_rtb_ads}
do
        latest=`ls -rt ${current_bkp_dir}/${i}*|tail -1`
        if [ -n ${latest} -a `echo ${latest}|wc -l` -eq 1 ]
        then
                rsync -azve "ssh -p 2814 -oStrictHostKeyChecking=no" bootstrap:/home/bidsopt/deployment/bootstrap/data/${i}.csv /tmp/${i}.csv 2>/dev/null
                diff_status=`diff /tmp/${i}.csv ${latest}|wc -l`
                if [ ${diff_status} -ne 0 ]
                then
                        mv /tmp/${i}.csv ${current_bkp_dir}/${i}_`date +'%Y_%m_%d_%H_%M'`.csv
                        date
                fi
        else
                find -L /var/log/bootstrap_backup* -type f -mtime +10 -exec rm -f {} \;
                rsync -azve "ssh -p 2814 -oStrictHostKeyChecking=no" bootstrap:/home/bidsopt/deployment/bootstrap/data/${i}.csv ${current_bkp_dir}/${i}.csv 2>/dev/null
                date
        fi
done

find -L /data/Backups/Bootstrap/ -type d -mtime +30 -exec rm -rf {} \;
~                                                                      
