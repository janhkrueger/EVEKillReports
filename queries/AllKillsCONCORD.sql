select * from 
KR_participants p1 
where (
		 (p1.isVictim = 1) 
	and p1.killID in (
		select p2.killID from KR_participants p2 where ((p2.corporationID in (1000125)) and (p2.finalBlow = 1))
		)
	) 
order by p1.kill_time
