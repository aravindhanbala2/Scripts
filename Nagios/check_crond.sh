#!/bin/bash

service=crond

VAR=$(ps -ef | grep 'crond' | grep -v 'grep' | wc -l)

if (( $VAR > 0 ))
 then
    echo "$service service is running"
    exit 0
 else
    echo "$service service is not running"
    exit 2
fi
