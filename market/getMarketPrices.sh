#! /bin/sh
JETZT="$(date "+%Y%m%d_%H%m%s")"
FILENAME=$JETZT.json.gz
FILEJSON=$JETZT.json


wget 'https://crest-tq.eveonline.com/market/prices/' --https-only --header='Accept-Encoding: gzip' -O /var/games/KillReporter/market/$FILENAME
gunzip $FILENAME


#/usr/bin/python2.7 /var/games/KillReporter/crest/loadCrestHashes.py $FILEJSON
# zStandard
#mv -f $FILEBRO imported/
#rm $FILEJSON
#/var/games/KillReporter/killmails/killloadKillMailsYoungestSingle.sh