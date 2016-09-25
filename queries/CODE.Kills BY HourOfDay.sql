SELECT HOUR(kill_time) as hourofday, count(killID) as codekills
FROM KR_participants p2 
WHERE p2.allianceID in (99002775)
AND p2.finalBlow = 1
GROUP BY HOUR(kill_time)
ORDER BY  HOUR(kill_time)
