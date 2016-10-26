#!/bin/bash
clear

# MySQL Variablen bereitstellen
dbuser=
dbpass=
dbname=

JETZT="$(date +%Y-%m-%d)"
YEAR="$(date "+%Y" -d $JETZT)"
WOCHENTAG="$(date +%u)"
OUTPATH="/var/games/KillReporter/EVEData"

WOCHENTAG=1

echo "##########"
echo "# Beginn #"
echo "##########"


echo "# Wars"
if [ -e "$OUTPATH/Wars/Wars.csv" ]; then
        rm $OUTPATH/Wars/Wars.csv
fi
if [ -e "$OUTPATH/Pilots/Wars.csv.xz" ]; then
        rm $OUTPATH/Pilots/Wars.csv.xz
fi

mysql -u$dbuser -p$dbpass $dbname -B -e "SELECT * FROM KR_wars ORDER BY warID;" | sed 's/\t/";"/g;s/^/"/;s/$/"/;s/\n//g' > $OUTPATH/Wars/Wars.csv

echo "##########"
echo "# Ende   #"
echo "##########"
