SELECT DAYNAME(kill_time) as weekday, count(killID) as codekills
FROM KR_participants p2 
WHERE p2.allianceID in (99002775)
AND p2.finalBlow = 1
GROUP BY DAYNAME(kill_time)
ORDER BY  WEEKDAY(kill_time)
