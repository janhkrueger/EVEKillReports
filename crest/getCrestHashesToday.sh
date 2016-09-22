#! /bin/sh

# Used to collect to kills of the current day. Ideal to start crawling at the day when they occur, not only a day after.

JETZT="$(date "+%Y%m%d")"
FILENAME=$JETZT.json.gz
FILEJSON=$JETZT.json
FILEBRO=$JETZT.json.bro

# collect the data as gzip compressed file
wget 'https://zkillboard.com/api/history/'$JETZT'/' --https-only --header='Accept-Encoding: gzip' -O /var/games/KillReporter/crest/$FILENAME
gunzip $FILENAME
/usr/bin/python2.7 /var/games/KillReporter/crest/importCrestHashes.py $FILEJSON
/var/brotli/tools/bro --quality 10 --input $FILEJSON --output $FILEBRO
mv -f $FILEBRO data/
rm $FILEJSON
