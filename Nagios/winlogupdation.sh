#!/bin/bash

/usr/local/nagios/libexec/check_file_age /opt/ssp-win-service/logs/ssp_win_service_nohup.log

/usr/local/nagios/libexec/check_file_age /opt/ssp-tracker/logs/server_nohup.log
