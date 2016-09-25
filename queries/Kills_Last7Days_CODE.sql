select * from 
KR_participants p1 
where (
		 (p1.isVictim = 1) 
	and p1.killID in (
		select p2.killID from KR_participants p2 where ((p2.allianceID in (99002775)) and (p2.finalBlow = 1))
		)

	) 
	and (p1.kill_time <= now()) 
	and (p1.kill_time >= (cast(now() as date) - interval 7 day)) 
order by p1.kill_time
