#!/bin/bash
while IFS='' read -r line || [[ -n "$line" ]]; do
 #echo "$line"
 #./getHashSingle.py "$line"
 ./loadKillMails_Manuell.py "$line"
  sleep 0.2
done < "$1"
