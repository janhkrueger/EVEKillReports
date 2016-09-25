select year(kill_time), count(killID)
from KR_participants 
where  shipTypeID in (SELECT typeID FROM invTypes WHERE groupID = 31)
and isVictim = 1
group by year(kill_time)
