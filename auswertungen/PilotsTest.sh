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

# INTO OUTFILE '/www/janhkrueger/KillReports/Pilots/Titans.csv' FIELDS TERMINATED BY ',' \


# Titans
echo "# Titanpilots"
if [ -e "$OUTPATH/Pilots/Titans.csv" ]; then
        rm $OUTPATH/Pilots/Titans.csv
fi
if [ -e "$OUTPATH/Pilots/Titans.csv.xz" ]; then
        rm $OUTPATH/Pilots/Titans.csv.xz
fi

mysql -u$dbuser -p$dbpass $dbname -B -e \
"SELECT p.shipTypeID, p.characterName, u.corporationName, u.allianceName \
FROM KR_participants p, KR_characterUpdates u \
WHERE p.shipTypeID IN  (671,11567,3764,23773) AND u.characterID = p.characterID GROUP BY p.shipTypeID, p.characterName \
ORDER BY  p.characterName \
INTO OUTFILE '$OUTPATH/Pilots/Titans.csv' FIELDS TERMINATED BY ',' \
OPTIONALLY ENCLOSED BY '\"'
LINES TERMINATED BY '\n';"


echo "##########"
echo "# Ende   #"
echo "##########"
