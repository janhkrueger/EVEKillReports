SELECT count(BurnAmarr2015.characterID) AS anzahl, BurnAmarr2015.characterName AS characterName 
FROM BurnAmarr2015
WHERE (BurnAmarr2015.isVictim = 0) 
GROUP BY BurnAmarr2015.characterID 
ORDER BY count(BurnAmarr2015.characterID) 
DESC LIMIT 0,10
