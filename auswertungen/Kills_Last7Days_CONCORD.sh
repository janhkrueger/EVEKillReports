#!/bin/bash
clear

# MySQL Variablen bereitstellen
dbuser=[DBUSER]
dbpass=[PASSWORD]
dbname=[DBNAME]

OUTPATH="/var/www/html/janhkrueger.de/KillReports"

echo "##########"
echo "# Beginn #"
echo "##########"


# Kills_Last7Days_CONCORD
echo "# Kills_Last7Days_CONCORD.sh "
if [ -e "$OUTPATH/Last7Days/Kills_Last7Days_CONCORD.csv" ]; then
        rm $OUTPATH/Last7Days/Kills_Last7Days_CONCORD.csv
fi
if [ -e "$OUTPATH/Last7Days/Kills_Last7Days_CONCORD.csv.xz" ]; then
        rm $OUTPATH/Last7Days/Kills_Last7Days_CONCORD.csv.xz
fi
mysql -u$dbuser -p$dbpass $dbname -B -e "select * FROM Kills_Last7Days_CONCORD;" | sed 's/\t/";"/g;s/^/"/;s/$/"/;s/\n//g' > $OUTPATH/Last7Days/Kills_Last7Days_CONCORD.csv
#xz $OUTPATH/Last7Days/Kills_Last7Days_CONCORD.csv


echo "##########"
echo "# Ende   #"
echo "##########"
