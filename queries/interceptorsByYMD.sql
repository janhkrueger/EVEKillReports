-- Kills Interceptoren nach Jahr, Monat, Woche mit KillAnzahl
select YEAR(p.kill_time), MONTH(p.kill_time), WEEK(p.kill_time), p.shipTypeID, count(p.killID)
from KR_participants PARTITION (p2016) p, invGroups iG, invTypes iT 
where p.isVictim = 1 
and p.shipTypeID = iT.typeID
and iT.groupID = iG.groupID
and iG.groupName = 'Interceptor'
GROUP BY YEAR(p.kill_time) DESC, MONTH(p.kill_time) DESC, WEEK(p.kill_time) DESC, p.shipTypeID
