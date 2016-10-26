#!/bin/bash
clear

# MySQL Variablen bereitstellen
dbuser=[DBUSER]
dbpass=[PASSWORD]
dbname=[DBNAME]

JETZT="$(date +%Y-%m-%d)"
YEAR="$(date "+%Y" -d $JETZT)"
WOCHENTAG="$(date +%u)"
OUTPATH="/var/www/html/janhkrueger.de/KillReports"

WOCHENTAG=1

echo "##########"
echo "# Beginn #"
echo "##########"


# Alle Drifter
echo "# Drifter Kills Last 7 Days"
if [ -e "$OUTPATH/Drifter/DrifterKillsLast7Days.csv" ]; then
        rm $OUTPATH/Drifter/DrifterKillsLast7Days.csv
fi
if [ -e "$OUTPATH/Drifter/DrifterKillsLast7Days.csv.xz" ]; then
        rm $OUTPATH/Drifter/DrifterKillsLast7Days.csv.xz
fi
mysql -u$dbuser -p$dbpass $dbname -B -e "select * FROM Kills_Last7Days_Drifters;" | sed 's/\t/";"/g;s/^/"/;s/$/"/;s/\n//g' > $OUTPATH/Drifter/DrifterKillsLast7Days.csv
xz $OUTPATH/Drifter/DrifterKillsLast7Days.csv


echo "# AllDrifter"
if [ -e "$OUTPATH/Drifter/AllDrifterKills.csv" ]; then
        rm $OUTPATH/Drifter/AllDrifterKills.csv
fi
if [ -e "$OUTPATH/Drifter/AllDrifterKills.csv.xz" ]; then
        rm $OUTPATH/Drifter/AllDrifterKills.csv.xz
fi
mysql -u$dbuser -p$dbpass $dbname -B -e "select * FROM AllDrifterKills;" | sed 's/\t/";"/g;s/^/"/;s/$/"/;s/\n//g' > $OUTPATH/Drifter/AllDrifterKills.csv
xz $OUTPATH/Drifter/AllDrifterKills.csv


echo "##########"
echo "# Ende   #"
echo "##########"
