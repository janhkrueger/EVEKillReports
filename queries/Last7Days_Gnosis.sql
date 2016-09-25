SELECT * 
FROM KR_participants 
WHERE shipTypeID = 3756 
AND isVictim = 1
AND kill_time <= now() 
AND kill_time >= (cast(now() as date) - interval 7 day)
ORDER BY kill_time
