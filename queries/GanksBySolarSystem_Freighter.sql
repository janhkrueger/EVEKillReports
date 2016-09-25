SELECT p1.solarSystemID, mss.solarSystemName, count(p1.killID) as freighterlosses, mss.security, IF(mss.security >=0.5, 'HighSec', IF(mss.security <=0.0, 'NullSec', 'LowSec')) as SystemSecurity
FROM KR_participants p1, mapSolarSystems mss
WHERE p1.shipTypeID in (SELECT typeID FROM invTypes
WHERE groupID = 513)
AND p1.isVictim = 1
AND mss.solarSystemID = p1.solarSystemID
GROUP BY p1.solarSystemID
ORDER BY freighterlosses DESC
