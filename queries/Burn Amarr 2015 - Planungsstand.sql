SELECT * 
FROM KR_participants 
WHERE (
	(year(kill_time) = 2015) AND (month(kill_time) = 6) AND (dayofmonth(kill_time) >= 19) AND (dayofmonth(kill_time) <= 21) 
	AND (solarSystemID in (30002187,30003522,30003491,30002282,30002192,30002189,30005038))) 
	ORDER BY kill_time, killID, characterID
	
-- 30002187 Amarr
-- 30003522 Sarum Prime
-- 30003491 Ashab
-- 30002282	Bhizheba
-- 30002192	Irnin
-- 30002189	Hedion
-- 30005038	Kor-Azor Prime
