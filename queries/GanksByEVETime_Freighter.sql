SELECT HOUR(kill_time) as hourofday, count(killID) as freighterlosses
FROM KR_participants 
WHERE shipTypeID in (SELECT typeID FROM invTypes
WHERE groupID = 513)
AND isVictim = 1
GROUP BY HOUR(kill_time)
ORDER BY  HOUR(kill_time)
