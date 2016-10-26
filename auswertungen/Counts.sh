#!/bin/bash
clear

# MySQL Variablen bereitstellen
dbuser=[DBUSER]
dbpass=[PASSWORD]
dbname=[DBNAME]

JETZT="$(date +%Y-%m-%d)"
YEAR="$(date "+%Y" -d $JETZT)"
WOCHENTAG="$(date +%u)"
OUTPATH="/var/www/html/janhkrueger.de/KillReports/Counts"
OUTPATH="/var/games/KillReporter/EVEData"

echo "##########"
echo "# Beginn #"
echo "##########"


echo "# Marmite"
if [ -e "$OUTPATH/Last7Days_Marmite.csv" ]; then
        rm $OUTPATH/Last7Days_Marmite.csv
fi
if [ -e "$OUTPATH/Last7Days_Marmite.csv.xz" ]; then
        rm $OUTPATH/Last7Days_Marmite.csv.xz
fi
mysql -u$dbuser -p$dbpass $dbname -B -e "select count(killID) FROM Kills_Last7Days_Marmite;" | sed 's/\t/";"/g;s/^/"/;s/$/"/;s/\n//g' > $OUTPATH/Last7Days_Marmite.csv
#xz $OUTPATH/Last7Days_Marmite.csv


echo "# Code"                                                                                                                                                                        
if [ -e "$OUTPATH/Last7Days_Code.csv" ]; then                                                                                                                                        
        rm $OUTPATH/Last7Days_Code.csv                                                                                                                                               
fi                                                                                                                                                                                      

if [ -e "$OUTPATH/Last7Days_Code.csv.xz" ]; then                                                                                                                                     
        rm $OUTPATH/Last7Days_Code.csv.xz                                                                                                                                            
fi                                                                                                                                                                                      

mysql -u$dbuser -p$dbpass $dbname -B -e "select count(killID) FROM Kills_Last7Days_Code;" | sed 's/\t/";"/g;s/^/"/;s/$/"/;s/\n//g' > $OUTPATH/Last7Days_Code.csv                  
#xz $OUTPATH/Last7Days_Code.csv                                                                               

echo "# Drifters"                                                                                                                                                                        
if [ -e "$OUTPATH/Last7Days_Drifters.csv" ]; then                                                                                                                                        
        rm $OUTPATH/Last7Days_Drifters.csv                                                                                                                                               
fi                                                                                                                                                                                      

if [ -e "$OUTPATH/Last7Days_Drifters.csv.xz" ]; then                                                                                                                                     
        rm $OUTPATH/Last7Days_Drifters.csv.xz                                                                                                                                            
fi                                                                                                                                                                                      

mysql -u$dbuser -p$dbpass $dbname -B -e "select count(killID) FROM Kills_Last7Days_Drifters;" | sed 's/\t/";"/g;s/^/"/;s/$/"/;s/\n//g' > $OUTPATH/Last7Days_Drifters.csv                  
#xz $OUTPATH/Last7Days_Drifters.csv                                                                               

echo "# CONCORD"
if [ -e "$OUTPATH/Last7Days_CONCORD.csv" ]; then
        rm $OUTPATH/Last7Days_CONCORD.csv
fi

if [ -e "$OUTPATH/Last7Days_CONCORD.csv.xz" ]; then
        rm $OUTPATH/Last7Days_CONCORD.csv.xz
fi

mysql -u$dbuser -p$dbpass $dbname -B -e "select count(killID) FROM Kills_Last7Days_CONCORD;" | sed 's/\t/";"/g;s/^/"/;s/$/"/;s/\n//g' > $OUTPATH/Last7Days_CONCORD.csv
#xz $OUTPATH/Last7Days_CONCORD.csv
