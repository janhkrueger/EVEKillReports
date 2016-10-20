#! /bin/sh
echo "##################"
echo "#      Begin     #"
echo "##################"

# MySQL credentials from ~/.my.cnf
dbname=
limit=50000000

echo "# Neue CharacterIDs aufnehmen"
mysql $dbname -B -e "INSERT INTO KR_characterUpdates (characterid) SELECT distinct p.characterid FROM KR_participants p WHERE p.characterid NOT IN (select c.characterID FROM KR_characterUpdates c) limit $limit"
echo "##################"
echo "# Ende           #"
echo "##################"
