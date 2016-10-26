#!/bin/bash

# MySQL Variablen bereitstellen
dbuser=
dbpass=
dbname=

# Alle CCPler
mysql -u$dbuser -p$dbpass $dbname -B -e "INSERT INTO KR_characterUpdatesPrio SELECT characterID FROM KR_characterUpdates WHERE corporationID IN (775755743);"
