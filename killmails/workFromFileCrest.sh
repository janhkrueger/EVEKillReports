#!/bin/bash
while IFS='' read -r line || [[ -n "$line" ]]; do
  echo "$line"
  ./getHashSingle.py "$line"
  sleep 0.5
done < "$1"
