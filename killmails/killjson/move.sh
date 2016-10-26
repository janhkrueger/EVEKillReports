#/bin/sh

for file in $(ls -p *.json | grep -v / | tail -1000)
do
mv $file /var/games/KillReporter/killmails/killjson/later/
done

for file in $(ls -p *.json | grep -v / | tail -1000)
do
mv $file /var/games/KillReporter/killmails/killjson/later2/
done

for file in $(ls -p *.json | grep -v / | tail -2000)
do
mv $file /var/games/KillReporter/killmails/killjson/later3/
done

for file in $(ls -p *.json | grep -v / | tail -2000)
do
mv $file /var/games/KillReporter/killmails/killjson/later4/
done
