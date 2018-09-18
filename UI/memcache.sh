#!bin/bash
systemctl restart memcached
curl http://dsp.bidsopt.com/restore_autocomplete

