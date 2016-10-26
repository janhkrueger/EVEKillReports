#!/bin/bash
echo "##################"
echo "#      Begin     #"
echo "##################"

mysql -u[DBUSER] -p[PASSWORD] [DBNAME] -B -e "SELECT characterID, characterName FROM KR_participants;" | sed 's/\t/";"/g;s/^/"/;s/$/"/;s/\n//g' > chars.csv
