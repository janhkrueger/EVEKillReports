SELECT *
FROM KR_participants
WHERE solarSystemID in (select solarSystemID
from mapSolarSystems
WHERE regionID = 11000033)
AND isVictim = 1
ORDER BY kill_time
