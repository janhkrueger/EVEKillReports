#/bin/sh
JETZT="$(date "+%Y%m%d_%H%M")"
FILENAME=importpsql_$JETZT

# Neues Verzeichnis anlegen
mv /var/games/KillReporter/killmails/killjson/importpsql/ /var/games/KillReporter/killmails/killjson/$FILENAME
mkdir /var/games/KillReporter/killmails/killjson/importpsql

# Altes Verzeichnis verschieben
tar cf /var/games/KillReporter/killmails/killjson/$FILENAME.tar /var/games/KillReporter/killmails/killjson/$FILENAME
sleep 1
rm -R $FILENAME/
/usr/local/bin/zstd --ultra -22 -r /var/games/KillReporter/killmails/killjson/$FILENAME.tar
sleep 1
rm /var/games/KillReporter/killmails/killjson/$FILENAME.tar
gdrive upload /var/games/KillReporter/killmails/killjson/$FILENAME.tar.zst
sleep 1
rm /var/games/KillReporter/killmails/killjson/$FILENAME.tar.zst
