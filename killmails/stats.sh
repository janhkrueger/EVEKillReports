#!/bin/bash

SCRIPTNAME='basename $0'
LOCKFILENAME="/var/lock/KillReporter/`basename $0`"
if [ -z "$FLOCK_SET" ] ; then
exec env FLOCK_SET=1 flock -n "${LOCKFILENAME}" "$0" "$@"
fi

#mysql  -N -u -p -e "SELECT distinct p.killID FROM KR_participantsOld PARTITION (p2007, p2008, p2009, p2010, p2011, p2012, p2013, p2014, p2016) p, invTypes iT, invGroups iG, KR_participantsToCollect pTC WHERE p.isVictim = 1 AND p.shipTypeID = iT.typeID AND iT.groupID = iG.groupID AND iG.groupName = pTC.shipGroupName ORDER BY p.kill_time ASC LIMIT 1000;" 2>/dev/null |
#mysql  -N -u -p -e "SELECT distinct killID FROM KR_participantsOld PARTITION (p2016) WHERE isVictim=1 ORDER BY killID DESC LIMIT 1000;" 2>/dev/null |
mysql  -N -u -p -e "SELECT distinct p.killID FROM KR_participantsOld PARTITION (p2015) p, invTypes iT, invGroups iG, KR_participantsToCollect pTC WHERE p.isVictim = 1 AND p.shipTypeID = iT.typeID AND iT.groupID = iG.groupID AND iG.groupName = pTC.shipGroupName LIMIT 5000;" 2>/dev/null |

while IFS='\n' read killID; do
	echo ${killID}
	#./getHashSingle.py "${killID}"
	./loadKillMails_Manuell.py "${killID}"
	#sleep 0.4
done

rm ${LOCKFILENAME}
