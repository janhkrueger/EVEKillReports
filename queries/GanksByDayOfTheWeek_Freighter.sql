SELECT DAYNAME(kill_time) as weekday, count(killID) as freighterlosses
FROM KR_participants 
WHERE shipTypeID in (SELECT typeID FROM invTypes
WHERE groupID = 513)
AND isVictim = 1
GROUP BY DAYNAME(kill_time)
ORDER BY  WEEKDAY(kill_time)
