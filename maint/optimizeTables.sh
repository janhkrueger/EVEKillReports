#!/bin/bash

#mysqlcheck --user [USERNAME] --auto-repair --databases [DATABASE]  --optimize -p[PASSWORD] --skip-write-binlog --tables KR_characterHistory
#mysqlcheck --user [USERNAME] --auto-repair --databases [DATABASE]  --optimize -p[PASSWORD] --skip-write-binlog --tables KR_characterUpdates
#mysqlcheck --user [USERNAME] --auto-repair --databases [DATABASE]  --optimize -p[PASSWORD] --skip-write-binlog --tables KR_characterUpdatesPrio
#mysqlcheck --user [USERNAME] --auto-repair --databases [DATABASE]  --optimize -p[PASSWORD] --skip-write-binlog --tables KR_characterUpdatesWork
#mysqlcheck --user [USERNAME] --auto-repair --databases [DATABASE]  --optimize -p[PASSWORD] --skip-write-binlog --tables KR_Jobs
mysqlcheck --user [USERNAME] --auto-repair --databases [DATABASE]  --optimize -p[PASSWORD] --skip-write-binlog --tables KR_killCount
mysqlcheck --user [USERNAME] --auto-repair --databases [DATABASE]  --optimize -p[PASSWORD] --skip-write-binlog --tables KR_participantsCollected
mysqlcheck --user [USERNAME] --auto-repair --databases [DATABASE]  --optimize -p[PASSWORD] --skip-write-binlog --tables KR_participantsExpensiveLoss
#mysqlcheck --user [USERNAME] --auto-repair --databases [DATABASE]  --optimize -p[PASSWORD] --skip-write-binlog --tables KR_participantsHash
#mysqlcheck --user [USERNAME] --auto-repair --databases [DATABASE]  --optimize -p[PASSWORD] --skip-write-binlog --tables KR_participantsHashSave
mysqlcheck --user [USERNAME] --auto-repair --databases [DATABASE]  --optimize -p[PASSWORD] --skip-write-binlog --tables KR_remarkableKills
#mysqlcheck --user [USERNAME] --auto-repair --databases [DATABASE]  --optimize -p[PASSWORD] --skip-write-binlog --tables KR_wars
#mysqlcheck --user [USERNAME] --auto-repair --databases [DATABASE]  --optimize -p[PASSWORD] --skip-write-binlog --tables KR_warsWork
mysqlcheck --user [USERNAME] --auto-repair --databases [DATABASE]  --optimize -p[PASSWORD] --skip-write-binlog --tables KR_participants
mysqlcheck --user [USERNAME] --auto-repair --databases [DATABASE]  --optimize -p[PASSWORD] --skip-write-binlog --tables KR_alliance
