# EVEKillReports
ScriptCollection for EVE Online


=============
### crest
Files under this folder are used to get the crestdumps from zKillBoard. The killID and the cresthash are written into the database in the table KR_participantsHash.
API location: https://zkillboard.com/api/history/20160923/

Sample data the API returns:
```json
{
"56233020": "c5f89b8b4a4ebfac3f359a87b72e73620fe9a786",
"56233021": "235aab9995679b943608a4183db0f42a74cf123e",
"56233022": "74c4f0c406da07d9996b1df3143a2e453bd71f9d"
}
```

Usage:
- Create the database structure with KR_participantsHash.sql
- create a subfolder "data" where the shell scripts are located
- chmod +x getCrestHashesToday.sh
- start ./getCrestHashesToday.sh

Now the crest dump of the currect day will be fetched, gzipped, unpacked, stored with importCrestHashes.py, then compressed with googles brotli and moved to the subfolder "data".

I created getCrestHashes7DaysBefore.sh so I can get a week old dump just if there are kills who are reported later to zKillBoard. getCrestHashesYesterday.sh are for, well, the dumps from yesterday. I call this a 4 am every day before I start creating graphs and other stuff to make sure I have the kills from the previous day.

Fully collected years are exported and stored ni their json format at google drive: https://drive.google.com/open?id=0Bwil0sr_nWxbeGhHaENUY25keDg, so feel free and grab them.

=============
### frogs
Reads the current queue status of Red Frog Freight from their public API: http://api.red-frog.org/queue.json.php

Usage:
- create table with createRedFrogStatus.sql
- chmod +x loadRedFrogFreightStatus.py
- start ./loadRedFrogFreightStatus.py

Sample data the API returns:
```json
{
  "lastUpdate": "2016-09-23 19:24:10",
  "nextUpdate": "2016-09-23 19:39:10",
  "outstandingContractTotal": "67",
  "inProgressContractTotal": "41",
  "24HourContractTotal": "67",
  "12HourContractTotal": "54",
  "12to24HourContractTotal": "13",
  "24to48HourContractTotal": "0",
  "Over48HourContractTotal": "0",
  "LastHourIssuedContractTotal": "3",
  "LastHourAcceptedContractTotal": "7",
  "LastHourCompletedContractTotal": "5",
  "LastDayIssuedContractTotal": "291",
  "LastDayAcceptedContractTotal": "262",
  "LastDayCompletedContractTotal": "257"
}
```

=============
### characters
Updates to current corporation of a character.

Usage:
- create tables with createKR_characterTables.sql
- chmod +x addCharIDsToWatch.sh
- chmod +x getChar.py
- start addCharIDsToWatch.sh Warning, depending on the database size could this initial run take a little time.
- start getChar.py as cronjob. This job looks which characters have not updated in the last 30 days and then starts collecting new data via crest from the CCP servers

=============
### queries
Collection of queries I run now and then against the database
