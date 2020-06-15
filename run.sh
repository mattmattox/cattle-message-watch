#!/bin/bash

if [[ -z $EmailAddress ]]
then
  echo "Missing EmailAddress"
  exit 1
fi
echo "EmailAddress: $EmailAddress"

while true
do

echo "Looking for Rancher server..."
ContainerID=`docker ps | grep 'rancher/server' | awk '{print $1}'`
if [ -z $ContainerID ]
then
  echo "Could not find Rancher server..."
  sleep 5
  continue
else
  echo "Rancher Server found"
  echo "Container ID: $ContainerID"
fi
COUNTER=0
PastTime=`date +%s`

echo "Reviewing Rancher server logs..."
docker logs -f $ContainerID 2>&1 | \
while read line;
do
  if echo $line | grep -i 'io.cattle.platform.lock.exception.FailedToAcquireLockException'
  then
    echo "Found error message"
    let COUNTER=COUNTER+1
    if [[ $COUNTER -gt 1 ]]
    then
      CurrentTime=`date +%s`
      DiffTime=` echo "$CurrentTime - $PastTime" | bc`
      if [[ "$DiffTime" -lt 360 ]]
      then
        Subject="$(echo 'FailedToAcquireLockException on' `hostname -f`)"
        echo $line | mail -s "$Subject" "$EmailAddress"
      else
        echo "Timed out"
        COUNTER=0
      fi
    fi
    PastTime=`date +%s`
  fi
done

done
