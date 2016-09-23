# EVEKillReports
ScriptCollection for EVE Online


=============
### crest
Files under this folder are used to get the crestdumps from zKillBoard. The killID and the cresthash are written into the database in the table KR_participantsHash.

Usage:
- Create the database structure with KR_participantsHash.sql
- create a subfolder "data" where the shell scripts are located
- chmod +x getCrestHashesToday.sh
- start getCrestHashesToday.sh

Now the crest dump of the currect day will be fetched, gzipped, unpacked, stored with importCrestHashes.py, then compressed with googles brotli and moved to the subfolder "data".

I created getCrestHashes7DaysBefore.sh so I can get a week old dump just if there are kills who are reported later to zKillBoard. getCrestHashesYesterday.sh are for, well, the dumps from yesterday. I call this a 4 am every day before I start creating graphs and other stuff to make sure I have the kills from the previous day.
