CREATE View CharacterRenamedCorporations
as
SELECT corporationID, corporationName, allianceID, allianceName 
FROM KR_characterUpdates 
WHERE (corporationName LIKE convert(concat('%',corporationID,'%') using utf8)) 
GROUP BY corporationName asc
