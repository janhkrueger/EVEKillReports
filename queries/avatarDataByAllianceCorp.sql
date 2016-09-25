SELECT characterName, corporationName, allianceName, isVictim, shipTypeID, kill_time
FROM KR_participants 
WHERE shipTypeID = 11567
GROUP BY allianceName, corporationName, characterName, isVictim
