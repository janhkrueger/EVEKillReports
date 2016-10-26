#!/bin/bash
clear

# MySQL Variablen bereitstellen
dbuser=[DBUSER]
dbpass=[PASSWORD]
dbname=[DBNAME]

JETZT="$(date +%Y-%m-%d)"
YEAR="$(date "+%Y" -d $JETZT)"
WOCHENTAG="$(date +%u)"
OUTPATH="/var/games/KillReporter/EVEData"

echo "##########"
echo "# Beginn #"
echo "##########"


echo "# Exporte der Hashes"
if [ -e "$OUTPATH/crestHashes.csv" ]; then
        rm $OUTPATH/crestHashes.csv
fi
if [ -e "$OUTPATH/crestHashes.csv.gz" ]; then
        rm $OUTPATH/crestHashes.csv.gz
fi
mysql -u$dbuser -p$dbpass $dbname -B -e "select killID, crestHash FROM KR_participantsHash WHERE collected = 1;" | sed 's/\t/";"/g;s/^/"/;s/$/"/;s/\n//g' | gzip > $OUTPATH/crestHashes.csv.gz
