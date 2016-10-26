#!/bin/bash
clear

# MySQL Variablen bereitstellen
dbuser=[DBUSER]
dbpass=[PASSWORD]
dbname=[DBNAME]

OUTPATH="/var/www/html/janhkrueger.de/KillReports"
query=Kills_Last7Days_Marmite

echo "##########"
echo "# Beginn #"
echo "##########"


# Kills_Last7Days_Marmite.
echo "#  $query"
if [ -e "$OUTPATH/Last7Days/$query.csv" ]; then
        rm $OUTPATH/Last7Days/$query.csv
fi
if [ -e "$OUTPATH/Last7Days/$query.csv.xz" ]; then
        rm $OUTPATH/Last7Days/$query.csv.xz
fi
mysql -u$dbuser -p$dbpass $dbname -B -e "select * FROM $query;" | sed 's/\t/";"/g;s/^/"/;s/$/"/;s/\n//g' > $OUTPATH/Last7Days/$query.csv
#xz $OUTPATH/Last7Days/$query.csv


echo "##########"
echo "# Ende   #"
echo "##########"
