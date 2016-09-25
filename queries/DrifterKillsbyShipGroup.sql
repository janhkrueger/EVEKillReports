select ig.groupName as ShipClass, count(p1.killID) as sumships
from KR_participants p1, invTypes it, invGroups ig
where ( (p1.isVictim = 1) and p1.killID in (select p2.killID from KR_participants p2 where ((p2.characterID in (3019581,3019582)) 
and (p2.finalBlow = 1)
)))
AND it.typeID = p1.shipTypeID
AND ig.groupID = it.groupID
GROUP BY ig.groupName
