#!/bin/bash
DATE=`date +%Y-%m-%d`
cd /opt/bidsopt/adclients/buckets
zip -r /tmp/bucket_$DATE.zip ./*
rsync -azve "ssh -p 2814" /tmp/bucket_$DATE.zip tqdg025:/data/Backups/UI/Bucket/
rm -f /tmp/bucket_$DATE.zip
