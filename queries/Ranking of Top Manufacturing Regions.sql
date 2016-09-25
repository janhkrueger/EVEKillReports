SELECT mr.regionName,round((sum(ci.copyIndex)*100),2) as sumcopyindex, round(avg(mss.security),2) as avgsecurity, IF( avg(mss.security) >=0.5, 'HighSec', IF( avg(mss.security) <=0.0, 'NullSec', 'LowSec')) as SystemSecurity, ci.surveyDate
FROM industryCostIndexes ci
	JOIN mapSolarSystems mss
	ON (ci.solarSystemID = mss.solarSystemID)
	JOIN mapRegions mr
	ON (mr.regionID = mss.regionID)
-- WHERE mr.regionName = 'Domain'
WHERE surveyDate = ( select max(c2.surveyDate) FROM industryCostIndexes c2 )
-- AND ci.solarSystemName = 'Alkabsi'
GROUP BY mr.regionName
ORDER BY sumcopyindex desc
