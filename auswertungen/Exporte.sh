#! /bin/bash

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

echo "####################################"
echo "# Beginn                           #"
echo "# $(date +'%d.%m.%Y %H:%M:%S:%3N') #"
echo "####################################"


# KillCounts des letzten Tages sammeln
#echo "# KillCounts erzeugen"
#mysql -u$dbuser -p$dbpass $dbname -B -e "INSERT INTO KR_killCount select curdate() -1, shipTypeId, count(killID) from KR_participants where isVictim = 1 and cast(kill_time as date) = curdate() -1 GROUP BY shipTypeId;"


# Alle Super
echo "# All Supers"
if [ -e "$OUTPATH/AllSuperCapitals.csv" ]; then
        rm $OUTPATH/AllSuperCapitals.csv
        rm $OUTPATH/AllSuperCapitals.csv
fi
if [ -e "$OUTPATH/AllSuperCapitals.csv.xz" ]; then
        rm $OUTPATH/AllSuperCapitals.csv.xz
        rm $OUTPATH/AllSuperCapitals.csv.xz
fi
mysql -u$dbuser -p$dbpass $dbname -B -e "select KR_participants.killID AS killID,KR_participants.solarSystemID AS solarSystemID,KR_participants.kill_time AS kill_time,KR_participants.isVictim AS isVictim,KR_participants.shipTypeID AS shipTypeID,KR_participants.damage AS damage,KR_participants.characterID AS characterID,KR_participants.characterName AS characterName,KR_participants.corporationID AS corporationID,KR_participants.corporationName AS corporationName,KR_participants.allianceID AS allianceID,KR_participants.allianceName AS allianceName,KR_participants.factionID AS factionID,KR_participants.factionName AS factionName,KR_participants.finalBlow AS finalBlow,KR_participants.weaponTypeID AS weaponTypeID,KR_participants.points AS points,KR_participants.totalValue AS totalValue from KR_participants where (KR_participants.shipTypeID in (23919,22852,23913,3514,23917,671,11567,3764,23773)) order by KR_participants.kill_time;" | sed 's/\t/";"/g;s/^/"/;s/$/"/;s/\n//g' > $OUTPATH/AllSuperCapitals.csv
xz $OUTPATH/AllSuperCapitals.csv


echo "# All Dread"
if [ -e "$OUTPATH/AllDread.csv" ]; then
        rm $OUTPATH/AllDread.csv
fi
if [ -e "$OUTPATH/AllDread.csv.xz" ]; then
        rm $OUTPATH/AllDread.csv.xz
fi
mysql -u$dbuser -p$dbpass $dbname -B -e "select KR_participants.killID AS killID,KR_participants.solarSystemID AS solarSystemID,KR_participants.kill_time AS kill_time,KR_participants.isVictim AS isVictim,KR_participants.shipTypeID AS shipTypeID,KR_participants.damage AS damage,KR_participants.characterID AS characterID,KR_participants.characterName AS characterName,KR_participants.corporationID AS corporationID,KR_participants.corporationName AS corporationName,KR_participants.allianceID AS allianceID,KR_participants.allianceName AS allianceName,KR_participants.factionID AS factionID,KR_participants.factionName AS factionName,KR_participants.finalBlow AS finalBlow,KR_participants.weaponTypeID AS weaponTypeID,KR_participants.points AS points,KR_participants.totalValue AS totalValue from KR_participants where (KR_participants.shipTypeID in (19724,19722,19726,19720));" | sed 's/\t/";"/g;s/^/"/;s/$/"/;s/\n//g' > $OUTPATH/AllDread.csv
xz $OUTPATH/AllDread.csv

echo "# All Carrier"
if [ -e "$OUTPATH/AllCarrier.csv" ]; then
        rm $OUTPATH/AllCarrier.csv
fi
if [ -e "$OUTPATH/AllCarrier.csv.xz" ]; then
        rm $OUTPATH/AllCarrier.csv.xz
fi
mysql -u$dbuser -p$dbpass $dbname -B -e "select KR_participants.killID AS killID,KR_participants.solarSystemID AS solarSystemID,KR_participants.kill_time AS kill_time,KR_participants.isVictim AS isVictim,KR_participants.shipTypeID AS shipTypeID,KR_participants.damage AS damage,KR_participants.characterID AS characterID,KR_participants.characterName AS characterName,KR_participants.corporationID AS corporationID,KR_participants.corporationName AS corporationName,KR_participants.allianceID AS allianceID,KR_participants.allianceName AS allianceName,KR_participants.factionID AS factionID,KR_participants.factionName AS factionName,KR_participants.finalBlow AS finalBlow,KR_participants.weaponTypeID AS weaponTypeID,KR_participants.points AS points,KR_participants.totalValue AS totalValue from KR_participants where (KR_participants.shipTypeID in (23757,23915,23911,24483));" | sed 's/\t/";"/g;s/^/"/;s/$/"/;s/\n//g' > $OUTPATH/AllCarrier.csv
xz $OUTPATH/AllCarrier.csv

# Capitals Per Year
#if [ "$WOCHENTAG=" == 1 ]; then
	echo "# Capitals per Year"
	rm $OUTPATH/PerYear*.csv.xz
	mysql -u$dbuser -p$dbpass $dbname -B -e "select year(KR_participants.kill_time),count(KR_participants.killID)  from KR_participants where KR_participants.shipTypeID in (23757,23915,23911,24483) and KR_participants.isVictim = 1 group by year(KR_participants.kill_time);" | sed 's/\t/";"/g;s/^/"/;s/$/"/;s/\n//g' > $OUTPATH/PerYearCarrier.csv
	xz $OUTPATH/PerYearCarrier.csv
	mysql -u$dbuser -p$dbpass $dbname -B -e "select year(KR_participants.kill_time),count(KR_participants.killID)  from KR_participants where KR_participants.shipTypeID in (23919,22852,23913,3514,23917) and KR_participants.isVictim = 1 group by year(KR_participants.kill_time);" | sed 's/\t/";"/g;s/^/"/;s/$/"/;s/\n//g' > $OUTPATH/PerYearSupercarrier.csv
	xz $OUTPATH/PerYearSupercarrier.csv
	mysql -u$dbuser -p$dbpass $dbname -B -e "select year(KR_participants.kill_time),count(KR_participants.killID)  from KR_participants where KR_participants.shipTypeID in (19724,19722,19726,19720) and KR_participants.isVictim = 1 group by year(KR_participants.kill_time);" | sed 's/\t/";"/g;s/^/"/;s/$/"/;s/\n//g' > $OUTPATH/PerYearDreads.csv
	xz $OUTPATH/PerYearDreads.csv
	mysql -u$dbuser -p$dbpass $dbname -B -e "select year(KR_participants.kill_time),count(KR_participants.killID)  from KR_participants where KR_participants.shipTypeID in (671,11567,3764,23773) and KR_participants.isVictim = 1 group by year(KR_participants.kill_time);" | sed 's/\t/";"/g;s/^/"/;s/$/"/;s/\n//g' > $OUTPATH/PerYearTitan.csv
	xz $OUTPATH/PerYearTitan.csv
#fi

# Export der Revenant-Sichtungen
#if [ "$WOCHENTAG=" == 1 ]; then
	echo "# Revenants ermitteln"
	rm $OUTPATH/Revenant.csv.gz
	mysql -u$dbuser -p$dbpass $dbname -B -e "select KR_participants.killID AS killID,KR_participants.solarSystemID AS solarSystemID,KR_participants.kill_time AS kill_time,KR_participants.isVictim AS isVictim,KR_participants.shipTypeID AS shipTypeID,KR_participants.damage AS damage,KR_participants.characterID AS characterID,KR_participants.characterName AS characterName,KR_participants.corporationID AS corporationID,KR_participants.corporationName AS corporationName,KR_participants.allianceID AS allianceID,KR_participants.allianceName AS allianceName,KR_participants.factionID AS factionID,KR_participants.factionName AS factionName,KR_participants.finalBlow AS finalBlow,KR_participants.weaponTypeID AS weaponTypeID,KR_participants.points AS points,KR_participants.totalValue AS totalValue from KR_participants where (KR_participants.shipTypeID = 3514) order by KR_participants.kill_time;" | sed 's/\t/";"/g;s/^/"/;s/$/"/;s/\n//g' | gzip > $OUTPATH/Revenant.csv.gz
#fi

# GoldenPod-Sichtungen
#if [ "$WOCHENTAG=" == 1 ]; then
	echo "# Goldene Eier auswerten"
	rm $OUTPATH/GoldenPodYear.csv.xz
	rm $OUTPATH/GoldenPodYearMonth.csv.xz
	mysql -u$dbuser -p$dbpass $dbname -B -e "select KR_participants.killID AS killID,KR_participants.solarSystemID AS solarSystemID,KR_participants.kill_time AS kill_time,KR_participants.isVictim AS isVictim,KR_participants.shipTypeID AS shipTypeID,KR_participants.damage AS damage,KR_participants.characterID AS characterID,KR_participants.characterName AS characterName,KR_participants.corporationID AS corporationID,KR_participants.corporationName AS corporationName,KR_participants.allianceID AS allianceID,KR_participants.allianceName AS allianceName,KR_participants.factionID AS factionID,KR_participants.factionName AS factionName,KR_participants.finalBlow AS finalBlow,KR_participants.weaponTypeID AS weaponTypeID,KR_participants.points AS points,KR_participants.totalValue AS totalValue from KR_participants where (KR_participants.shipTypeID = 33328) order by KR_participants.kill_time;" | sed 's/\t/";"/g;s/^/"/;s/$/"/;s/\n//g' > $OUTPATH/GoldenPodYear.csv
	mysql -u$dbuser -p$dbpass $dbname -B -e "select year(KR_participants.kill_time) AS 'YEAR(kill_time)', month(KR_participants.kill_time) AS 'MONTH(kill_time)', count(KR_participants.killID) AS 'count(KillID)' from KR_participants where (KR_participants.shipTypeID = 33328) group by year(KR_participants.kill_time),month(KR_participants.kill_time);" | sed 's/\t/";"/g;s/^/"/;s/$/"/;s/\n//g' > $OUTPATH/GoldenPodYearMonth.csv
	xz $OUTPATH/*.csv
#fi

#if [ "$WOCHENTAG=" == 1 ]; then
	echo "# Export der Carrier"
	for ((i=2007; i <= $YEAR; i++)) ; do
		rm $OUTPATH/Carrier_$i.csv.xz
		rm $OUTPATH/Carrier_$i.csv.gz
		mysql -u$dbuser -p$dbpass $dbname -B -e "select * FROM KR_participants WHERE shipTypeID in (23757,23915,23911,24483) AND YEAR(kill_time) = $i ORDER BY kill_time;" | sed 's/\t/";"/g;s/^/"/;s/$/"/;s/\n//g' | gzip > $OUTPATH/Carrier/Carrier_$i.csv.gz
	done
#fi

#if [ "$WOCHENTAG=" == 1 ]; then
	echo "# Export der Dreads"
	for ((i=2007; i <= $YEAR; i++)) ; do
		rm $OUTPATH/Dreadnoughts/Dreadnoughts_$i.csv.gz
		mysql -u$dbuser -p$dbpass $dbname -B -e "select * FROM KR_participants WHERE shipTypeID in (19724,19722,19726,19720) AND YEAR(kill_time) = $i ORDER BY kill_time;" | sed 's/\t/";"/g;s/^/"/;s/$/"/;s/\n//g' | gzip > $OUTPATH/Dreadnoughts/Dreadnoughts_$i.csv.gz
	done
#fi

#if [ "$WOCHENTAG=" == 1 ]; then
	echo "# Export der Supercarrier"
	for ((i=2007; i <= $YEAR; i++)) ; do
		rm $OUTPATH/SuperCarrier/SuperCarrier_$i.csv.xz
		mysql -u$dbuser -p$dbpass $dbname -B -e "select * FROM KR_participants WHERE shipTypeID in (23919, 22852, 23913, 3514, 23917) AND YEAR(kill_time) = $i ORDER BY kill_time ASC;" | sed 's/\t/";"/g;s/^/"/;s/$/"/;s/\n//g' > $OUTPATH/SuperCarrier/SuperCarrier_$i.csv
		xz $OUTPATH/SuperCarrier/*.csv
	done
#fi

# Titans
#if [ "$WOCHENTAG=" == 1 ]; then
	echo "# Export der Titanen"
	for ((i=2007; i <= $YEAR; i++)) ; do
		rm $OUTPATH/Titanen/Titanen_$i.csv.xz
		mysql -u$dbuser -p$dbpass $dbname -B -e "select * FROM KR_participants WHERE shipTypeID in (671,11567,3764,23773) AND YEAR(kill_time) = $i ORDER BY kill_time;" | sed 's/\t/";"/g;s/^/"/;s/$/"/;s/\n//g' > $OUTPATH/Titanen/Titanen_$i.csv
		xz $OUTPATH/Titanen/*.csv
	done
#fi

echo "# Alle CharacterIDs ausgeben"
if [ -e "$OUTPATH/characters.csv.gz" ]; then
        rm $OUTPATH/characters.csv.gz
fi

if [ -e "$OUTPATH/characters.csv" ]; then
        rm $OUTPATH/characters.csv
fi
mysql -u$dbuser -p$dbpass $dbname -B -e "select * from KR_characterUpdates WHERE lastUpdate IS NOT NULL AND lastUpdate != '2099-01-01' ORDER BY characterID;" | sed 's/\t/";"/g;s/^/"/;s/$/"/;s/\n//g' | gzip > $OUTPATH/characters.csv.gz

# Alle Drifter
echo "# Drifter Kills Last 7 Days"
if [ -e "$OUTPATH/Drifter/DrifterKillsLast7Days.csv" ]; then
        rm $OUTPATH/Drifter/DrifterKillsLast7Days.csv
fi
if [ -e "$OUTPATH/Drifter/DrifterKillsLast7Days.csv.xz" ]; then
        rm $OUTPATH/Drifter/DrifterKillsLast7Days.csv.xz
fi
mysql -u$dbuser -p$dbpass $dbname -B -e "select p1.killID AS killID,p1.solarSystemID AS solarSystemID,p1.kill_time AS kill_time,p1.isVictim AS isVictim,p1.shipTypeID AS shipTypeID,p1.damage AS damage,p1.characterID AS characterID,p1.characterName AS characterName,p1.corporationID AS corporationID,p1.corporationName AS corporationName,p1.allianceID AS allianceID,p1.allianceName AS allianceName,p1.factionID AS factionID,p1.factionName AS factionName,p1.finalBlow AS finalBlow,p1.weaponTypeID AS weaponTypeID,p1.points AS points,p1.totalValue AS totalValue from KR_participants p1 where ((p1.kill_time <= now()) and (p1.kill_time >= (cast(now() as date) - interval 7 day)) and (p1.isVictim = 1) and p1.killID in (select p2.killID from KR_participants p2 where ((p2.characterID in (3019581,3019582,3019583,3019584)) and (p2.kill_time <= now()) and (p2.kill_time >= (cast(now() as date) - interval 7 day)) and (p2.finalBlow = 1)))) order by p1.kill_time;" | sed 's/\t/";"/g;s/^/"/;s/$/"/;s/\n//g' > $OUTPATH/Drifter/DrifterKillsLast7Days.csv
xz $OUTPATH/Drifter/DrifterKillsLast7Days.csv


echo "# AllDrifter"
if [ -e "$OUTPATH/Drifter/AllDrifterKills.csv" ]; then
        rm $OUTPATH/Drifter/AllDrifterKills.csv
fi
if [ -e "$OUTPATH/Drifter/AllDrifterKills.csv.xz" ]; then
        rm $OUTPATH/Drifter/AllDrifterKills.csv.xz
fi
mysql -u$dbuser -p$dbpass $dbname -B -e "select p1.killID AS killID,p1.solarSystemID AS solarSystemID,p1.kill_time AS kill_time,p1.isVictim AS isVictim,p1.shipTypeID AS shipTypeID,p1.damage AS damage,p1.characterID AS characterID,p1.characterName AS characterName,p1.corporationID AS corporationID,p1.corporationName AS corporationName,p1.allianceID AS allianceID,p1.allianceName AS allianceName,p1.factionID AS factionID,p1.factionName AS factionName,p1.finalBlow AS finalBlow,p1.weaponTypeID AS weaponTypeID,p1.points AS points,p1.totalValue AS totalValue from KR_participants p1 where ((p1.isVictim = 1) and p1.killID in (select p2.killID from KR_participants p2 where ((p2.characterID in (3019581,3019582)) and (p2.finalBlow = 1)))) order by p1.kill_time;" | sed 's/\t/";"/g;s/^/"/;s/$/"/;s/\n//g' > $OUTPATH/Drifter/AllDrifterKills.csv
xz $OUTPATH/Drifter/AllDrifterKills.csv


echo "# DrifterKillsByShipGroup"
if [ -e "$OUTPATH/Drifter/DrifterKillsByShipGroup.csv" ]; then
        rm $OUTPATH/Drifter/DrifterKillsByShipGroup.csv
fi
if [ -e "$OUTPATH/Drifter/DrifterKillsByShipGroup.csv.xz" ]; then
        rm $OUTPATH/Drifter/DrifterKillsByShipGroup.csv.xz
fi
mysql -u$dbuser -p$dbpass $dbname -B -e "select ig.groupName AS ShipClass,count(p1.killID) AS sumships from ((KR_participants p1 join invTypes it) join invGroups ig) where ((p1.isVictim = 1) and p1.killID in (select p2.killID from KR_participants p2 where ((p2.shipTypeID in (34495,34561)) and (p2.finalBlow = 1))) and (it.typeID = p1.shipTypeID) and (ig.groupID = it.groupID)) group by ig.groupName;" | sed 's/\t/";"/g;s/^/"/;s/$/"/;s/\n//g' > $OUTPATH/Drifter/DrifterKillsByShipGroup.csv
xz $OUTPATH/Drifter/DrifterKillsByShipGroup.csv


echo "# Last7Days Gnosis"
sh ./Last7DaysLosses_Gnosis.sh

echo "# Last7Days Carrier"
sh ./Last7DaysLosses_Carrier.sh

echo "# Last7Days Dreads"
sh ./Last7DaysLosses_Dread.sh

echo "# Last7Days Exhumer"
sh ./Last7DaysLosses_Exhumer.sh

echo "# Last7Days Freighter"
sh ./Last7DaysLosses_Freighter.sh

echo "# Last7Days Mobiles"
sh ./Last7DaysLosses_Mobiles.sh

echo "# Last7Days SuperCapitals"
sh ./Last7DaysLosses_SuperCapitals.sh

echo "# Last7Days Titans"
sh ./Last7DaysLosses_Titans.sh

echo "##############"
echo "# KillCounts #"
echo "##############"

echo "# Last7Days CONCORD"
sh ./Kills_Last7Days_CONCORD.sh

echo "# Last7Days CODE"
sh ./Kills_Last7Days_CODE.sh

echo "# Last7Days Marmite"
sh ./Kills_Last7Days_Marmite.sh

echo "# KillCounts"
sh ./Counts.sh

echo "# Wars"
sh ./Wars.sh

echo "# Pilots"
sh ./Pilots.sh

echo "# Datenbank"
sh ./dbExport.sh

echo "# Export der Hashes"
sh ./crestHash.sh

echo "# Sync nach GDrive"
/var/games/KillReporter/gdrivesync.sh



echo "####################################"
echo "# Ende                             #"
echo "# $(date +'%d.%m.%Y %H:%M:%S:%3N') #"
echo "####################################"
