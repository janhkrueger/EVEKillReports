#! /bin/sh
JETZT="$(date "+%Y%m%d_%H%M%s")"
FILENAME=Jumps_$JETZT.xml

wget 'https://api.eveonline.com//map/Jumps.xml.aspx' --https-only --header='Accept-Encoding: gzip' -O /var/games/KillReporter/json/$FILENAME

# CUrrently not supported
# gunzip $FILENAME

# /usr/bin/python2.7 /var/games/KillReporter/json/loadJumps.py
# rm Jumps.xml