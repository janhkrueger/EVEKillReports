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

WOCHENTAG=1

echo "##########"
echo "# Beginn #"
echo "##########"


# Last7Days_Dread
echo "# Last7Days_Dread Losses Last 7 Days"
if [ -e "$OUTPATH/Last7Days/Last7Days_Dread_Losses.csv" ]; then
        rm $OUTPATH/Last7Days/Last7Days_Dread_Losses.csv
fi
if [ -e "$OUTPATH/Last7Days/Last7Days_Dread_Losses.csv.xz" ]; then
        rm $OUTPATH/Last7Days/Last7Days_Dread_Losses.csv.xz
fi
mysql -u$dbuser -p$dbpass $dbname -B -e "select * FROM Last7Days_Dread;" | sed 's/\t/";"/g;s/^/"/;s/$/"/;s/\n//g' > $OUTPATH/Last7Days/Last7Days_Dread_Losses.csv
#xz $OUTPATH/Last7Days/Last7Days_Dread_Losses.csv


echo "##########"
echo "# Ende   #"
echo "##########"
