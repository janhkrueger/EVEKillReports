#! /bin/sh
JETZT="$(date "+%Y%m%d" -d "7 days ago")"
FILENAME=$JETZT.json.gz
FILEJSON=$JETZT.json

echo $JETZT
wget 'https://zkillboard.com/api/history/'$JETZT'/' --https-only --header='Accept-Encoding: gzip' -O /var/games/KillReporter/crest/$FILENAME
gunzip $FILENAME
/usr/bin/python2.7 /var/games/KillReporter/crest/importCrestHashes.py $FILEJSON
rm $FILEJSON
