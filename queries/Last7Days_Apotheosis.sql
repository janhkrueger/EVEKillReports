select * 
from KR_participants 
where (
	(KR_participants.shipTypeID in (29266)) 
	and (KR_participants.isVictim = 1) 
	and (KR_participants.kill_time <= now()) 
	and (KR_participants.kill_time >= (cast(now() as date) - interval 7 day))) 
order by KR_participants.kill_time
