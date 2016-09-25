select * 
from KR_participants 
where (
	(KR_participants.shipTypeID in (SELECT it.typeID FROM invTypes it WHERE it.groupID in (361,1246,1247,1249,1250,1273,1275,1276))) 
	and (KR_participants.isVictim = 1) 
	and (KR_participants.kill_time <= now()) 
	and (KR_participants.kill_time >= (cast(now() as date) - interval 7 day))) 
order by KR_participants.kill_time
