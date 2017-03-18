#!/bin/bash
wget https://www.fuzzwork.co.uk/dump/postgres-latest.dmp.bz2
bunzip2 postgres-latest.dmp.bz2
pg_restore -U  --role= -d eve postgres-latest.dmp
rm postgres-latest.dmp

# Exporting dump
pg_dump -Ueve_user eve_db --data-only --no-owner --column-inserts --no-security-labels --no-tablespaces --no-unlogged-table-data --schema=public > test.sql

# Remove comments
sed -i '/^--/d' test.sql

# Remove comments
sed -i '/^SET/d' test.sql

# Remove empty lines
sed -i '/^\s*$/d' test.sql

# Remove double quotes
sed -ie 's/"//g' test.sql

# Adding schema
sed -i 's/INSERT INTO /INSERT INTO sde./g' test.sql

#Running vacuum on the tables
psql -U eve_user -t -A -c "select 'VACUUM '||table_schema||'.'||table_name||';' from information_schema.tables where table_schema = 'sde'" eve_db | psql -U eve_user eve_db
