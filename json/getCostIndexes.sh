#! /bin/sh
JETZT="$(date "+%Y%m%d_%H%M%s")"
FILENAME=Industry_Systems_Costindexes_$JETZT.json.gz
FILEJSON=$JETZT.json

wget 'https://crest-tq.eveonline.com/industry/systems/' --https-only --header='Accept-Encoding: gzip' -O /var/games/KillReporter/json/$FILENAME
gunzip $FILENAME
# /usr/bin/python2.7 /var/games/KillReporter/json/loadIndustry.py
# rm /var/games/KillReporter/json/IndustrySystems.json