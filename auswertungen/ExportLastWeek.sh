#!/bin/bash
echo "##################"
echo "#      Begin     #"
echo "##################"

echo '# Calculate  Parameters'
JETZT="$(date +%Y-%m-%d)"
JETZT=2015-09-07
LASTWEEKSTART=`date "+%Y-%m-%d" -d "$JETZT 7 days ago" |awk '{print $1}'`
LASTWEEKEND=`date "+%Y-%m-%d" -d "$JETZT 1 days ago" |awk '{print $1}'`

KW="$(date +%V -d $LASTWEEKSTART)"
YEAR="$(date "+%Y" -d $LASTWEEKSTART)"

OUTPATH="/var/www/vhosts/lvps87-230-26-186.dedicated.hosteurope.de/janhkrueger/KillReports"
BASICPATH="/var/games/KillReporter"
WORKPATH=$OUTPATH/$YEAR/

echo '# Parameters: '$LASTWEEKSTART $LASTWEEKEND $JETZT

echo '################## Capitals'
echo '# Query Carriers'
cd $BASICPATH
FILENAME=Carrier_KW$KW.csv
rm $WORKPATH$FILENAME.xz
mysql -u[DBUSER] -p[PASSWORD] [DBNAME] -B -e "SELECT * FROM KR_participants WHERE kill_time >= '$LASTWEEKSTART' AND kill_time <= '$LASTWEEKEND' AND shipTypeID in (23757,23915,23911,24483);" | sed 's/\t/";"/g;s/^/"/;s/$/"/;s/\n//g' > $WORKPATH/$FILENAME

cd $WORKPATH
xz *.csv

echo '# Query Dreadnoughts'
cd $BASICPATH
FILENAME=Dreads_KW$KW.csv
rm $WORKPATH$FILENAME.xz
mysql -u[DBUSER] -p[PASSWORD] [DBNAME] -B -e "SELECT * FROM KR_participants WHERE kill_time >= '$LASTWEEKSTART' AND kill_time <= '$LASTWEEKEND' AND shipTypeID in (19724,19722,19726,19720);" | sed 's/\t/";"/g;s/^/"/;s/$/"/;s/\n//g' > $WORKPATH/$FILENAME
cd $WORKPATH
xz *.csv

echo '# Query Supercarrier'
cd $BASICPATH
FILENAME=SuperCarrier_KW$KW.csv
rm $WORKPATH$FILENAME.xz
mysql -u[DBUSER] -p[PASSWORD] [DBNAME] -B -e "SELECT * FROM KR_participants WHERE kill_time >= '$LASTWEEKSTART' AND kill_time <= '$LASTWEEKEND' AND shipTypeID in (23919,22852,23913,3514,23917);" | sed 's/\t/";"/g;s/^/"/;s/$/"/;s/\n//g' > $WORKPATH/$FILENAME
cd $WORKPATH
xz *.csv

echo '# Query Titans'
cd $BASICPATH
FILENAME=Titanen_KW$KW.csv
rm $WORKPATH$FILENAME.xz
mysql -u[DBUSER] -p[PASSWORD] [DBNAME] -B -e "SELECT * FROM KR_participants WHERE kill_time >= '$LASTWEEKSTART' AND kill_time <= '$LASTWEEKEND' AND shipTypeID in (671,11567,3764,23773);" | sed 's/\t/";"/g;s/^/"/;s/$/"/;s/\n//g' > $WORKPATH/$FILENAME
cd $WORKPATH
xz *.csv

echo "##################"
echo "#      End       #"
echo "##################"
