#!/bin/bash
if [ $# -lt 2 ]
then
  echo "Usage: $0 <logDir> <dbDir>"
fi
logDir=$1
dbDir=$2

for f in $logDir/*
do
  bn=$(basename $f | cut -d '.' -f 1,2)
  ./processLog.sh $f $dbDir/$bn
done
