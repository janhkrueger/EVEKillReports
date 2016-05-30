clear
# MySQL Variablen bereitstellen
dbuser=
dbpass=
dbname=

echo "####################################"
echo "# Beginn                           #"
echo "# $(date +'%d.%m.%Y %H:%M:%S:%3N')          #"
echo "####################################"


#mysql -u$dbuser -p$dbpass $dbname -B -e "select distinct p.killID from KR_participantsOld PARTITION (p2013) p, KR_participantsToCollect pTC, invGroups iG, invTypes iT, KR_participantsHash h where p.isVictim = 1 and p.killID = h.killID and p.shipTypeID = iT.typeID and iT.groupID = iG.groupID and iG.groupName = pTC.shipGroupName AND h.crestHash IS NOT NULL;"  > input.txt

# mysql -u$dbuser -p$dbpass $dbname -B -e "select distinct p.killID from KR_participantsOld PARTITION (p2007, p2008, p2009, p2010, p2011, p2012, p2013) p join KR_participantsToCollect pTC join invGroups iG join invTypes iT where p.isVictim = 1 and p.shipTypeID = iT.typeID and iT.groupID = iG.groupID and iG.groupName = pTC.shipGroupName ORDER BY p.killID ASC;" > input.txt

#
## Nur die Eintraege mit gefuelltem CrestHash
#
mysql -u$dbuser -p$dbpass $dbname -N -B -e "select distinct p.killID from KR_participantsOld PARTITION (p2014, p2015) p join KR_participantsToCollect pTC join invGroups iG join invTypes iT join KR_participantsHash h where p.isVictim = 1 AND h.crestHash IS NOT NULL AND h.killID = p.killID and p.shipTypeID = iT.typeID and iT.groupID = iG.groupID and iG.groupName = pTC.shipGroupName ORDER BY p.killID ASC;" > input.txt

# Alle Revenants
#mysql -u$dbuser -p$dbpass $dbname -N -B -e "SELECT distinct killID FROM KR_participantsOld WHERE shipTypeID = 3514;" > input.txt

# mysql -u$dbuser -p$dbpass $dbname -B -e "select distinct p.killID from KR_participantsOld PARTITION (p2014, p2015) p join KR_participantsToCollect pTC join invGroups iG join invTypes iT where p.isVictim = 1 and p.shipTypeID = iT.typeID and iT.groupID = iG.groupID and iG.groupName = pTC.shipGroupName ORDER BY p.killID ASC;" > input.txt

#mysql -u$dbuser -p$dbpass $dbname -B -e "select p.killID from KR_participantsOld PARTITION (p2008, p2009) p join KR_participantsToCollect pTC join invGroups iG join invTypes iT join KR_participantsHash h where p.isVictim = 1 and p.shipTypeID = iT.typeID and iT.groupID = iG.groupID and iG.groupName = pTC.shipGroupName and h.killID = p.killID AND (h.crestHash IS NULL OR h.collected IN (0,1) ) ORDER BY p.killID ASC;" > input.txt

# Get all Piracte Faction Battleships
# mysql -u$dbuser -p$dbpass $dbname -B -e "select distinct p.killID from KR_participantsOld PARTITION (p2007, p2008, p2009, p2010, p2011, p2012, p2013, p2014, p2015, p2016) p where p.isVictim = 1 and p.shipTypeID IN (33472, 17736, 17918, 34151, 17738, 17920, 33820, 17740) ORDER BY p.killID DESC;" > input.txt

# Get all Interceptors
# mysql -u$dbuser -p$dbpass $dbname -B -e "select distinct p.killID from KR_participantsOld PARTITION (p2016) p, invGroups iG, invTypes iT where p.isVictim = 1 and p.shipTypeID = iT.typeID and iT.groupID = iG.groupID and iG.groupName = 'Interceptor' ORDER BY p.killID DESC;" > input.txt

# Alle aus 2008, 2009
#mysql -u$dbuser -p$dbpass $dbname -B -e "SELECT distinct killID FROM KR_participantsOld PARTITION (p2008, p2009) WHERE isVictim =1 ORDER BY killID ASC;" > input.txt

echo "####################################"
echo "# Ende                             #"
echo "# $(date +'%d.%m.%Y %H:%M:%S:%3N')          #"
echo "####################################"


