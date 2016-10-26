#!/bin/bash
clear

# MySQL Variablen bereitstellen
dbuser=[DBUSER]
dbpass=[PASSWORD]
dbname=[DBNAME]

JETZT="$(date +%Y-%m-%d)"
YEAR="$(date "+%Y" -d $JETZT)"
WOCHENTAG="$(date +%u)"
OUTPATH="/var/www/html/janhkrueger.de/KillReports/BurnJita2014"

WOCHENTAG=1

echo "##########"
echo "# Beginn #"
echo "##########"


# Alle GesamtDaten
if [ -e "$OUTPATH/BurnJita2014.csv" ]; then
        rm $OUTPATH/BurnJita2014.csv
fi
if [ -e "$OUTPATH/BurnJita2014.csv.xz" ]; then
        rm $OUTPATH/BurnJita2014.csv.xz
fi
mysql -u$dbuser -p$dbpass $dbname -B -e "select * FROM BurnJita2014;" | sed 's/\t/";"/g;s/^/"/;s/$/"/;s/\n//g' > $OUTPATH/BurnJita2014.csv
xz $OUTPATH/BurnJita2014.csv

mysql -u$dbuser -p$dbpass $dbname -B -e "select * FROM BurnJita2014_Killers;" | sed 's/\t/";"/g;s/^/"/;s/$/"/;s/\n//g' > $OUTPATH/BurnJita2014_Killers.csv
xz $OUTPATH/BurnJita2014_Killers.csv


mysql -u$dbuser -p$dbpass $dbname -B -e "select * FROM BurnJita2014_KillersTop;" | sed 's/\t/";"/g;s/^/"/;s/$/"/;s/\n//g' > $OUTPATH/BurnJita2014_KillersTop.csv
xz $OUTPATH/BurnJita2014_KillersTop.csv

mysql -u$dbuser -p$dbpass $dbname -B -e "select * FROM BurnJita2014_RepeatCustomers;" | sed 's/\t/";"/g;s/^/"/;s/$/"/;s/\n//g' > $OUTPATH/BurnJita2014_RepeatCustomers.csv
xz $OUTPATH/BurnJita2014_RepeatCustomers.csv

mysql -u$dbuser -p$dbpass $dbname -B -e "select * FROM BurnJita2014_LossesPerShipType;" | sed 's/\t/";"/g;s/^/"/;s/$/"/;s/\n//g' > $OUTPATH/BurnJita2014_LossesPerShipType.csv
xz $OUTPATH/BurnJita2014_LossesPerShipType.csv

echo "##########"
echo "# Ende   #"
echo "##########"
