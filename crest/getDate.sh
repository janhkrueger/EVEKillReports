#! /bin/sh

i=1
max=4000
while [ $i -lt $max ]
do
  JETZT="$(date "+%Y%m%d" -d "$i days ago")"
  echo $JETZT
  FILENAME=$JETZT.json.gz
  FILEJSON=$JETZT.json
  FILEBRO=$JETZT.json.bro
  wget 'https://zkillboard.com/api/history/'$JETZT'/' --https-only --header='Accept-Encoding: gzip' -O /var/games/KillReporter/crest/$FILENAME
  gunzip $FILENAME
  /usr/bin/python2.7 /var/games/KillReporter/crest/loadCrestHashes.py $FILEJSON
  /var/brotli/tools/bro --quality 10 --input $FILEJSON --output $FILEBRO
  mv -f $FILEBRO data/
  rm $FILEJSON
  sleep 7m
  true $((i=i+1))
done
