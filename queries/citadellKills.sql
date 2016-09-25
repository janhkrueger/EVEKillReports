-- Quick selection about citadell kills in 2016

select year(KR_participants.kill_time) as year, month(KR_participants.kill_time) as month, REPLACE(REPLACE(REPLACE(KR_participants.shipTypeID, 35832, 'Astrahus'), 35833, 'Fortizar'), 35834, 'Keepstar') as type, count(KR_participants.killID) as losses
from KR_participants PARTITION (p2016)
where KR_participants.shipTypeID in (35832, 35833, 35834, 40340) and KR_participants.isVictim = 1 
group by year(KR_participants.kill_time), month(KR_participants.kill_time), KR_participants.shipTypeID;
