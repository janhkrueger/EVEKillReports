#!/bin/bash
wget https://www.fuzzwork.co.uk/dump/postgres-latest.dmp.bz2
bunzip2 postgres-latest.dmp.bz2
pg_restore -U  --role= -d eve postgres-latest.dmp
rm postgres-latest.dmp