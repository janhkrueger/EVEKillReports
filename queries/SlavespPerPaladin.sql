SELECT s.averagePrice as Slaves, p.averagePrice as Paladin, ROUND((p.averagePrice / s.averagePrice)+0.5) AS slavescount  
FROM universe.crestMarketPrices s, universe.crestMarketPrices p  
WHERE s.typeID = 3721 
AND p.typeID = 28659 
ORDER BY s.surveyDate desc, p.surveyDate desc 
LIMIT 1 OFFSET 0;
