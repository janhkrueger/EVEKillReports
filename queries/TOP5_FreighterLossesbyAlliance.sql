SELECT allianceID, allianceName, count(killID) as losses, sum(totalValue) as sumTotalValue
FROM KR_participants 
WHERE shipTypeID in (20183,20185,20187,20189,34328)
AND isVictim = 1
AND allianceName  IS NOT NULL
AND allianceID != 0
GROUP BY allianceName
ORDER BY sumTotalValue DESC
LIMIT 0,5
