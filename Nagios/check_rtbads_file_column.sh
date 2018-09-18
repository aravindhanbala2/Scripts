#!/bin/bash

FILE="$1"
FILECOLUMN=$2

if [ ! -z ${FILE} ]
then
while read LINE
 do
   COL=`echo "$LINE" | awk -F"," '{ print NF; }'`

if [ $COL = "$FILECOLUMN" ]
 then
      echo "$FILE is contains $FILECOLUMN Column"
 else
      echo "$FILE is not contains $FILECOLUMN Column"
      exit 2
fi

done < $FILE
else
        echo "$FILE is not exist"
        exit 2
fi
exit 0

