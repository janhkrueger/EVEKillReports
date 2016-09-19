#! /bin/sh

# calculate the timestamp from last day
JETZT="$(date "+%Y%m%d" -d "1 days ago")"
FILENAME=$JETZT.json.gz
FILEJSON=$JETZT.json

# get the gzip compressed crest dump and unzip.
wget 'https://zkillboard.com/api/history/'$JETZT'/' --https-only --header='Accept-Encoding: gzip' -O /var/games/KillReporter/crest/$FILENAME
gunzip $FILENAME

# import the saved dump, delete afterwars
/usr/bin/python2.7 /var/games/KillReporter/crest/importCrestHashes.py $FILEJSON
rm $FILEJSON
