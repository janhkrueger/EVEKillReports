SELECT 
  p.killID, 
  p.solarSystemID, 
  mss.solarSystemName AS solarSystemName, 
  round(avg(mss.security),2) AS avgsecurity,
  if((avg(mss.security) >= 0.5),'HighSec',if((avg(mss.security) <= 0.0),'NullSec','LowSec')) AS SystemSecurity 
FROM 
  KR_participants PARTITION (p2016) p, 
  mapSolarSystems mss,
  mapRegions mr 
WHERE 
  p.shipTypeID = 35832 AND 
  p.isVictim = 1 AND 
  p.solarSystemID = mss.solarSystemID AND 
  mr.regionID = mss.regionID
group by 
  mss.solarSystemName, killID
order by SystemSecurity
