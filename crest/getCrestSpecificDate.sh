#! /bin/sh
# Just insert the date you want to collect the crest hashes
JETZT=20071204
FILENAME=$JETZT.json.gz
FILEJSON=$JETZT.json
FILEBRO=$JETZT.json.bro

wget 'https://zkillboard.com/api/history/'$JETZT'/' --https-only --header='Accept-Encoding: gzip' -O /var/games/KillReporter/crest/$FILENAME
gunzip $FILENAME
/usr/bin/python2.7 /var/games/KillReporter/crest/loadCrestHashes.py $FILEJSON
/var/brotli/tools/bro --quality 10 --input $FILEJSON --output $FILEBRO
mv -f $FILEBRO data/
rm $FILEJSON
