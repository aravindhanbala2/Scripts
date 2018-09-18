#!/bin/bash

ping_arr=`ping -c6 redis_server | grep time= | awk  '{ print $8 }' | awk -F "=" '{print $2}' | sort -nr | head -n3`
ping_status=$((for arr_val in ${ping_arr[@]}; do rounded_count=$(printf "%.0f" $arr_val);[[ $rounded_count -le 2 ]] && exit 0; done) && echo "normal" || echo "critical")
echo $ping_status
