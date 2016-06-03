-- Revenant
SELECT p.*
FROM KR_participants p
JOIN invTypes iT
WHERE iT.typeName = 'Revenant'
AND p.shipTypeID = iT.typeID;

-- Revenant last loss
SELECT * 
FROM Revenant
WHERE isVictim = 1 
ORDER BY kill_time DESC
LIMIT 0,1;

-- Revenant last seen
SELECT * 
FROM Revenant
ORDER BY kill_time DESC
LIMIT 0,1;