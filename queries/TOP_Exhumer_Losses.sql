SELECT characterName, count(killID) as anzahl
FROM Last7Days_Exhumer
GROUP BY characterName
HAVING anzahl > 1
ORDER BY anzahl desc
LIMIT 0,10
