#!/bin/bash
OUTPATH="/var/games/KillReporter/EVEData"
BASICPATH="/var/games/KillReporter"
WORKPATH=$OUTPATH/

FILENAME=KR_participants.sql.gz
FILENAMEHASH=KR_participantsHash.sql.gz
rm $WORKPATH/$FILENAME

mysqldump -u[DBUSER] -p[PASSWORD] [DBNAME] KR_participants  | gzip > $WORKPATH/$FILENAME
mysqldump -u[DBUSER] -p[PASSWORD] [DBNAME] KR_participantsHash  | gzip > $WORKPATH/$FILENAMEHASH
