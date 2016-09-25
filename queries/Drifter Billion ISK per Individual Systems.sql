select date(p1.kill_time) as surveydate, count(p1.solarSystemID) as individualSystems, sum(p1.totalValue) as ISKValue
from KR_participants p1
where ( (p1.isVictim = 1) and p1.killID in (select p2.killID from KR_participants p2 where ((p2.characterID in (3019581,3019582)) 
and (p2.finalBlow = 1)
))
)
GROUP BY date(p1.kill_time)
