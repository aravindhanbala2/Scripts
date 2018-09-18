#!/bin/bash
sourcedir="$1";
destinationdir="$2";
for s in {clicks,convs}
do
        date >> /var/log/add_txt_`date +'%Y_%m_%d'`.log
        for dir in $(find ${sourcedir}/${s}/*  -maxdepth 0)
        do
		for file in $(find ${dir} -type f)
		do
	                path=`dirname ${file}`
        	        advertiser=`echo ${path}|awk -F'/' '{print $NF}'`
	                filename=`basename ${file}`
        	        if [ ! -z ${path} -a ! -z ${advertiser} -a ! -z ${filename} ]
                	then
                        	if [ ! -d ${destinationdir}/${advertiser} ]
	                        then
        	                        mkdir -p ${destinationdir}/${advertiser}
                	                if [ ! -f ${destinationdir}/${advertiser}/${filename} ]
                        	        then
                                	        touch ${destinationdir}/${advertiser}/${filename}
	                                fi
        	                elif [ ! -f ${destinationdir}/${advertiser}/${filename} ]
                	        then
                        	        touch ${destinationdir}/${advertiser}/${filename}
	                        fi
        	                for i in $(cat ${file}|sort -u)
                	        do
                        	        if [ ! -z ${i} -a `grep -c ${i} ${destinationdir}/${advertiser}/${filename}` -eq 0 ]
                                	then
                                        	echo "File: ${file}" >> /var/log/add_txt.log
	                                        echo ${i} |tee -a ${destinationdir}/${advertiser}/${filename} >> /var/log/add_txt.log 2>&1
        	                        fi
	                        done
        	                #rm -f ${file}
                	fi
		done
	        #echo "Dir: ${dir}"
		rm -rf ${dir}
        done
done
#find ${sourcedir}/clicks/* -maxdepth 0 -mmin +60
#find ${sourcedir}/convs/* -maxdepth 0 -mmin +60
