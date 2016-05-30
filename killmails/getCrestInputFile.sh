clear
# MySQL Variablen bereitstellen
dbuser=
dbpass=
dbname=

echo "####################################"
echo "# Beginn                           #"
echo "# $(date +'%d.%m.%Y %H:%M:%S:%3N')          #"
echo "####################################"

# Alle zu betrachtenden Schiffstypen des Jahres 2008
#mysql -u$dbuser -p$dbpass $dbname -B -e "select distinct p.killID from KR_participantsOld PARTITION (p2008) p, KR_participantsToCollect pTC, invGroups iG, invTypes iT, KR_participantsHash h where p.isVictim = 1 and p.killID = h.killID and p.shipTypeID = iT.typeID and iT.groupID = iG.groupID and iG.groupName = pTC.shipGroupName AND ( h.crestHash IS NULL OR h.crestHash NOT IN (0,1));"  > crest2008.txt

# Alle zu betrachtenden Schiffstypen des Jahres 2009
#mysql -u$dbuser -p$dbpass $dbname -B -e "select distinct p.killID from KR_participantsOld PARTITION (p2009) p, KR_participantsToCollect pTC, invGroups iG, invTypes iT, KR_participantsHash h where p.isVictim = 1 and p.killID = h.killID and p.shipTypeID = iT.typeID and iT.groupID = iG.groupID and iG.groupName = pTC.shipGroupName AND ( h.crestHash IS NULL OR h.crestHash NOT IN (0,1)) ORDER BY p.killID ASC;"  > crest2009.txt


# Alle zu betrachtenden Schiffstypen des Jahres 2010
#mysql -u$dbuser -p$dbpass $dbname -B -e "select distinct p.killID from KR_participantsOld PARTITION (p2010) p, KR_participantsToCollect pTC, invGroups iG, invTypes iT, KR_participantsHash h where p.isVictim = 1 and p.killID = h.killID and p.shipTypeID = iT.typeID and iT.groupID = iG.groupID and iG.groupName = pTC.shipGroupName AND ( h.crestHash IS NULL OR h.crestHash NOT IN (0,1));"  > crest2010.txt

# Alle zu betrachtenden Schiffstypen des Jahres 2011
#mysql -u$dbuser -p$dbpass $dbname -B -e "select distinct p.killID from KR_participantsOld PARTITION (p2011) p, KR_participantsToCollect pTC, invGroups iG, invTypes iT, KR_participantsHash h where p.isVictim = 1 and p.killID = h.killID and p.shipTypeID = iT.typeID and iT.groupID = iG.groupID and iG.groupName = pTC.shipGroupName AND ( h.crestHash IS NULL OR h.crestHash NOT IN (0,1));"  > crest2011.txt

# Alle zu betrachtenden Schiffstypen des Jahres 2012
#mysql -u$dbuser -p$dbpass $dbname -B -e "select distinct p.killID from KR_participantsOld PARTITION (p2012) p, KR_participantsToCollect pTC, invGroups iG, invTypes iT, KR_participantsHash h where p.isVictim = 1 and p.killID = h.killID and p.shipTypeID = iT.typeID and iT.groupID = iG.groupID and iG.groupName = pTC.shipGroupName AND ( h.crestHash IS NULL OR h.crestHash NOT IN (0,1));"  > crest2012.txt

# Alle zu betrachtenden Schiffstypen des Jahres 2013
#mysql -u$dbuser -p$dbpass $dbname -B -e "select distinct p.killID from KR_participantsOld PARTITION (p2013) p, KR_participantsToCollect pTC, invGroups iG, invTypes iT, KR_participantsHash h where p.isVictim = 1 and p.killID = h.killID and p.shipTypeID = iT.typeID and iT.groupID = iG.groupID and iG.groupName = pTC.shipGroupName AND ( h.crestHash IS NULL OR h.crestHash NOT IN (0,1));"  > crest2013.txt

# Alle zu betrachtenden Schiffstypen des Jahres 2014
#mysql -u$dbuser -p$dbpass $dbname -B -e "select distinct p.killID from KR_participantsOld PARTITION (p2014) p, KR_participantsToCollect pTC, invGroups iG, invTypes iT, KR_participantsHash h where p.isVictim = 1 and p.killID = h.killID and p.shipTypeID = iT.typeID and iT.groupID = iG.groupID and iG.groupName = pTC.shipGroupName AND ( h.crestHash IS NULL OR h.crestHash NOT IN (0,1));"  > crest2014.txt

# Alle zu betrachtenden Schiffstypen des Jahres 2015
mysql -u$dbuser -p$dbpass $dbname -B -e "select distinct p.killID from KR_participantsOld PARTITION (p2015) p, KR_participantsToCollect pTC, invGroups iG, invTypes iT, KR_participantsHash h where p.isVictim = 1 and p.killID = h.killID and p.shipTypeID = iT.typeID and iT.groupID = iG.groupID and iG.groupName = pTC.shipGroupName AND ( h.crestHash IS NULL OR h.crestHash NOT IN (0,1)) ORDER BY p.killID ASC;"  > crest2015.txt

# Alle offenen des Jahres 2014
#mysql -u$dbuser -p$dbpass $dbname -B -e "select distinct p.killID from KR_participantsOld PARTITION (p2014) p, KR_participantsHash h where p.isVictim = 1 and p.killID = h.killID AND ( h.crestHash IS NULL OR h.crestHash NOT IN (0,1));"  > crest2014.txt

# Alle offenen des Jahres 2015
#mysql -u$dbuser -p$dbpass $dbname -B -e "select distinct p.killID from KR_participantsOld PARTITION (p2015) p, KR_participantsHash h where p.isVictim = 1 and p.killID = h.killID AND ( h.crestHash IS NULL OR h.crestHash NOT IN (0,1));"  > crest2014.txt

# mysql -u$dbuser -p$dbpass $dbname -B -e "select p.killID from KR_participantsOld p, KR_participantsToCollect pTC, invGroups iG, invTypes iT, KR_participantsHash h where p.isVictim = 1 and p.killID = h.killID and p.shipTypeID = iT.typeID and iT.groupID = iG.groupID and iG.groupName = pTC.shipGroupName AND h.crestHash IS NULL;"  > crest.txt

# mysql -u$dbuser -p$dbpass $dbname -B -e "select p.killID from KR_participantsOld PARTITION (p2007, p2008, p2008, p2009, p2010, p2011, p2012, p2013, p2014, p2015) p, KR_participantsToCollect pTC, invGroups iG, invTypes iT, KR_participantsHash h where p.isVictim = 1 and p.killID = h.killID and p.shipTypeID = iT.typeID and iT.groupID = iG.groupID and iG.groupName = pTC.shipGroupName AND p.killID = h.killID AND (h.crestHash IS NULL OR h.collected NOT IN (0,1) );"  > crest.txt
#mysql -u$dbuser -p$dbpass $dbname -B -e "select p.killID from KR_participantsOld PARTITION (p2007, p2008, p2009, p2010, p2011, p2012, p2013, p2014, p2015) p, KR_participantsToCollect pTC, invGroups iG, invTypes iT, KR_participantsHash h where p.isVictim = 1 and p.killID = h.killID and p.shipTypeID = iT.typeID and iT.groupID = iG.groupID and iG.groupName = pTC.shipGroupName AND p.killID = h.killID AND (h.crestHash IS NULL OR h.collected NOT IN (0,1) );"  > crest.txt


echo "####################################"
echo "# Ende                             #"
echo "# $(date +'%d.%m.%Y %H:%M:%S:%3N')          #"
echo "####################################"


