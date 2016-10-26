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


# KillCounts des letzten Tages sammeln
mysql -u$dbuser -p$dbpass $dbname -B -e "INSERT INTO KR_killCount select curdate() -2, shipTypeId, count(killID) from KR_participants where isVictim = 1 and cast(kill_time as date) = curdate() -2 GROUP BY shipTypeId;"


