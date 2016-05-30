#!/bin/bash

wget https://www.fuzzwork.co.uk/dump/latest/postgres-20160429-TRANQUILITY-2-schema.dmp.bz2
bunzip2 postgres-20160429-TRANQUILITY-2-schema.dmp.bz2
pg_restore  -U --role=p -d  postgres-20160429-TRANQUILITY-2-schema.dmp
rm postgres-20160429-TRANQUILITY-2-schema.dmp.bz2